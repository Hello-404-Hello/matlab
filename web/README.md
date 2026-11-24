# MATLAB 作业解法库网站

网站源码在本目录，发布地址预定为 <https://hello-404-hello.github.io/matlab/>。

网页发布时会分别生成两轮作业的清单、静态文件和计数快照。两轮各有下载按钮和统计区。浏览器从同一个站点读取清单和附件，再在本地生成 ZIP。新增解法后，重新推送会自动更新清单与文件。

题目和附件配置在 [rounds.json](rounds.json)。第二轮第 5、17 题只收 `.mlapp` 版本。网站从 `第二轮作业题/打包应用/Q题号_版本号/` 读取应用名已改为 `Q题号` 的原生文件，打包时命名为 `Q5.mlapp`、`Q17.mlapp`。新增 GUI 版本时，同时保存源应用和标准名称的副本。

## 发布网页

仓库中的 `.github/workflows/deploy-web.yml` 会把此目录下的静态网页发布到 GitHub Pages。首次使用时，在 GitHub 仓库的 **Settings → Pages → Build and deployment** 中把 **Source** 设为 **GitHub Actions**。页面部署成功后，首页 README 会链接到网站。

## 配置下载 Worker

GitHub Pages 只托管静态网页，不能安全地保存 GitHub 写入凭证。Cloudflare Worker 仅用于读取最新计数和记录新下载；页面无法连接 Worker 时仍可显示发布时的计数快照并正常下载。凭证保存在 Worker 密钥中，不会出现在网页或仓库代码里。

1. 安装 Node.js 后，在 `web/worker` 目录运行 `npx wrangler login`，按提示登录 Cloudflare。再运行 `npx wrangler deploy`，部署配置文件中的 `matlab-homework-counter` Worker。
2. 在 GitHub 创建一个 fine-grained personal access token，只授权 `Hello-404-Hello/matlab` 仓库的 **Contents: Read and write**。不要把 token 发到聊天、网页配置或仓库文件里。
3. 在 `web/worker` 目录运行 `npx wrangler secret put GITHUB_TOKEN`，在终端提示中粘贴 token。Worker 可以读取两轮的解法列表，并分别更新 [第一轮计数](download-counts.md) 和 [第二轮计数](download-counts-round2.md)。
4. 部署完成后，Wrangler 会显示 `workers.dev` 地址。在 `config.js` 将 `window.MATLAB_COUNTER_API` 设为该地址（例如 `https://matlab-homework-counter.<你的子域>.workers.dev`），提交到 `main`。GitHub Actions 会自动更新网页。

页面在后台同步计数，每次打包尝试给该轮实际抽中的版本各加 1。Worker 无法连接时，页面显示最近发布的计数快照。并发更新遇到文件冲突时，Worker 重新读取后再提交。
