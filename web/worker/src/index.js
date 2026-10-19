const QUESTION_COUNT = 18;
const COUNTS_PATH = "web/download-counts.md";
const QUESTION_FOLDER = "第一轮作业题";
const QUESTION_TITLES = [
  "随机矩阵乘法", "倒序序列删数", "MATLAB 变量名", "多边形车轮", "八方向求和", "餐盘面积",
  "购买任务", "分解为 3 和 5", "手机号三连号", "DNA 配对", "虚位密码锁", "随机车牌",
  "地铁计费", "随机帐篷安排", "网格连通", "区间售票", "灯光分布", "快递站选址"
];
const encoder = new TextEncoder();

export default {
  async fetch(request, env) {
    const origin = request.headers.get("Origin") || "";
    if (!isAllowedOrigin(origin, env)) return json({error:"不允许的访问来源"}, 403);
    const cors = corsHeaders(origin);
    if (request.method === "OPTIONS") return new Response(null, {status:204,headers:cors});
    if (!env.GITHUB_TOKEN) return json({error:"Worker 尚未配置 GitHub Token"}, 503, cors);

    const path = new URL(request.url).pathname.replace(/\/+$/, "") || "/";
    try {
      if (request.method === "GET" && path === "/counts") {
        const data = await loadRepoState(env);
        return json(makeCountsResponse(data.files, data.countsDoc), 200, cors);
      }
      if (request.method === "POST" && path === "/record") {
        const body = await request.json();
        if (!Array.isArray(body.files) || body.files.length !== QUESTION_COUNT) {
          return json({error:"每题需要恰好提交一个解法版本"}, 400, cors);
        }
        const data = await loadRepoState(env);
        const available = new Map(data.files.map(file => [file.name,file]));
        const selected = body.files.map(name => available.get(name));
        const questions = new Set(selected.filter(Boolean).map(file => file.number));
        if (selected.some(file => !file) || questions.size !== QUESTION_COUNT) {
          return json({error:"解法版本无效或题目重复"}, 400, cors);
        }
        const updated = await incrementCounts(env, body.files);
        return json({updatedAt:updated.updatedAt}, 200, cors);
      }
      if (request.method === "POST" && path === "/download") {
        const data = await loadRepoState(env);
        const selected = chooseVersions(data.files);
        const entries = await fetchPackageFiles(env, selected);
        const zip = makeZip(entries);
        const updated = await incrementCounts(env, selected.map(item => item.name));
        const headers = new Headers(cors);
        headers.set("Content-Type", "application/zip");
        headers.set("Content-Disposition", "attachment; filename=matlab-homework.zip; filename*=UTF-8''%E7%AC%AC%E4%B8%80%E8%BD%AE%E4%BD%9C%E4%B8%9A%E9%A2%98-%E9%9A%8F%E6%9C%BA%E8%A7%A3%E6%B3%95.zip");
        headers.set("Cache-Control", "no-store");
        headers.set("X-Selected-Solutions", selected.map(item => item.name).join(","));
        headers.set("X-Updated-At", updated.updatedAt);
        return new Response(zip, {status:200,headers});
      }
      return json({error:"接口不存在"}, 404, cors);
    } catch (error) {
      return json({error:error instanceof Error ? error.message : "服务暂时不可用"}, 502, cors);
    }
  }
};

function isAllowedOrigin(origin, env) {
  const allowed = [env.SITE_ORIGIN, ...(env.DEV_ORIGINS || "").split(",")].filter(Boolean);
  return allowed.includes(origin);
}

function corsHeaders(origin) {
  return new Headers({
    "Access-Control-Allow-Origin": origin,
    "Access-Control-Allow-Methods": "GET,POST,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Access-Control-Expose-Headers": "X-Selected-Solutions,X-Updated-At,Content-Disposition",
    "Access-Control-Max-Age": "86400",
    "Vary": "Origin"
  });
}

