"""sound_board.py - the operator's sound board: every sound in order, labelled, playable, with what it is for (S385).

The operator's ear is the only judge (S133: "did you approve those sounds for a AAA title ?"). This page is how a sound reaches
him: numbered players with the audio embedded (one self-contained .html - opens on his PC or phone, no server), the event it
plays on, the prompt it came from, its numbers, and UNHEARD until he keeps it. Plus a plain .txt list in the same order.

    python tools/sound_board.py [--round "Round 1"] [--only unheard|all] [--out docs/audio/board]
      -> docs/audio/board/sound_board.html + sound_board.txt + sound_reel.mp4 (one numbered card per sound, its audio under
         it, 0.8 s of silence between - for the ops board's /review page, which plays video; sound is the subject, so not -an)
"""
from __future__ import annotations

import argparse
import base64
import html
import json
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime
from pathlib import Path

GAME = Path(__file__).resolve().parent.parent
MANIFEST = GAME / "assets" / "audio" / "sounds.json"
SESSION = ""   # set by --session

WHEN = {  # what the player is seeing when it plays (plain words, for the board)
    "pads_mitt_jab": "pad night: a jab pops into the coach's mitt", "pads_mitt_power": "pad night: a power punch thuds into the mitt",
    "pads_mitt_combo": "pad night: a quick combination on the mitts", "pads_coach_clap": "pad night: the coach claps the mitts to call the next drill",
    "corner_stool": "corner minute: the stool goes down", "corner_water_spray": "corner minute: water for the boxer",
    "corner_towel": "corner minute: the towel on her face", "clinch_grapple": "a clinch: gloves and shoulders tied up",
    "clinch_break": "the referee breaks the clinch", "gym_ambience_loop": "the gym floor: room tone under every gym screen (loops)",
    "punch_jab_head": "a jab lands on the head", "punch_power_head": "a cross, hook or uppercut lands on the head",
    "punch_body": "a punch lands on the body", "punch_big": "the round's big shot lands (slow-motion close-up)",
    "punch_blocked": "a punch hits the gloves / arms", "punch_miss": "a punch misses (glove whoosh)",
    "bell_round_start": "the round starts", "bell_round_end": "the round ends",
    "crowd_arena_loop": "under the whole round (loops)", "crowd_roar": "the crowd after a big shot / knockdown",
    "knockdown_fall": "a boxer hits the canvas", "footwork_canvas": "boxers step in and out on the canvas",
    "ui_click": "any button in the menus",
}


def build(round_name: str, only: str, out: Path) -> tuple[Path, Path]:
    d = json.loads(MANIFEST.read_text(encoding="utf-8"))
    tier = {e: int(v.get("tier", 9)) for e, v in d["events"].items()}
    order = list(d["events"])
    rows = [(rel, r) for rel, r in d["files"].items() if (only == "all" or not r.get("heard"))
            and (not SESSION or r.get("session") == SESSION)]   # S473: --session S473 = one round's sounds only
    rows.sort(key=lambda x: (tier.get(x[1]["event"], 9), order.index(x[1]["event"]) if x[1]["event"] in order else 99, x[0]))
    out.mkdir(parents=True, exist_ok=True)
    cards, lines = [], [f"FightCamp sound board - {round_name} - {datetime.now():%Y-%m-%d %H:%M}",
                        "NOBODY HAS LISTENED TO THESE YET. Claude and the agents cannot hear. Your ear decides: keep / redo / drop.",
                        "Made with Ludo audio (your Pro plan). Numbers: loudness (LUFS), peak (dB), length (s).", ""]
    for i, (rel, r) in enumerate(rows, 1):
        ev = r["event"]
        p = GAME / rel
        b64 = base64.b64encode(p.read_bytes()).decode()
        loud = r.get("mmax") if r.get("lufs", -70) <= -69 else r.get("lufs")
        heard = "KEPT" if r.get("heard") else "UNHEARD"
        lines.append(f"{i:2}. {ev}  ({Path(rel).name})  - plays when {WHEN.get(ev, ev.replace('_', ' '))}")
        lines.append(f"    {heard}. {r.get('dur')} s, loudness {loud}, peak {r.get('tp')} dB. Prompt: {r.get('prompt', '')}")
        cards.append(f"""<section class="card"><div class="n">{i}</div><div class="body">
<h2>{html.escape(ev)} <span class="tag {heard.lower()}">{heard}</span></h2>
<p class="when">Plays when {html.escape(WHEN.get(ev, ev.replace('_', ' ')))}.</p>
<audio controls preload="auto" src="data:audio/ogg;base64,{b64}"></audio>
<p class="meta">{r.get('dur')} s &middot; loudness {loud} &middot; peak {r.get('tp')} dB &middot; {html.escape(Path(rel).name)}</p>
<details><summary>Ludo prompt</summary><p>{html.escape(r.get('prompt', ''))}</p></details>
</div></section>""")
    lines += ["", "Reply on the board with the numbers: e.g. '1 keep, 2 redo heavier, 5 drop'."]
    page = f"""<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Sound Board</title><style>
:root{{--bg:#16120f;--card:#221c17;--fg:#f1e8dc;--mut:#b3a593;--acc:#e0a33a;--red:#e2574c}}
body{{margin:0;background:var(--bg);color:var(--fg);font:16px/1.45 system-ui,Segoe UI,sans-serif}}
main{{max-width:760px;margin:0 auto;padding:20px 16px 60px}} h1{{font-size:26px;margin:0 0 4px}}
.warn{{background:#3a1d18;border-left:4px solid var(--red);padding:10px 14px;border-radius:6px;margin:14px 0 20px}}
.card{{display:flex;gap:14px;background:var(--card);border-radius:10px;padding:14px;margin:10px 0}}
.n{{font-size:28px;font-weight:700;color:var(--acc);min-width:36px;text-align:right}} .body{{flex:1;min-width:0}}
h2{{font-size:18px;margin:0 0 4px;word-break:break-word}} .when{{margin:0 0 8px;color:var(--mut)}} audio{{width:100%}}
.meta{{font-size:13px;color:var(--mut);margin:6px 0 0}} details{{font-size:13px;color:var(--mut)}}
.tag{{font-size:11px;padding:2px 7px;border-radius:9px;vertical-align:middle;margin-left:6px}}
.unheard{{background:var(--red);color:#fff}} .kept{{background:#3f8f4f;color:#fff}}
</style></head><body><main><h1>FightCamp sound board</h1><div>{html.escape(round_name)} &middot; {len(rows)} sounds &middot; {datetime.now():%Y-%m-%d}</div>
<div class="warn"><b>Nobody has listened to these yet.</b> Claude and the agents cannot hear. Your ear decides each one:
keep, redo (say how), or drop. Reply with the numbers, e.g. "1 keep, 2 redo heavier, 5 drop".</div>
{''.join(cards)}</main></body></html>"""
    hp, tp = out / "sound_board.html", out / "sound_board.txt"
    hp.write_text(page, encoding="utf-8")
    tp.write_text("\n".join(lines) + "\n", encoding="utf-8")
    reel(rows, out / "sound_reel.mp4", round_name)
    print(f"SOUND_BOARD {len(rows)} sounds -> {hp.relative_to(GAME)} + {tp.name} + sound_reel.mp4")
    return hp, tp


