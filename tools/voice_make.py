#!/usr/bin/env python3
"""VOICEWIRE1: generate the cast's voice lines via Ludo (PAID: 1 credit a line).

For each VoiceLines.gd row whose file is not on disk yet:
  ludo audio speech-preset --text <text> --voice-preset-id <voice> --delivery <note>
      --request-id voicewire1-<id>-<hash> --max-credits 1 --name <id> --out <temp folder>
then ffmpeg makes it mono 48 kHz Ogg Vorbis, `ludo toolbox audio info` measures it, and it is stored as
assets/audio/voice/<role>/<id>.ogg with its files row and event row written into sounds.json AT ONCE
(so a crash or Ctrl-C never re-spends a line already made).

Re-runnable: a line whose assets/audio/voice/<role>/<id>.ogg exists is skipped (its row is re-added for
free when it is missing). The same request id returns Ludo's existing job instead of charging again.
The guide lines (role "guide") are LEFT OUT unless --with-guide is passed: the guide is not wired yet.
Stops before passing the 140 credit budget and prints every line left unmade.
The temporary folder is outside the repo (the system temp) and is deleted at the end.

Usage:
  python tools/voice_make.py --dry-run          (free: lists the lines, the cost and where files go)
  python tools/voice_make.py [--limit N] [--with-guide]
"""

import argparse
import hashlib
import json
import re
import shutil
import subprocess
import tempfile
from datetime import datetime
from pathlib import Path

# The cast (docs/audio/VOICE_CAST_S434.md)
VOICES = {
    "announcer": {"voice": "Roger", "delivery": "booming ring announcer, building up"},
    "between": {"voice": "Brian", "delivery": "gruff veteran trainer, calm, between rounds"},
    "shout_m": {"voice": "Callum", "delivery": "coach shouting over a loud crowd"},
    "shout_f": {"voice": "Sarah", "delivery": "fierce coach shouting over a loud crowd"},
    "guide": {"voice": "Bill", "delivery": "old ex-boxer, gravelly, warm, unhurried"},
}

BUDGET = 140  # max credits to spend
RATE = 48000
ROOT = Path(__file__).resolve().parent.parent
SOUNDS_JSON = ROOT / "assets" / "audio" / "sounds.json"
VOICE_DIR = ROOT / "assets" / "audio" / "voice"


# S438: on Windows the npm tool is ludo.cmd; a bare "ludo" is not found without a shell.
import shutil as _sh
LUDO = _sh.which("ludo.cmd") or _sh.which("ludo") or "ludo"

def load_sounds():
    with open(SOUNDS_JSON, "r", encoding="utf-8") as f:
        return json.load(f)


def save_sounds(data):
    with open(SOUNDS_JSON, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=1, ensure_ascii=False)
        f.write("\n")


def parse_voice_lines():
    """Parse VoiceLines.gd to get all lines."""
    text = (ROOT / "scripts" / "audio" / "VoiceLines.gd").read_text(encoding="utf-8")
    lines = []
    # Match lines like: "announcer_opening": {"role": "announcer", "text": "..."},
    pattern = r'"(\w+)":\s*\{"role":\s*"(\w+)",\s*"text":\s*"([^"]+)"\}'
    for m in re.finditer(pattern, text):
        key, role, txt = m.groups()
        lines.append({"id": key, "role": role, "text": txt, "event": f"voice_{key}"})
    return lines


def final_path(line):
    return VOICE_DIR / line["role"] / f"{line['id']}.ogg"


def rel_path(line):
    return f"assets/audio/voice/{line['role']}/{line['id']}.ogg"


def request_id(line):
    """Same id for the same words and voice: Ludo returns the existing job instead of charging again."""
    v = VOICES[line["role"]]
    h = hashlib.sha1(f"{line['text']}|{v['voice']}|{v['delivery']}".encode("utf-8")).hexdigest()[:8]
    return f"voicewire1-{line['id']}-{h}"


def get_account_credits():
    """Current credit balance (`credits.available` of `ludo account show`), or None."""
    try:
        result = subprocess.run([LUDO, "account", "show", "--json"], capture_output=True, text=True, timeout=30)
        data = json.loads(result.stdout)
        return float(data["credits"]["available"])
    except Exception as e:
        print(f"Warning: could not read account credits: {e}")
        return None


def audio_info(path):
    try:
        result = subprocess.run([LUDO, "toolbox", "audio", "info", str(path), "--json", "--quiet"],
                                capture_output=True, text=True, timeout=30)
        return json.loads(result.stdout) if result.returncode == 0 else {}
    except Exception:
        return {}


def generate_line(line, tmp_dir):
    """Generate one voice line via Ludo, resampled to mono 48 kHz ogg. Returns the temp ogg path or None."""
    v = VOICES[line["role"]]
    out_dir = tmp_dir / line["id"]
    out_dir.mkdir(parents=True, exist_ok=True)
    cmd = [LUDO, "audio", "speech-preset", "--text", line["text"], "--voice-preset-id", v["voice"],
           "--delivery", v["delivery"], "--request-id", request_id(line), "--max-credits", "1",
           "--name", line["id"], "--out", str(out_dir), "--json", "--quiet"]
    print(f"  Generating: {line['id']} ({v['voice']}: {line['text'][:40]})")
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)
        if result.returncode != 0:
            print(f"  ERROR: ludo speech-preset failed: {result.stderr.strip()}")
            return None
        files = json.loads(result.stdout).get("files", [])
        if not files:
            print("  ERROR: no files in response")
            return None
        src = Path(files[0].get("absolute_path") or files[0]["path"])
        if not src.is_absolute() and not src.exists():
            src = out_dir / src.name
        if not src.exists():
            print(f"  ERROR: source file not found: {src}")
            return None
    except subprocess.TimeoutExpired:
        print("  ERROR: ludo speech-preset timed out")
        return None
    except Exception as e:
        print(f"  ERROR: {e}")
        return None
    # Ludo's speech is MP3/WAV, usually 44.1 kHz: ffmpeg makes it mono 48 kHz Ogg Vorbis.
    ogg = out_dir / f"{line['id']}_48k.ogg"
    cmd = ["ffmpeg", "-y", "-hide_banner", "-loglevel", "error", "-i", str(src), "-ar", str(RATE), "-ac", "1",
           "-c:a", "libvorbis", "-q:a", "6", str(ogg)]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        if result.returncode != 0 or not ogg.exists():
            print(f"  ERROR: ffmpeg failed: {result.stderr.strip()}")
            return None
    except Exception as e:
        print(f"  ERROR: ffmpeg failed: {e}")
        return None
    return ogg