function json(value, status = 200, headers = new Headers()) {
  const output = new Headers(headers);
  output.set("Content-Type", "application/json; charset=utf-8");
  output.set("Cache-Control", "no-store");
  return new Response(JSON.stringify(value), {status,headers:output});
}

function apiBase(env) {
  return `https://api.github.com/repos/${env.GITHUB_OWNER}/${env.GITHUB_REPO}`;
}

function githubHeaders(env) {
  return {
    "Authorization": `Bearer ${env.GITHUB_TOKEN}`,
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2022-11-28",
    "User-Agent": "matlab-homework-download-counter",
    "Cache-Control": "no-cache"
  };
}

function contentsUrl(env, path) {
  const encodedPath = path.split("/").map(encodeURIComponent).join("/");
  return `${apiBase(env)}/contents/${encodedPath}?ref=${encodeURIComponent(env.GITHUB_BRANCH || "main")}`;
}

async function githubResponse(env, url, options = {}) {
  const response = await fetch(url, { ...options, headers:{...githubHeaders(env),...(options.headers || {})} });
  if (!response.ok) {
    const details = await response.text();
    throw new Error(`GitHub API ${response.status}: ${details.slice(0,220)}`);
  }
  return response;
}

async function loadRepoState(env) {
  const [directoryResponse, countDoc] = await Promise.all([
    githubResponse(env, contentsUrl(env, QUESTION_FOLDER)),
    getCountDoc(env)
  ]);
  const listing = await directoryResponse.json();
  if (!Array.isArray(listing)) throw new Error("GitHub 题目目录读取失败");
  const files = listing.filter(file => file.type === "file" && file.name.endsWith(".m"))
    .map(file => {
      const match = file.name.match(/^Q(1[0-8]|[1-9])_(\d+)\.m$/);
      return match ? {number:Number(match[1]),version:Number(match[2]),name:file.name,url:file.download_url} : null;
    }).filter(Boolean);
  return {files,countsDoc:countDoc};
}

async function getCountDoc(env) {
  const response = await fetch(contentsUrl(env, COUNTS_PATH), {headers:githubHeaders(env)});
  if (response.status === 404) return {text:"",sha:null};
  if (!response.ok) {
    const details = await response.text();
    throw new Error(`读取下载次数文档失败：GitHub API ${response.status} ${details.slice(0,180)}`);
  }
  const file = await response.json();
  return {text:decodeBase64(file.content || ""),sha:file.sha};
}

function decodeBase64(value) {
  const binary = atob(value.replace(/\s/g,""));
  const bytes = Uint8Array.from(binary, char => char.charCodeAt(0));
  return new TextDecoder().decode(bytes);
}

function parseCounts(text) {
  const counts = new Map();
  for (const line of text.split(/\r?\n/)) {
    const match = line.match(/^\|\s*(Q(?:1[0-8]|[1-9])_\d+\.m)\s*\|\s*(\d+)\s*\|$/);
    if (match) counts.set(match[1], Number(match[2]));
  }
  return counts;
}

function sortSolutionNames(names) {
  return [...names].sort((left,right) => {
    const a = left.match(/^Q(\d+)_(\d+)\.m$/).slice(1).map(Number);
    const b = right.match(/^Q(\d+)_(\d+)\.m$/).slice(1).map(Number);
    return a[0]-b[0] || a[1]-b[1];
  });
}

function makeCountsResponse(files, countDoc) {
  const counts = parseCounts(countDoc.text);
  const questions = Array.from({length:QUESTION_COUNT}, (_, index) => {
    const number = index + 1;
    const variants = files.filter(file => file.number === number)
      .sort((a,b) => a.version-b.version)
      .map(file => ({file:file.name,downloadCount:counts.get(file.name) || 0}));
    return {number,downloadCount:variants.reduce((sum,item) => sum + item.downloadCount,0),variants};
  });
  const updated = countDoc.text.match(/^最后更新：(.+)$/m);
  return {questions,updatedAt:updated ? updated[1].trim() : null};
}

