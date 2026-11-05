"""audio_prep.py - turn a Ludo audio download into a game-ready file and measure it (S385, the sound engineer's pipeline).

Nobody on the team can hear but the operator, so every check here is a number. One file in, one .ogg out in assets/audio/<group>/,
and its row in assets/audio/sounds.json (the one source of truth the game's SoundBank reads).

    python tools/audio_prep.py add <src.mp3|wav> --event punch_jab_head --group fight --bus SFX [--kind sfx|loop|music]
                               [--prompt "<the Ludo description>"] [--credits 2] [--tier 1]
    python tools/audio_prep.py measure <file>      # loudness (LUFS), true peak, duration, lead silence, channels, rate
    python tools/audio_prep.py check               # every sounds.json row: file exists + inside the targets below

What `add` does (ffmpeg): trims leading silence (below -50 dB) on one-shots, makes one-shots MONO (3D/pan-able) and keeps loops
and music stereo, resamples to 48 kHz, normalises loudness to the kind's target (two-pass loudnorm), caps the true peak, fades the
last 10 ms of a one-shot (no click), encodes Ogg Vorbis (no MP3 encoder padding = no gap in a loop), names it <event>_<n>.ogg.
Every new row is heard=false: only the operator's ear on the sound board flips it.
"""
from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from datetime import datetime
from pathlib import Path

GAME = Path(__file__).resolve().parent.parent
AUDIO = GAME / "assets" / "audio"
MANIFEST = AUDIO / "sounds.json"
FFMPEG = shutil.which("ffmpeg") or "ffmpeg"

# Loudness targets per kind (integrated LUFS for the file itself, before the bus volumes). Starting values from the S385 sound
# benchmark (ops/research/SOUND_BENCHMARK_S385.md); the buses then set the mix. TP = true-peak ceiling in dBTP.
# One-shots (sfx, voice) are too short for integrated loudness (EBU R128 gates in 400 ms blocks: a 0.3 s jab reads -inf), so
# they are levelled on their MOMENTARY MAX (the loudest 400 ms window, the clip padded with silence) - `lufs` is that number for them.
TARGETS = {
    "sfx": {"lufs": -14.0, "tp": -1.0, "mono": True, "q": 6, "max_s": 3.0},
    "loop": {"lufs": -20.0, "tp": -2.0, "mono": False, "q": 5, "max_s": 120.0},
    "music": {"lufs": -18.0, "tp": -1.0, "mono": False, "q": 5, "max_s": 240.0},
    "voice": {"lufs": -16.0, "tp": -1.0, "mono": True, "q": 6, "max_s": 4.0},
}
TOL_LUFS = 2.0


