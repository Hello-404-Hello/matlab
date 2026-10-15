from pathlib import Path
import shutil


ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "web"
OUTPUT = WEB / "dist"


def main():
    OUTPUT.mkdir(parents=True, exist_ok=True)
    for name in ("index.html", "style.css", "app.js", "config.js"):
        shutil.copy2(WEB / name, OUTPUT / name)
    print(f"Built static site: {OUTPUT}")


if __name__ == "__main__":
    main()
