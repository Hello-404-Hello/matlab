import assert from "node:assert/strict";
import {test} from "node:test";
import worker from "../src/index.js";

const origin = "https://hello-404-hello.github.io";
const folder = "第一轮作业题";

function zipNames(buffer) {
  const end = buffer.length - 22;
  assert.equal(buffer.readUInt32LE(end), 0x06054b50, "ZIP end record");
  const count = buffer.readUInt16LE(end + 10);
  let offset = buffer.readUInt32LE(end + 16);
  const files = [];
  for (let index = 0; index < count; index++) {
    assert.equal(buffer.readUInt32LE(offset), 0x02014b50, "ZIP central directory entry");
    const nameLength = buffer.readUInt16LE(offset + 28);
    const extraLength = buffer.readUInt16LE(offset + 30);
    const commentLength = buffer.readUInt16LE(offset + 32);
    const name = buffer.subarray(offset + 46, offset + 46 + nameLength).toString("utf8");
    const flags = buffer.readUInt16LE(offset + 8);
    const method = buffer.readUInt16LE(offset + 10);
    const localOffset = buffer.readUInt32LE(offset + 42);
    const localNameLength = buffer.readUInt16LE(localOffset + 26);
    const localExtraLength = buffer.readUInt16LE(localOffset + 28);
    const size = buffer.readUInt32LE(offset + 24);
    const bodyStart = localOffset + 30 + localNameLength + localExtraLength;
    const payload = buffer.subarray(bodyStart, bodyStart + size);
    assert.equal(flags & 0x0800,0x0800,"UTF-8 filenames");
    assert.equal(method,0,"stored ZIP entries");
    assert.equal(buffer.readUInt32LE(offset + 16),crc32(payload),"ZIP entry CRC");
    files.push({name,payload});
    offset += 46 + nameLength + extraLength + commentLength;
  }
  return files;
}

function crc32(bytes) {
  let value = 0xffffffff;
  for (const byte of bytes) {
    value ^= byte;
    for (let bit = 0; bit < 8; bit++) value = value & 1 ? 0xedb88320 ^ (value >>> 1) : value >>> 1;
  }
  return (value ^ 0xffffffff) >>> 0;
}

test("GET lists live variants with missing counter rows at zero; POST builds a randomized package and records selected versions", async () => {
  let countDocument = "# 解法下载次数\n\n| 解法文件 | 下载次数 |\n|---|---:|\n";
  let currentSha = "counts-sha-1";
  const scripts = [];
  for (let question = 1; question <= 18; question++) {
    const version = question === 3 ? 2 : 1;
    const name = `m${question}_${version}.m`;
    scripts.push({name,type:"file",download_url:`https://raw.test/${name}`});
  }
  const imageBytes = Buffer.from([0xff,0xd8,0xff,0x00,0x11]);
  const supportFiles = new Map([
    ["餐盘.jpg",{rawName:"tray.jpg",bytes:imageBytes}],
    ["碱基对.txt",{rawName:"bases.txt",bytes:Buffer.from("上链\nACGT\n下链\nTGCA\n","utf8")}],
    ["手机号.xlsx",{rawName:"phones.xlsx",bytes:Buffer.from([0x50,0x4b,0x03,0x04,0x00,0x01])}]
  ]);
  const originalFetch = globalThis.fetch;
  globalThis.fetch = async (input, init = {}) => {
    const url = new URL(input instanceof Request ? input.url : input);
    if (url.hostname === "raw.test") {
      const asset = [...supportFiles.values()].find(file => `/${file.rawName}` === url.pathname);
      if (asset) return new Response(asset.bytes);
      const source = url.pathname.slice(1);
      return new Response(`disp('${source}')\n`, {status:200});
    }
    if (url.hostname !== "api.github.com") return new Response("not found", {status:404});
    const marker = "/contents/";
    const path = decodeURIComponent(url.pathname.slice(url.pathname.indexOf(marker) + marker.length));
    if (init.method === "PUT" && path === "web/download-counts.md") {
      const body = JSON.parse(init.body);
      countDocument = Buffer.from(body.content,"base64").toString("utf8");
      currentSha = "counts-sha-updated";
      return Response.json({content:{sha:currentSha}}, {status:200});
    }
    if (path === folder && (!init.method || init.method === "GET")) return Response.json(scripts);
    if (path.startsWith(`${folder}/`) && (!init.method || init.method === "GET")) {
      const file = supportFiles.get(path.slice(folder.length + 1));
      if (file) return Response.json({download_url:`https://raw.test/${file.rawName}`});
    }
    if (path === "web/download-counts.md" && (!init.method || init.method === "GET")) {
      return Response.json({content:Buffer.from(countDocument).toString("base64"),sha:currentSha});
    }
    return new Response(JSON.stringify({path,method:init.method}), {status:404});
  };

  const env = {GITHUB_OWNER:"Hello-404-Hello",GITHUB_REPO:"matlab",GITHUB_BRANCH:"main",GITHUB_TOKEN:"test-token",SITE_ORIGIN:origin};
  try {
    const countsResponse = await worker.fetch(new Request("https://worker.test/counts", {headers:{Origin:origin}}), env);
    assert.equal(countsResponse.status,200,await countsResponse.clone().text());
    const counts = await countsResponse.json();
    assert.equal(counts.questions.length,18);
    assert.equal(counts.questions[2].variants[0].file,"m3_2.m");
    assert.equal(counts.questions[2].variants[0].downloadCount,0);

    const downloadResponse = await worker.fetch(new Request("https://worker.test/download", {method:"POST",headers:{Origin:origin,"Content-Type":"application/json"},body:"{}"}), env);
    assert.equal(downloadResponse.status,200);
    assert.match(downloadResponse.headers.get("Content-Type"),/application\/zip/);
    const files = zipNames(Buffer.from(await downloadResponse.arrayBuffer()));
    assert.equal(files.length,21);
    for (let question = 1; question <= 18; question++) assert.ok(files.some(file => file.name === `${folder}/m${question}.m`));
    for (const [name,file] of supportFiles) {
      assert.ok(files.some(entry => entry.name === `${folder}/${name}`));
      assert.deepEqual(files.find(entry => entry.name === `${folder}/${name}`).payload,file.bytes);
    }
    assert.match(files.find(file => file.name === `${folder}/m3.m`).payload.toString("utf8"),/m3_2\.m/);
    assert.match(countDocument,/\| m3_2\.m \| 1 \|/);
    assert.equal((countDocument.match(/^\|\s*m\d+_\d+\.m\s*\|\s*1\s*\|$/gm) || []).length,18);
  } finally {
    globalThis.fetch = originalFetch;
  }
});