function secureRandomIndex(limit) {
  const range = 0x100000000;
  const ceiling = Math.floor(range / limit) * limit;
  const values = new Uint32Array(1);
  do { crypto.getRandomValues(values); } while (values[0] >= ceiling);
  return values[0] % limit;
}

function chooseVersions(files) {
  const selected = [];
  for (let number = 1; number <= QUESTION_COUNT; number++) {
    const choices = files.filter(file => file.number === number);
    if (!choices.length) throw new Error(`第 ${number} 题暂时没有可下载的解法`);
    selected.push(choices[secureRandomIndex(choices.length)]);
  }
  return selected;
}

async function fetchPackageFiles(env, selected) {
  const requests = selected.map(async solution => {
    const response = await fetch(solution.url, {headers:{"Cache-Control":"no-cache"}});
    if (!response.ok) throw new Error(`下载 ${solution.name} 失败：${response.status}`);
    const data = new Uint8Array(await response.arrayBuffer());
    const finalName = solution.name.replace(/_\d+(?=\.m$)/, "");
    return {name:`${QUESTION_FOLDER}/${finalName}`,data};
  });
  const scriptEntries = await Promise.all(requests);
  const supportFiles = ["餐盘.jpg","碱基对.txt","手机号.xlsx"];
  const supportEntries = await Promise.all(supportFiles.map(async name => {
    const fileResponse = await githubResponse(env, contentsUrl(env, `${QUESTION_FOLDER}/${name}`));
    const fileInfo = await fileResponse.json();
    const raw = await fetch(fileInfo.download_url, {headers:{"Cache-Control":"no-cache"}});
    if (!raw.ok) throw new Error(`下载${name}失败：${raw.status}`);
    return {name:`${QUESTION_FOLDER}/${name}`,data:new Uint8Array(await raw.arrayBuffer())};
  }));
  scriptEntries.push(...supportEntries);
  return scriptEntries;
}

async function incrementCounts(env, selectedNames) {
  for (let attempt = 0; attempt < 5; attempt++) {
    const doc = await getCountDoc(env);
    const counts = parseCounts(doc.text);
    for (const name of selectedNames) counts.set(name, (counts.get(name) || 0) + 1);
    const updatedAt = new Date().toISOString();
    const totals = Array(QUESTION_COUNT).fill(0);
    for (const [name,count] of counts) {
      const match = name.match(/^Q(1[0-8]|[1-9])_\d+\.m$/);
      if (match) totals[Number(match[1])-1] += count;
    }
    const lines = [
      "# 解法下载次数",
      "",
      "每次生成整套随机解法包时，包内对应版本的下载次数加 1。未出现在表格中的新版本按 0 次显示。",
      `最后更新：${updatedAt}`,
      "",
      "## 每题下载次数",
      "",
      "| 题号 | 题目 | 下载次数 |",
      "|---:|---|---:|",
      ...QUESTION_TITLES.map((title,index) => `| ${index+1} | ${title} | ${totals[index]} |`),
      "",
      "## 各解法版本下载次数",
      "",
      "| 解法文件 | 下载次数 |",
      "|---|---:|",
      ...sortSolutionNames(counts.keys()).map(name => `| ${name} | ${counts.get(name)} |`),
      ""
    ];
    const bytes = encoder.encode(lines.join("\n"));
    const content = encodeBase64(bytes);
    const result = await fetch(contentsUrl(env, COUNTS_PATH), {
      method:"PUT",
      headers:{...githubHeaders(env),"Content-Type":"application/json"},
      body:JSON.stringify({message:"Update MATLAB homework download counts",content,branch:env.GITHUB_BRANCH || "main",...(doc.sha ? {sha:doc.sha} : {})})
    });
    if (result.ok) return {updatedAt};
    const details = await result.text();
    if ((result.status === 409 || result.status === 422) && attempt < 4) continue;
    throw new Error(`保存下载次数失败：GitHub API ${result.status} ${details.slice(0,180)}`);
  }
  throw new Error("多人同时下载，计数文件更新冲突，请重试");
}

