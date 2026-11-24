from pathlib import Path
import json
import re
import shutil
import zipfile

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "web"
OUTPUT = WEB / "dist"


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for name in ("index.html", "style.css", "app.js", "config.js", "zip.js"):
        shutil.copy2(WEB / name, OUTPUT / name)
    for config in json.loads((WEB / "rounds.json").read_text(encoding="utf-8")).values():
        build_solution_bundle(config)
    print(f"Built static site: {OUTPUT}")


def build_solution_bundle(config):
    folder = ROOT / config["folder"]
    solution_output = OUTPUT / config["assetDirectory"]
    solution_output.mkdir(parents=True, exist_ok=True)
    count_text = (WEB / config["counts"]).read_text(encoding="utf-8")
    counts = {
        name: int(count)
        for name, count in re.findall(r"^\|[ \t]*(Q\d+_\d+\.(?:m|mlapp))[ \t]*\|[ \t]*(\d+)[ \t]*\|$", count_text, re.M)
    }
    updated = re.search(r"^最后更新：(.+)$", count_text, re.M)
    sources = sorted(folder.iterdir())
    questions = []

    for number, title in enumerate(config["titles"], start=1):
        extension = "mlapp" if number in config["apps"] else "m"
        pattern = re.compile(rf"^Q{number}_(\d+)\.{extension}$")
        variants = []
        for source in sources:
            match = pattern.fullmatch(source.name)
            if not match or not source.is_file():
                continue
            download_name = f"Q{number}.{extension}"
            payload = source
            if extension == "mlapp":
                payload = folder / "打包应用" / source.stem / download_name
                with zipfile.ZipFile(source) as original, zipfile.ZipFile(payload) as packaged:
                    part = "matlab/document.xml"
                    canonical = original.read(part).replace(source.stem.encode(), Path(download_name).stem.encode())
                    if canonical != packaged.read(part):
                        raise ValueError(f"{source.name} 的下载副本与原应用不一致，请重新另存为 {download_name}")
            shutil.copy2(payload, solution_output / source.name)
            variants.append({
                "file": source.name,
                "downloadName": download_name,
                "downloadCount": counts.get(source.name, 0),
            })
        variants.sort(key=lambda item: int(pattern.fullmatch(item["file"]).group(1)))
        if not variants:
            raise ValueError(f'{config["folder"]} 第 {number} 题没有 {extension} 解法')
        questions.append({
            "number": number,
            "title": title,
            "downloadCount": sum(item["downloadCount"] for item in variants),
            "variants": variants,
        })

    for name in config["attachments"]:
        shutil.copy2(folder / name, solution_output / name)

    manifest = {
        "questions": questions,
        "folder": config["folder"],
        "assetDirectory": config["assetDirectory"],
        "attachments": config["attachments"],
        "updatedAt": updated.group(1).strip() if updated else None,
    }
    (OUTPUT / config["manifest"]).write_text(json.dumps(manifest, ensure_ascii=False), encoding="utf-8")


if __name__ == "__main__":
    main()
