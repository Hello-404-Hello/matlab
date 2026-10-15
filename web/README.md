# MATLAB 作业解法库网站

网站源码在本目录，发布地址预定为 <https://hello-404-hello.github.io/matlab/>。

网页每次打开时，通过 Worker 查询 GitHub 仓库 `第一轮作业题` 目录里的 `m1_*.m` 至 `m18_*.m`，所以新增版本后无需手动修改网页。计数文档没有的解法会显示为 0。点击打包按钮时，Worker 对每题随机选一个当前版本，将文件改名为 `m1.m` 至 `m18.m`，连同 `餐盘.jpg` 打成 ZIP，并把实际抽中的各版本下载次数写回 [`download-counts.md`](download-counts.md)。

## 发布网页

仓库中的 `.github/workflows/deploy-web.yml` 会把此目录下的静态网页发布到 GitHub Pages。首次使用时，在 GitHub 仓库的 **Settings → Pages → Build and deployment** 中把 **Source** 设为 **GitHub Actions**。页面部署成功后，首页 README 会链接到网站。

## 配置下载 Worker

GitHub Pages 只托管静态网页，不能安全地保存 GitHub 写入凭证。计数和 ZIP 生成由 Cloudflare Worker 执行；凭证保存在 Worker 密钥中，不会出现在网页或仓库代码里。

1. 安装 Node.js 后，在 `web/worker` 目录运行 `npx wrangler login`，按提示登录 Cloudflare。再运行 `npx wrangler deploy`，部署配置文件中的 `matlab-homework-counter` Worker。
2. 在 GitHub 创建一个 fine-grained personal access token，只授权 `Hello-404-Hello/matlab` 仓库的 **Contents: Read and write**。不要把 token 发到聊天、网页配置或仓库文件里。
3. 在 `web/worker` 目录运行 `npx wrangler secret put GITHUB_TOKEN`，在终端提示中粘贴 token。Worker 随后可以读取当前解法列表，并只更新 `web/download-counts.md`。
4. 部署完成后，Wrangler 会显示 `workers.dev` 地址。在 `config.js` 将 `window.MATLAB_COUNTER_API` 设为该地址（例如 `https://matlab-homework-counter.<你的子域>.workers.dev`），提交到 `main`。GitHub Actions 会自动更新网页。

完成以上设置后，打开网站时会实时读取 GitHub 目录和计数文档。每次下载仅给该 ZIP 中抽到的 18 个版本各加 1。Worker 并发更新遇到文件冲突时会重新读取后再提交。
