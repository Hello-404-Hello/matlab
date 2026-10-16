# MATLAB 作业解法库网站

网站源码在本目录，发布地址预定为 <https://hello-404-hello.github.io/matlab/>。

网页发布时会将 `第一轮作业题` 中的解法版本、附件和 [`download-counts.md`](download-counts.md) 生成本站清单，并随 GitHub Pages 一起发布。打开页面和随机打包下载都只访问本站，不依赖 Worker 或 GitHub API；压缩包在浏览器本地生成。新增解法后，重新推送会自动更新清单与文件。

## 发布网页

仓库中的 `.github/workflows/deploy-web.yml` 会把此目录下的静态网页发布到 GitHub Pages。首次使用时，在 GitHub 仓库的 **Settings → Pages → Build and deployment** 中把 **Source** 设为 **GitHub Actions**。页面部署成功后，首页 README 会链接到网站。

## 配置下载 Worker

GitHub Pages 只托管静态网页，不能安全地保存 GitHub 写入凭证。Cloudflare Worker 仅用于读取最新计数和记录新下载；页面无法连接 Worker 时仍可显示发布时的计数快照并正常下载。凭证保存在 Worker 密钥中，不会出现在网页或仓库代码里。

1. 安装 Node.js 后，在 `web/worker` 目录运行 `npx wrangler login`，按提示登录 Cloudflare。再运行 `npx wrangler deploy`，部署配置文件中的 `matlab-homework-counter` Worker。
2. 在 GitHub 创建一个 fine-grained personal access token，只授权 `Hello-404-Hello/matlab` 仓库的 **Contents: Read and write**。不要把 token 发到聊天、网页配置或仓库文件里。
3. 在 `web/worker` 目录运行 `npx wrangler secret put GITHUB_TOKEN`，在终端提示中粘贴 token。Worker 随后可以读取当前解法列表，并只更新 `web/download-counts.md`。
4. 部署完成后，Wrangler 会显示 `workers.dev` 地址。在 `config.js` 将 `window.MATLAB_COUNTER_API` 设为该地址（例如 `https://matlab-homework-counter.<你的子域>.workers.dev`），提交到 `main`。GitHub Actions 会自动更新网页。

完成以上设置后，页面会在后台尝试同步最新计数；每次打包后也会尝试给实际抽中的 18 个版本各加 1。Worker 无法连接时，页面和下载不受影响，但计数会保留在最近发布的快照。Worker 并发更新遇到文件冲突时会重新读取后再提交。