def reel(rows: list, mp4: Path, round_name: str) -> None:
    """Numbered title cards, each held for its sound + 0.8 s, concatenated into one small mp4 (silent PC, no window)."""
    ff = shutil.which("ffmpeg") or "ffmpeg"
    font = r"C\:/Windows/Fonts/arialbd.ttf"
    flags = getattr(subprocess, "CREATE_NO_WINDOW", 0)
    with tempfile.TemporaryDirectory() as td:
        parts = []
        for i, (rel, r) in enumerate(rows, 1):
            ev = r["event"]
            txt = Path(td) / f"t{i}.txt"
            txt.write_text(f"{i}.  {ev}\nplays when {WHEN.get(ev, ev.replace('_', ' '))}\nUNHEARD - your ear decides",
                           encoding="utf-8")
            dur = float(r.get("dur") or 1.0) + 0.8
            part = Path(td) / f"p{i:02}.mp4"
            tf = str(txt).replace("\\", "/").replace(":", r"\:")
            subprocess.run([ff, "-y", "-hide_banner", "-loglevel", "error", "-f", "lavfi", "-t", f"{dur:.2f}", "-i",
                            "color=c=0x16120f:s=1280x720:r=24", "-i", str(GAME / rel), "-filter_complex",
                            f"[0:v]drawtext=fontfile='{font}':textfile='{tf}':fontcolor=0xf1e8dc:fontsize=44:line_spacing=18:"
                            f"x=80:y=(h-text_h)/2[v];[1:a]aresample=48000,aformat=channel_layouts=stereo,apad=whole_dur={dur:.2f}[a]",
                            "-map", "[v]", "-map", "[a]", "-t", f"{dur:.2f}", "-c:v", "libx264", "-preset", "veryfast",
                            "-crf", "30", "-pix_fmt", "yuv420p", "-c:a", "aac", "-b:a", "160k", str(part)],
                           capture_output=True, creationflags=flags)
            if part.exists():
                parts.append(part)
        lst = Path(td) / "list.txt"
        lst.write_text("".join(f"file '{q.as_posix()}'\n" for q in parts), encoding="utf-8")
        subprocess.run([ff, "-y", "-hide_banner", "-loglevel", "error", "-f", "concat", "-safe", "0", "-i", str(lst),
                        "-c", "copy", str(mp4)], capture_output=True, creationflags=flags)
    print(f"SOUND_REEL {len(parts)}/{len(rows)} cards -> {mp4.name}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--round", default="Round 1")
    ap.add_argument("--only", default="unheard", choices=["unheard", "all"])
    ap.add_argument("--session", default="")
    ap.add_argument("--out", default=str(GAME / "docs" / "audio" / "board"))
    a = ap.parse_args()
    global SESSION
    SESSION = a.session
    build(a.round, a.only, Path(a.out))
    return 0


if __name__ == "__main__":
    sys.exit(main())
