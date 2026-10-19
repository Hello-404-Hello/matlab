(() => {
  const api = (window.MATLAB_COUNTER_API || "").replace(/\/+$/, "");
  const titles = [
    "随机矩阵乘法", "倒序序列删数", "MATLAB 变量名", "多边形车轮", "八方向求和", "餐盘面积",
    "购买任务", "分解为 3 和 5", "手机号三连号", "DNA 配对", "虚位密码锁", "随机车牌",
    "地铁计费", "随机帐篷安排", "网格连通", "区间售票", "灯光分布", "快递站选址"
  ];
  const button = document.getElementById("download-button");
  const status = document.getElementById("download-status");
  const grid = document.getElementById("problem-grid");
  const aiDialog = document.getElementById("ai-prompt-dialog");
  const aiModel = document.getElementById("ai-model");
  const aiModels = ["豆包", "千问", "Kimi", "Deepseek", "混元", "GLM", "ChatGPT", "Gemini"];
  let state = null;

  function setStatus(message, kind = "") {
    status.textContent = message;
    status.className = `download-status ${kind}`.trim();
  }

  function escapeText(value) {
    return String(value).replace(/[&<>"']/g, char => ({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[char]));
  }

  function render(data) {
    state = data;
    const questions = Array.from({length:18}, (_, index) => {
      const number = index + 1;
      const actual = (data.questions || []).find(item => item.number === number) || {number, variants:[], downloadCount:0};
      actual.variants = (actual.variants || []).slice().sort((a,b) => versionNumber(a.file)-versionNumber(b.file));
      return actual;
    });
    const variants = questions.reduce((sum, question) => sum + question.variants.length, 0);
    const downloads = questions.reduce((sum, question) => sum + question.variants.reduce((n, variant) => n + (variant.downloadCount || 0), 0), 0);
    document.getElementById("problem-total").textContent = questions.length;
    document.getElementById("variant-total").textContent = variants;
    document.getElementById("download-total").textContent = Math.floor(downloads / 18).toLocaleString("zh-CN");
    document.getElementById("updated-at").textContent = data.updatedAt ? `统计更新 ${formatTime(data.updatedAt)}` : "计数文件已同步";
    grid.innerHTML = questions.map(question => {
      const versionChips = question.variants.length
        ? question.variants.map(variant => `<span class="variant-chip">${escapeText(variant.file.replace(/\.m$/, ""))}<b>${(variant.downloadCount || 0).toLocaleString("zh-CN")}</b></span>`).join("")
        : `<span class="variant-chip">暂无解法</span>`;
      return `<article class="problem-card"><div class="problem-top"><span class="problem-number">PROBLEM ${String(question.number).padStart(2,"0")}</span><span class="problem-total">${question.variants.length} 个版本</span></div><h3>${escapeText(titles[question.number-1])}</h3><div class="problem-stats"><strong>${question.downloadCount.toLocaleString("zh-CN")}</strong><span>次下载</span></div><div class="variant-list" aria-label="各版本下载次数">${versionChips}</div></article>`;
    }).join("");
  }

  function versionNumber(filename) {
    const match = filename.match(/_(\d+)\.m$/);
    return match ? Number(match[1]) : 0;
  }

  function formatTime(value) {
    if (!value || value === "尚未记录") return "尚未记录";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return String(value);
    return new Intl.DateTimeFormat("zh-CN", {month:"2-digit",day:"2-digit",hour:"2-digit",minute:"2-digit",hour12:false,timeZone:"Asia/Shanghai"}).format(date);
  }

  async function fetchWithTimeout(url, options = {}, timeout = 3500) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), timeout);
    try {
      return await fetch(url, {...options,signal:controller.signal});
    } finally {
      clearTimeout(timer);
    }
  }

  async function loadManifest() {
    const response = await fetch(new URL("manifest.json",document.baseURI), {cache:"no-store"});
    if (!response.ok) throw new Error(`本站题目清单读取失败：${response.status}`);
    const data = await response.json();
    render(data);
  }

  async function loadCounts() {
    if (!api) return;
    const response = await fetchWithTimeout(`${api}/counts`, {cache:"no-store"});
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || `计数服务返回 ${response.status}`);
    render(data);
    setStatus("题目版本与下载次数已同步。", "success");
  }

  async function readSolution(filename) {
    const response = await fetch(new URL(`solutions/${encodeURIComponent(filename)}`,document.baseURI), {cache:"force-cache"});
    if (!response.ok) throw new Error(`${filename} 下载失败：${response.status}`);
    return new Uint8Array(await response.arrayBuffer());
  }

  async function buildPackage() {
    const selected = state.questions.map(question => {
      const variants = question.variants || [];
      if (!variants.length) throw new Error(`第 ${question.number} 题暂无可下载版本`);
      return {number:question.number, file:variants[Math.floor(Math.random()*variants.length)].file};
    });
    const scripts = selected.map(async item => ({
      name:`第一轮作业题/Q${item.number}.m`,
      data:await readSolution(item.file)
    }));
    const attachments = ["餐盘.jpg", "碱基对.txt", "手机号.xlsx"].map(async name => ({
      name:`第一轮作业题/${name}`,
      data:await readSolution(name)
    }));
    const entries = await Promise.all([...scripts,...attachments]);
    return {blob:window.MatlabZip.create(entries),selected};
  }

  async function syncDownloadCounts(selected) {
    if (!api) return;
    try {
      const response = await fetchWithTimeout(`${api}/record`, {
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body:JSON.stringify({files:selected.map(item => item.file)})
      }, 4000);
      if (!response.ok) return;
      await loadCounts();
    } catch {
    }
  }

  function displayLoadError(error) {
    grid.innerHTML = `<div class="empty-card">暂时无法读取仓库版本和下载次数。<br>${escapeText(error.message)}</div>`;
    setStatus("下载服务尚未就绪", "error");
    button.disabled = true;
  }

  button.addEventListener("click", async () => {
    if (!state || button.disabled) return;
    button.disabled = true;
    setStatus("正在从本站读取解法并打包…");
    try {
      const {blob,selected} = await buildPackage();
      const url = URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.href = url;
      link.download = `第一轮作业题-随机解法-${new Date().toISOString().slice(0,10)}.zip`;
      document.body.append(link);
      link.click();
      link.remove();
      setTimeout(() => URL.revokeObjectURL(url),60000);
      setStatus(`已下载；本包抽中的版本：${selected.map(item => item.file).join(",")}`, "success");
      aiModel.textContent = aiModels[Math.floor(Math.random()*aiModels.length)];
      if (typeof aiDialog.showModal === "function") aiDialog.showModal();
      else window.alert(`你抽到的降重AI是：${aiModel.textContent}\n请使用你抽到的AI模型和 README 中的降重 Prompt 进行降重。`);
      button.disabled = false;
      void syncDownloadCounts(selected);
    } catch (error) {
      setStatus(error.message, "error");
      button.disabled = false;
    }
  });

  loadManifest().then(() => {
    button.disabled = false;
    setStatus("题目版本已从本站读取；下载统计显示最近同步数据。", "success");
    void loadCounts().catch(() => {});
  }).catch(displayLoadError);
})();
