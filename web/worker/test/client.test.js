import assert from "node:assert/strict";
import {readFile} from "node:fs/promises";
import {runInNewContext} from "node:vm";
import {test} from "node:test";

const root = new URL("../../",import.meta.url);
const appSource = await readFile(new URL("app.js",root),"utf8");
const zipSource = await readFile(new URL("zip.js",root),"utf8");

function readZipNames(archive) {
  const end = archive.length-22;
  assert.equal(archive.readUInt32LE(end),0x06054b50);
  const count = archive.readUInt16LE(end+10);
  let offset = archive.readUInt32LE(end+16);
  const names = [];
  for (let index = 0; index < count; index++) {
    assert.equal(archive.readUInt32LE(offset),0x02014b50);
    const nameLength = archive.readUInt16LE(offset+28);
    names.push(archive.subarray(offset+46,offset+46+nameLength).toString("utf8"));
    offset += 46+nameLength;
  }
  return names;
}

test("site loads and packages locally when the Worker is unreachable", async () => {
  const elements = new Map();
  const requested = [];
  let downloadedBlob;
  const files = new Map([
    ...Array.from({length:18},(_,index) => [`Q${index+1}_1.m`,`script-${index+1}`]),
    ["餐盘.jpg","image-bytes"],
    ["碱基对.txt","base-pairs"],
    ["手机号.xlsx","workbook-bytes"]
  ]);
  const manifest = {updatedAt:"2026-01-01T00:00:00Z",questions:Array.from({length:18},(_,index) => ({
    number:index+1,
    downloadCount:0,
    variants:[{file:`Q${index+1}_1.m`,downloadCount:0}]
  }))};
  const getElement = id => {
    if (!elements.has(id)) elements.set(id,{textContent:"",className:"",innerHTML:"",disabled:true,showModal(){this.open=true;},addEventListener(type,handler){this.listeners ||= {};this.listeners[type]=handler;}});
    return elements.get(id);
  };
  const document = {
    baseURI:"https://site.test/matlab/",
    body:{append(){}},
    getElementById:getElement,
    createElement(){return {click(){},remove(){}};}
  };
  class TestURL extends URL {
    static createObjectURL(blob) { downloadedBlob=blob; return "blob:homework"; }
    static revokeObjectURL() {}
  }
  const fetch = async input => {
    const url = new URL(input);
    assert.equal(url.origin,"https://site.test","page must not need a cross-origin service to start or download");
    requested.push(url.pathname);
    if (url.pathname === "/matlab/manifest.json") return Response.json(manifest);
    const filename = decodeURIComponent(url.pathname.split("/").at(-1));
    assert.ok(files.has(filename),`unexpected static asset ${filename}`);
    return new Response(files.get(filename));
  };
  const window = {MATLAB_COUNTER_API:"",MatlabZip:null,alert(){throw new Error("unexpected alert fallback");}};
  const context = {window,document,fetch,URL:TestURL,TextEncoder,Uint8Array,DataView,Blob,Response,AbortController,clearTimeout, setTimeout(){return 1;}};
  runInNewContext(zipSource,context);
  runInNewContext(appSource,context);
  await new Promise(resolve => setImmediate(resolve));

  const button = getElement("download-button");
  assert.equal(button.disabled,false);
  assert.match(getElement("download-status").textContent,/本站读取/);
  await button.listeners.click();
  assert.ok(downloadedBlob);
  assert.equal(downloadedBlob.type,"application/zip");
  assert.equal(getElement("ai-prompt-dialog").open,true);
  assert.ok(["豆包","千问","Kimi","Deepseek","混元","GLM","ChatGPT","Gemini"].includes(getElement("ai-model").textContent));
  const names = readZipNames(Buffer.from(await downloadedBlob.arrayBuffer()));
  assert.equal(names.length,21);
  for (let number = 1; number <= 18; number++) assert.ok(names.includes(`第一轮作业题/Q${number}.m`));
  for (const name of ["餐盘.jpg","碱基对.txt","手机号.xlsx"]) assert.ok(names.includes(`第一轮作业题/${name}`));
  assert.equal(requested.filter(path => path === "/matlab/manifest.json").length,1);
  assert.ok(requested.every(path => path.startsWith("/matlab/")));
});