def run(args: list[str]) -> str:
    p = subprocess.run(args, capture_output=True, text=True, encoding="utf-8", errors="replace",
                       creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
    return p.stdout + p.stderr


def measure(path: Path) -> dict:
    """LUFS, true peak, duration, lead silence, channels, sample rate - all from ffmpeg/ffprobe."""
    out = run([FFMPEG, "-hide_banner", "-nostats", "-i", str(path), "-af",
               "ebur128=peak=true,silencedetect=noise=-50dB:d=0.02", "-f", "null", "-"])
    m = {"mmax": momentary_max(path, [])}
    sm = re.findall(r"I:\s+(-?[\d.]+|-inf) LUFS", out)
    m["lufs"] = float(sm[-1]) if sm and sm[-1] != "-inf" else -99.0
    pk = re.findall(r"Peak:\s+(-?[\d.]+|-inf) dBFS", out)
    m["tp"] = float(pk[-1]) if pk and pk[-1] != "-inf" else -99.0
    d = re.search(r"Duration: (\d+):(\d+):([\d.]+)", out)
    m["dur"] = round(int(d.group(1)) * 3600 + int(d.group(2)) * 60 + float(d.group(3)), 3) if d else 0.0
    st = re.search(r"silence_start: (-?[\d.]+)", out)
    se = re.search(r"silence_end: ([\d.]+)", out)
    m["lead_silence"] = round(float(se.group(1)), 3) if st and float(st.group(1)) <= 0.001 and se else 0.0
    a = re.search(r"Audio: (\w+), (\d+) Hz, (mono|stereo|[\d.]+ channels|\w+)", out)
    if a:
        m["codec"], m["rate"], m["channels"] = a.group(1), int(a.group(2)), a.group(3)
    return m


def momentary_max(path: Path, chain: list[str]) -> float:
    """The loudest 400 ms window (LUFS-M) of the file after `chain`, padded with 0.5 s of silence so a short clip still fills one."""
    out = run([FFMPEG, "-hide_banner", "-nostats", "-v", "verbose", "-i", str(path), "-af",
               ",".join(chain + ["apad=pad_dur=0.5", "ebur128=framelog=verbose"]), "-f", "null", "-"])
    vals = [float(v) for v in re.findall(r" M:\s*(-?[\d.]+)", out)]
    return round(max(vals), 2) if vals else -99.0


def load() -> dict:
    if MANIFEST.exists():
        return json.loads(MANIFEST.read_text(encoding="utf-8"))
    return {"_doc": "FightCamp sounds (S385). events: what the game plays (SoundBank.gd reads it); files: each asset, its Ludo "
                    "prompt and numbers. heard=false until the operator keeps it on the sound board.", "events": {}, "files": {}}


def save(d: dict) -> None:
    AUDIO.mkdir(parents=True, exist_ok=True)
    MANIFEST.write_text(json.dumps(d, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")


def add(a) -> int:
    src = Path(a.src)
    t = TARGETS[a.kind]
    d = load()
    ev = d["events"].setdefault(a.event, {"bus": a.bus, "group": a.group, "kind": a.kind, "tier": a.tier, "files": [],
                                          "volume_db": 0.0, "pitch": 0.04 if a.kind == "sfx" else 0.0,
                                          "loop": a.kind in ("loop", "music")})
    n = len(ev["files"]) + 1
    rel = f"assets/audio/{a.group}/{a.event}_{n}.ogg"
    dst = GAME / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    chain = []
    if a.kind in ("sfx", "voice"):
        chain.append("silenceremove=start_periods=1:start_threshold=-50dB:start_silence=0.005")
    chain.append("aresample=48000")
    lim = 10 ** ((t["tp"] - 0.5) / 20.0)
    if a.kind in ("sfx", "voice"):
        # Level on the momentary max, then a brick-wall limiter under the true-peak ceiling, then a 10 ms fade-out (no click).
        # A short transient (a 0.2 s jab) can sit 20 dB under its peak: never let the limiter take more than 3 dB off it, or the
        # snap turns into a flat block. Such a clip lands quieter than the target and its event volume_db makes it up.
        gain = min(t["lufs"] - momentary_max(src, chain), t["tp"] - measure(src)["tp"] + 3.0)
        chain += [f"volume={gain:.2f}dB", f"alimiter=limit={lim:.4f}:level=disabled:attack=1:release=20",
                  "areverse,afade=t=in:d=0.01,areverse"]
    else:
        # Loops and music: two-pass integrated loudnorm, then the same limiter.
        probe = run([FFMPEG, "-hide_banner", "-i", str(src), "-af", ",".join(chain + [
            f"loudnorm=I={t['lufs']}:TP={t['tp']}:LRA=11:print_format=json"]), "-f", "null", "-"])
        js = re.search(r"\{[^{}]*\"input_i\"[^{}]*\}", probe, re.S)
        if js:
            j = json.loads(js.group(0))
            chain.append(f"loudnorm=I={t['lufs']}:TP={t['tp']}:LRA=11:measured_I={j['input_i']}:measured_TP={j['input_tp']}:"
                         f"measured_LRA={j['input_lra']}:measured_thresh={j['input_thresh']}:offset={j['target_offset']}:linear=true")
        else:
            chain.append(f"loudnorm=I={t['lufs']}:TP={t['tp']}:LRA=11")
        chain += ["aresample=48000", f"alimiter=limit={lim:.4f}:level=disabled"]
    args = [FFMPEG, "-y", "-hide_banner", "-loglevel", "error", "-i", str(src), "-af", ",".join(chain)]
    if t["mono"]:
        args += ["-ac", "1"]
    args += ["-c:a", "libvorbis", "-q:a", str(t["q"]), str(dst)]
    err = run(args)
    if not dst.exists():
        print("AUDIO_PREP FAIL", err[-400:])
        return 1
    m = measure(dst)
    ev["files"].append("res://" + rel)
    d["files"][rel] = {"event": a.event, "prompt": a.prompt, "source": f"ludo audio {a.kind}", "credits": a.credits,
                       "from": src.name, "made": datetime.now().strftime("%Y-%m-%d %H:%M"), **m, "heard": False, "verdict": ""}
    save(d)
    print(f"AUDIO_PREP {rel} mmax={m['mmax']} lufs={m['lufs']} tp={m['tp']} dur={m['dur']} lead={m['lead_silence']} {m.get('channels')}")
    return 0


def check() -> int:
    d = load()
    bad = 0
    for ev_id, ev in d["events"].items():
        t = TARGETS[ev.get("kind", "sfx")]
        if not ev["files"]:
            print(f"CHECK FAIL {ev_id}: no file")
            bad += 1
        for f in ev["files"]:
            rel = f.replace("res://", "")
            p = GAME / rel
            if not p.exists():
                print(f"CHECK FAIL {ev_id}: missing {rel}")
                bad += 1
                continue
            m = measure(p)
            why = []
            loud = m["mmax"] if ev.get("kind", "sfx") in ("sfx", "voice") else m["lufs"]
            if abs(loud - t["lufs"]) > TOL_LUFS:
                why.append(f"loudness {loud} vs {t['lufs']}")
            if m["tp"] > t["tp"] + 0.5:
                why.append(f"peak {m['tp']} > {t['tp']}")
            if m["dur"] > t["max_s"]:
                why.append(f"dur {m['dur']} > {t['max_s']}")
            if ev.get("kind") in ("sfx", "voice") and m["lead_silence"] > 0.02:
                why.append(f"lead silence {m['lead_silence']}")
            if m.get("rate") != 48000:
                why.append(f"rate {m.get('rate')}")
            print(("CHECK FAIL " if why else "CHECK OK   ") + f"{rel} " + ("; ".join(why) if why else
                  f"lufs={m['lufs']} tp={m['tp']} dur={m['dur']}"))
            bad += bool(why)
    unheard = sum(1 for r in d["files"].values() if not r.get("heard"))
    print(f"AUDIO_CHECK events={len(d['events'])} files={len(d['files'])} failures={bad} unheard={unheard}")
    return 1 if bad else 0


def main() -> int:
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    p = sub.add_parser("add")
    p.add_argument("src")
    p.add_argument("--event", required=True)
    p.add_argument("--group", required=True)
    p.add_argument("--bus", default="SFX")
    p.add_argument("--kind", default="sfx", choices=list(TARGETS))
    p.add_argument("--prompt", default="")
    p.add_argument("--credits", type=int, default=2)
    p.add_argument("--tier", type=int, default=1)
    m = sub.add_parser("measure")
    m.add_argument("file")
    sub.add_parser("check")
    a = ap.parse_args()
    if a.cmd == "add":
        return add(a)
    if a.cmd == "measure":
        print(json.dumps(measure(Path(a.file))))
        return 0
    return check()


if __name__ == "__main__":
    sys.exit(main())