function encodeBase64(bytes) {
  let binary = "";
  for (let offset = 0; offset < bytes.length; offset += 0x8000) {
    binary += String.fromCharCode(...bytes.subarray(offset, offset + 0x8000));
  }
  return btoa(binary);
}

const CRC_TABLE = (() => {
  const table = new Uint32Array(256);
  for (let index = 0; index < 256; index++) {
    let value = index;
    for (let bit = 0; bit < 8; bit++) value = value & 1 ? 0xedb88320 ^ (value >>> 1) : value >>> 1;
    table[index] = value >>> 0;
  }
  return table;
})();

function crc32(bytes) {
  let crc = 0xffffffff;
  for (const byte of bytes) crc = CRC_TABLE[(crc ^ byte) & 0xff] ^ (crc >>> 8);
  return (crc ^ 0xffffffff) >>> 0;
}

function dosDateTime(date) {
  const year = Math.max(1980,date.getFullYear());
  return {
    date:((year-1980)<<9)|((date.getMonth()+1)<<5)|date.getDate(),
    time:(date.getHours()<<11)|(date.getMinutes()<<5)|Math.floor(date.getSeconds()/2)
  };
}

function makeZip(entries) {
  const localParts = [];
  const centralParts = [];
  const stamp = dosDateTime(new Date());
  let localOffset = 0;
  for (const entry of entries) {
    const name = encoder.encode(entry.name);
    const data = entry.data;
    const checksum = crc32(data);
    const local = new Uint8Array(30 + name.length);
    const localView = new DataView(local.buffer);
    localView.setUint32(0,0x04034b50,true);
    localView.setUint16(4,20,true);
    localView.setUint16(6,0x0800,true);
    localView.setUint16(8,0,true);
    localView.setUint16(10,stamp.time,true);
    localView.setUint16(12,stamp.date,true);
    localView.setUint32(14,checksum,true);
    localView.setUint32(18,data.length,true);
    localView.setUint32(22,data.length,true);
    localView.setUint16(26,name.length,true);
    localView.setUint16(28,0,true);
    local.set(name,30);
    localParts.push(local,data);

    const central = new Uint8Array(46 + name.length);
    const view = new DataView(central.buffer);
    view.setUint32(0,0x02014b50,true);
    view.setUint16(4,20,true);
    view.setUint16(6,20,true);
    view.setUint16(8,0x0800,true);
    view.setUint16(10,0,true);
    view.setUint16(12,stamp.time,true);
    view.setUint16(14,stamp.date,true);
    view.setUint32(16,checksum,true);
    view.setUint32(20,data.length,true);
    view.setUint32(24,data.length,true);
    view.setUint16(28,name.length,true);
    view.setUint16(30,0,true);
    view.setUint16(32,0,true);
    view.setUint16(34,0,true);
    view.setUint16(36,0,true);
    view.setUint32(38,0,true);
    view.setUint32(42,localOffset,true);
    central.set(name,46);
    centralParts.push(central);
    localOffset += local.length + data.length;
  }
  const centralSize = centralParts.reduce((sum,part) => sum + part.length,0);
  const end = new Uint8Array(22);
  const endView = new DataView(end.buffer);
  endView.setUint32(0,0x06054b50,true);
  endView.setUint16(4,0,true);
  endView.setUint16(6,0,true);
  endView.setUint16(8,entries.length,true);
  endView.setUint16(10,entries.length,true);
  endView.setUint32(12,centralSize,true);
  endView.setUint32(16,localOffset,true);
  endView.setUint16(20,0,true);
  return concatenate([...localParts,...centralParts,end]);
}

function concatenate(parts) {
  const total = parts.reduce((sum,part) => sum + part.length,0);
  const output = new Uint8Array(total);
  let offset = 0;
  for (const part of parts) { output.set(part,offset); offset += part.length; }
  return output;
}
