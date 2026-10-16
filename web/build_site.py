from pathlib import Path
import json
import re
import shutil


ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "web"
OUTPUT = WEB / "dist"
QUESTION_FOLDER = ROOT / "第一轮作业题"
TITLES = [
    "随机矩阵乘法", "倒序序列删数", "MATLAB 变量名", "多边形车轮", "八方向求和", "餐盘面积",
    "购买任务", "分解为 3 和 5", "手机号三连号", "DNA 配对", "虚位密码锁", "随机车牌",
    "地铁计费", "随机帐篷安排", "网格连通", "区间售票", "灯光分布", "快递站选址"
]
SUPPORT_FILES = ["餐盘.jpg", "碱基对.txt", "手机号.xlsx"]


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for name in ("index.html", "style.css", "app.js", "config.js", "zip.js"):
        shutil.copy2(WEB / name, OUTPUT / name)
    build_solution_bundle()
    print(f"Built static site: {OUTPUT}")


def build_solution_bundle():
    solution_output = OUTPUT / "solutions"
    # Keep the existing directory in place: on synced folders (for example
    # OneDrive) deleting the whole generated tree can fail while files are
    # being indexed. The manifest is authoritative, so stale files are unused.
    solution_output.mkdir(parents=True, exist_ok=True)

    count_text = (WEB / "download-counts.md").read_text(encoding="utf-8")
    counts = {name: int(count) for name, count in re.findall(r"^\|\s*(m(?:1[0-8]|[1-9])_\d+\.m)\s*\|\s*(\d+)\s*\|$", count_text, re.M)}
    updated = re.search(r"^最后更新：(.+)$", count_text, re.M)
    questions = []

    for number, title in enumerate(TITLES, start=1):
        pattern = re.compile(rf"^m{number}_(\d+)\.m$")
        variants = []
        for source in QUESTION_FOLDER.iterdir():
            match = pattern.match(source.name)
            if source.is_file() and match:
                shutil.copy2(source, solution_output / source.name)
                variants.append({"file": source.name, "downloadCount": counts.get(source.name, 0)})
        variants.sort(key=lambda item: int(pattern.match(item["file"]).group(1)))
        questions.append({
            "number": number,
            "title": title,
            "downloadCount": sum(item["downloadCount"] for item in variants),
            "variants": variants
        })

    for name in SUPPORT_FILES:
        shutil.copy2(QUESTION_FOLDER / name, solution_output / name)

    manifest = {"questions": questions, "updatedAt": updated.group(1).strip() if updated else None}
    (OUTPUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False), encoding="utf-8")


if __name__ == "__main__":
    main()
