"""Fetch the Olympic Boxing Punch Classification Video Dataset (Kaggle, Stefanski/Kozak/Jach) file by file.  (Claude, S495)
usage: python fetch_olympic.py <dest_dir> [--annotations-only] [--max-gb 4]

LICENCE (read on the Kaggle page 2026-11-15): "The data is for use in non-commercial settings: in academic institutions
for teaching and research purposes and in non-profit research organizations." The operator cleared the download (S495)
for MEASURING our analyzer only. Nothing from it goes into the game, a build or this repo: <dest_dir> is outside the repo.
No login is needed (public dataset); files that already have the right size are skipped, so the script can be re-run."""
import json
import os
import sys
import time
import urllib.parse
import urllib.request

SLUG = "piotrstefaskiue/olympic-boxing-punch-classification-video-dataset"
API = "https://www.kaggle.com/api/v1/datasets"
UA = {"User-Agent": "dataset-fetch/1.0"}


def list_files():
    files, token = [], None
    while True:
        url = "%s/list/%s?page_size=200" % (API, SLUG) + ("&page_token=" + urllib.parse.quote(token) if token else "")
        page = json.load(urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=60))
        files += [(f["name"], int(f["totalBytes"])) for f in page.get("datasetFiles", [])]
        token = page.get("nextPageTokenNullable") or page.get("nextPageToken")
        if not token:
            return files


def fetch(name, size, dest):
    path = os.path.join(dest, *name.split("/")[1:])  # drop the dataset's own top folder
    if os.path.exists(path) and os.path.getsize(path) == size:
        return "have"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    url = "%s/download/%s?file_name=%s" % (API, SLUG, urllib.parse.quote(name))
    with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=120) as r, open(path + ".part", "wb") as out:
        while True:
            chunk = r.read(1 << 20)
            if not chunk:
                break
            out.write(chunk)
    got = os.path.getsize(path + ".part")
    if got != size:
        return "SIZE MISMATCH %d != %d" % (got, size)
    os.replace(path + ".part", path)
    return "ok"


def main():
    dest = sys.argv[1]
    only_ann = "--annotations-only" in sys.argv
    max_gb = float(sys.argv[sys.argv.index("--max-gb") + 1]) if "--max-gb" in sys.argv else 4.0
    files = list_files()
    total = sum(s for _, s in files)
    print("%d files, %.2f GB listed" % (len(files), total / 1e9), flush=True)
    if total / 1e9 > max_gb:
        sys.exit("more than --max-gb %.1f: stop" % max_gb)
    files.sort(key=lambda f: (not f[0].endswith(".json"), f[1]))  # labels first, then small videos first
    done = 0
    for name, size in files:
        if only_ann and not name.endswith(".json"):
            continue
        began = time.time()
        try:
            state = fetch(name, size, dest)
        except Exception as e:  # one bad file never stops the rest; the re-run picks it up
            state = "ERROR %s" % e
        done += size
        print("%-8s %7.1f MB %5.0fs  %s  (%.0f%%)" % (state[:8], size / 1e6, time.time() - began, name.split("/", 1)[1], 100.0 * done / total), flush=True)
    print("DONE", flush=True)


if __name__ == "__main__":
    main()
