import assert from "node:assert/strict";
import {readFile} from "node:fs/promises";
import {runInNewContext} from "node:vm";
import {test} from "node:test";

const source = await readFile(new URL("../../zip.js",import.meta.url),"utf8");
const window = {};
runInNewContext(source,{window,TextEncoder,Uint8Array,DataView,Blob,Date});

function crc32(bytes) {
  let value = 0xffffffff;
  for (const byte of bytes) {
    value ^= byte;
    for (let bit = 0; bit < 8; bit++) value = value & 1 ? 0xedb88320 ^ (value >>> 1) : value >>> 1;
  }
  return (value ^ 0xffffffff) >>> 0;
}

test("browser ZIP writer stores UTF-8 paths and intact file bytes", async () => {
  const entries = [
    {name:"第一轮作业题/m1.m",data:new TextEncoder().encode("disp('hello')")},
    {name:"第一轮作业题/碱基对.txt",data:new TextEncoder().encode("上链\nACGT\n")}
  ];
  const archive = Buffer.from(await window.MatlabZip.create(entries).arrayBuffer());
  const end = archive.length - 22;
  assert.equal(archive.readUInt32LE(end),0x06054b50);
  assert.equal(archive.readUInt16LE(end+10),entries.length);

  let offset = archive.readUInt32LE(end+16);
  const names = [];
  for (let index = 0; index < entries.length; index++) {
    assert.equal(archive.readUInt32LE(offset),0x02014b50);
    const flags = archive.readUInt16LE(offset+8);
    const method = archive.readUInt16LE(offset+10);
    const nameLength = archive.readUInt16LE(offset+28);
    const localOffset = archive.readUInt32LE(offset+42);
    const name = archive.subarray(offset+46,offset+46+nameLength).toString("utf8");
    const localNameLength = archive.readUInt16LE(localOffset+26);
    const localExtraLength = archive.readUInt16LE(localOffset+28);
    const size = archive.readUInt32LE(offset+24);
    const start = localOffset+30+localNameLength+localExtraLength;
    const data = archive.subarray(start,start+size);
    assert.equal(flags&0x0800,0x0800);
    assert.equal(method,0);
    assert.equal(archive.readUInt32LE(offset+16),crc32(data));
    assert.deepEqual(data,Buffer.from(entries[index].data));
    names.push(name);
    offset += 46+nameLength;
  }
  assert.deepEqual(names,entries.map(entry => entry.name));
});
