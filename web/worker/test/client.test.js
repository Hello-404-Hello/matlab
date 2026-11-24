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

test("both rounds package locally, with no scripts substituted for round two GUI files", async () => {
  const elements = new Map();
  const requested = [];
  let downloadedBlob;
  const makeManifest = (folder, assetDirectory, count, attachments, apps = []) => ({
    folder, assetDirectory, attachments, updatedAt:null,
    questions:Array.from({length:count},(_,index) => {
      const number = index+1;
      const extension = apps.includes(number) ? "mlapp" : "m";
      return {number,title:`题 ${number}`,downloadCount:0,variants:[
        {file:`Q${number}_1.${extension}`,downloadName:`Q${number}.${extension}`,downloadCount:0}
      ]};
    })
  });
  const manifest = makeManifest("第一轮作业题","solutions",22,["餐盘.jpg","碱基对.txt","手机号.xlsx","A1.png","A2.png"]);
  const second = makeManifest("第二轮作业题","round2-solutions",18,["ps.jpg","pt.xlsx","Roster.xlsx","Temp2.xlsx"],[5,17]);
  const assets = new Set([manifest,second].flatMap(m => [
    ...m.questions.map(q => `/matlab/${m.assetDirectory}/${q.variants[0].file}`),
    ...m.attachments.map(file => `/matlab/${m.assetDirectory}/${file}`)
  ]));
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
    if (url.pathname === "/matlab/round2-manifest.json") return Response.json(second);
    assert.ok(assets.has(decodeURIComponent(url.pathname)),`unexpected static asset ${url.pathname}`);
    return new Response(url.pathname);
  };
  const window = {MATLAB_COUNTER_API:"",MatlabZip:null,alert(){throw new Error("unexpected alert fallback");}};
  const context = {window,document,fetch,URL:TestURL,TextEncoder,Uint8Array,DataView,Blob,Response,AbortController,clearTimeout, setTimeout(){return 1;}};
  runInNewContext(zipSource,context);
  runInNewContext(appSource,context);
  await new Promise(resolve => setImmediate(resolve));

  const button = getElement("download-button");
  assert.equal(button.disabled,false);
  assert.equal(getElement("download-button-round2").disabled,false);
  await button.listeners.click();
  assert.ok(downloadedBlob);
  assert.equal(downloadedBlob.type,"application/zip");
  assert.equal(getElement("ai-prompt-dialog").open,true);
  assert.ok(["豆包","千问","Kimi","Deepseek","混元","GLM","ChatGPT","Gemini"].includes(getElement("ai-model").textContent));
  const names = readZipNames(Buffer.from(await downloadedBlob.arrayBuffer()));
  assert.equal(names.length,27);
  for (let number = 1; number <= 22; number++) assert.ok(names.includes(`第一轮作业题/Q${number}.m`));
  for (const name of ["餐盘.jpg","碱基对.txt","手机号.xlsx","A1.png","A2.png"]) assert.ok(names.includes(`第一轮作业题/${name}`));
  await getElement("download-button-round2").listeners.click();
  const secondNames = readZipNames(Buffer.from(await downloadedBlob.arrayBuffer()));
  assert.equal(secondNames.length,22);
  for (const q of second.questions) {
    assert.ok(secondNames.includes(`${second.folder}/${q.variants[0].downloadName}`));
  }
  for (const file of second.attachments) assert.ok(secondNames.includes(`${second.folder}/${file}`));
  assert.ok(secondNames.every(name => name.startsWith(second.folder + "/")));
  assert.ok(!secondNames.some(name => /\/Q(?:5|17)\.m$/.test(name)));
  assert.equal(requested.filter(path => path === "/matlab/manifest.json").length,1);
  assert.equal(requested.filter(path => path === "/matlab/round2-manifest.json").length,1);
  assert.ok(requested.every(path => path.startsWith("/matlab/")));
});