def register(sounds, line, info, credits):
    """The files row (measured numbers, unheard) and the event's file entry."""
    rel = rel_path(line)
    ch = int(info.get("channels", 0) or 0)
    sounds.setdefault("files", {})[rel] = {
        "event": line["event"],
        "prompt": line["text"],
        "source": "ludo audio speech-preset",
        "voice": VOICES[line["role"]]["voice"],
        "credits": credits,
        "made": datetime.now().strftime("%Y-%m-%d %H:%M"),
        "mmax": float(info.get("peak_db", 0)),
        "lufs": float(info.get("loudness_lufs", -70)),
        "tp": float(info.get("true_peak_db", 0)),
        "dur": float(info.get("duration", 0)),
        "lead_silence": float(info.get("silence_start", 0)),
        "codec": "vorbis",
        "rate": int(info.get("rate", 0) or 0),
        "channels": "mono" if ch == 1 else str(ch),
        "heard": False,  # EAR RULE: unheard until the operator keeps it on the sound board
    }
    ev = sounds.setdefault("events", {}).get(line["event"])
    if ev is not None:
        files = ev.setdefault("files", [])
        if f"res://{rel}" not in files:
            files.append(f"res://{rel}")


def main():
    parser = argparse.ArgumentParser(description="Generate voice lines via Ludo (paid)")
    parser.add_argument("--dry-run", action="store_true", help="Print what would be done; no generation, no credits")
    parser.add_argument("--limit", type=int, default=0, help="Max lines to generate (0 = unlimited)")
    parser.add_argument("--with-guide", action="store_true", help="Also make the lines nothing plays yet: the guide and the woman coach's shouts")
    args = parser.parse_args()

    lines = parse_voice_lines()
    print(f"Total lines in VoiceLines.gd: {len(lines)}")
    sounds = load_sounds()

    to_make, unmade = [], []
    for line in lines:
        if line["role"] not in VOICES:
            print(f"  SKIP (no voice for role '{line['role']}'): {line['id']}")
            continue
        if line["role"] == "shout_f" and not args.with_guide:  # S438: no coach has a sex yet, the game never plays these
            print(f"  SKIP (the woman coach's shouts are not played yet; pass --with-guide): {line['id']}")
            continue
        if line["role"] == "guide" and not args.with_guide:
            print(f"  SKIP (guide not wired; pass --with-guide): {line['id']}")
            continue
        fp = final_path(line)
        if fp.exists():
            print(f"  SKIP (file on disk): {rel_path(line)}")
            if not args.dry_run and rel_path(line) not in sounds.get("files", {}):
                register(sounds, line, audio_info(fp), 0)  # a crash left the file without its row: free re-add
                save_sounds(sounds)
            continue
        to_make.append(line)
    print(f"Lines to make: {len(to_make)}")

    if args.dry_run:
        print("\nDRY RUN - would generate (no credits spent):")
        for line in to_make:
            print(f"  {line['id']}: {VOICES[line['role']]['voice']} - {line['text'][:50]} -> {rel_path(line)}")
        print(f"\nWould cost: {min(len(to_make), BUDGET)} credits (budget {BUDGET})")
        print(f"Files would go to: {VOICE_DIR.relative_to(ROOT).as_posix()}/<role>/<id>.ogg (mono {RATE} Hz Ogg Vorbis)")
        print(f"Rows would go to: {SOUNDS_JSON.relative_to(ROOT).as_posix()} (heard: false)")
        return

    if args.limit > 0:
        unmade += to_make[args.limit:]
        to_make = to_make[:args.limit]
        print(f"Limited to: {len(to_make)} lines")

    credits_before = get_account_credits()
    print(f"Credits before: {credits_before}")

    tmp_dir = Path(tempfile.mkdtemp(prefix="voicewire1_"))
    made = 0
    credits_spent = 0
    try:
        for i, line in enumerate(to_make):
            if credits_spent >= BUDGET:
                print(f"\nBudget reached ({BUDGET} credits). Stopping.")
                unmade += to_make[i:]
                break
            ogg = generate_line(line, tmp_dir)
            if ogg is None:
                unmade.append(line)
                continue
            credits_spent += 1
            fp = final_path(line)
            fp.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ogg, fp)
            register(sounds, line, audio_info(fp), 1)
            save_sounds(sounds)
            made += 1
            print(f"  MADE: {rel_path(line)}")
    finally:
        shutil.rmtree(tmp_dir, ignore_errors=True)

    credits_after = get_account_credits()
    print(f"\nCredits before: {credits_before}  after: {credits_after}")
    print(f"Lines made: {made}")
    print(f"Credits spent (counted): {credits_spent}")
    if unmade:
        print(f"\nLines not made: {len(unmade)}")
        for line in unmade:
            print(f"  {line['id']}: {line['text'][:50]}")


if __name__ == "__main__":
    main()
