(() => {
  const api = (window.MATLAB_COUNTER_API || "").replace(/\/+$/, "");
  const rounds = [
    {suffix:"", manifest:"manifest.json", counterPrefix:""},
    {suffix:"-round2", manifest:"round2-manifest.json", counterPrefix:"round2/"}
  ];
  const aiDialog = document.getElementById("ai-prompt-dialog");
  const aiModel = document.getElementById("ai-model");
  const aiModels = ["豆包", "千问", "Kimi", "Deepseek", "混元", "GLM", "ChatGPT", "Gemini"];

  function escapeText(value) {
    return String(value).replace(/[&<>"']/g, char => ({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[char]));
  }

  function formatTime(value) {
    if (!value || value === "尚未记录") return "尚未记录";
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return String(value);
    return new Intl.DateTimeFormat("zh-CN", {month:"2-digit",day:"2-digit",hour:"2-digit",minute:"2-digit",hour12:false,timeZone:"Asia/Shanghai"}).format(date);
  }

  async function fetchCounts(path, options = {}, timeout = 3500) {
    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), timeout);
    try {
      const response = await fetch(`${api}/${path}`, {...options,signal:controller.signal});
      if (!response.ok) throw new Error(`计数服务返回 ${response.status}`);
      return await response.json();
    } finally {
      clearTimeout(timer);
    }
  }

  function initRound({suffix,manifest,counterPrefix}) {
    const element = id => document.getElementById(id + suffix);
    const button = element("download-button");
    const status = element("download-status");
    const grid = element("problem-grid");
    let state;

    function setStatus(message, kind = "") {
      status.textContent = message;
      status.className = `download-status ${kind}`.trim();
    }

    function render() {
      const {questions,updatedAt} = state;
      const total = questions.reduce((sum, q) => sum + q.downloadCount, 0);
      element("problem-total").textContent = questions.length;
      element("variant-total").textContent = questions.reduce((sum, q) => sum + q.variants.length, 0);
      element("download-total").textContent = Math.floor(total / questions.length).toLocaleString("zh-CN");
      element("updated-at").textContent = updatedAt ? `统计更新 ${formatTime(updatedAt)}` : "尚无计数更新";
      grid.innerHTML = questions.map(question => {
        const versions = question.variants.map(variant => {
          const label = variant.file.replace(/\.m$/, "");
          return `<span class="variant-chip">${escapeText(label)}<b>${variant.downloadCount.toLocaleString("zh-CN")}</b></span>`;
        }).join("");
        return `<article class="problem-card"><div class="problem-top"><span class="problem-number">Q${question.number}</span><span class="problem-total">${question.variants.length} 个版本</span></div><h3>${escapeText(question.title)}</h3><div class="problem-stats"><strong>${question.downloadCount.toLocaleString("zh-CN")}</strong><span>次下载</span></div><div class="variant-list" aria-label="各版本下载次数">${versions}</div></article>`;
      }).join("");
    }

    async function loadCounts() {
      const data = await fetchCounts(`${counterPrefix}counts`, {cache:"no-store"});
      const counts = new Map(data.questions.flatMap(q => q.variants.map(v => [v.file,v.downloadCount])));
      // Only offer versions already published on Pages, even when GitHub's listing is newer.
      for (const q of state.questions) {
        for (const v of q.variants) v.downloadCount = counts.get(v.file) ?? v.downloadCount;
        q.downloadCount = q.variants.reduce((sum,v) => sum + v.downloadCount, 0);
      }
      state.updatedAt = data.updatedAt ?? state.updatedAt;
      render();
    }

    async function readAsset(file) {
      const path = `${state.assetDirectory}/${encodeURIComponent(file)}`;
      const response = await fetch(new URL(path,document.baseURI), {cache:"force-cache"});
      if (!response.ok) throw new Error(`${file} 下载失败：${response.status}`);
      return new Uint8Array(await response.arrayBuffer());
    }

    async function record(variants) {
      await fetchCounts(`${counterPrefix}record`, {
        method:"POST",
        headers:{"Content-Type":"application/json"},
        body:JSON.stringify({files:variants.map(v => v.file)})
      }, 4000);
      await loadCounts();
    }

    button.addEventListener("click", async () => {
      if (!state || button.disabled) return;
      button.disabled = true;
      setStatus("正在打包…");
      try {
        const variants = state.questions.map(q => q.variants[Math.floor(Math.random()*q.variants.length)]);
        const sourceFiles = [
          ...variants.map(v => [v.file,v.downloadName]),
          ...state.attachments.map(name => [name,name])
        ];
        const entries = await Promise.all(sourceFiles.map(async ([file,name]) => ({
          name:`${state.folder}/${name}`, data:await readAsset(file)
        })));
        const url = URL.createObjectURL(window.MatlabZip.create(entries));
        const link = document.createElement("a");
        link.href = url;
        link.download = `${state.folder}-随机解法-${new Date().toISOString().slice(0,10)}.zip`;
        document.body.append(link);
        link.click();
        link.remove();
        setTimeout(() => URL.revokeObjectURL(url),60000);
        setStatus("已生成 ZIP，每题抽取一个版本。", "success");
        aiModel.textContent = aiModels[Math.floor(Math.random()*aiModels.length)];
        if (typeof aiDialog.showModal === "function") {
          if (!aiDialog.open) aiDialog.showModal();
        } else {
          window.alert(`你抽到的降重AI是：${aiModel.textContent}\n请使用你抽到的AI模型和 README 中的降重 Prompt 进行降重。`);
        }
        if (api) void record(variants).catch(() => {});
      } catch (error) {
        setStatus(error.message, "error");
      } finally {
        button.disabled = false;
      }
    });

    fetch(new URL(manifest,document.baseURI), {cache:"no-store"}).then(async response => {
      if (!response.ok) throw new Error(`本站题目清单读取失败：${response.status}`);
      state = await response.json();
      render();
      button.disabled = false;
      setStatus("");
      if (api) void loadCounts().catch(() => {});
    }).catch(error => {
      grid.innerHTML = `<div class="empty-card">${escapeText(error.message)}</div>`;
      setStatus("暂时无法读取题目清单", "error");
    });
  }

  for (const round of rounds) initRound(round);
})();
