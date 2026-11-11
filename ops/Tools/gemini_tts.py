"""gemini_tts.py - voice lines from Google's Gemini text-to-speech (S434, operator: "yes make the test batch").

Google's own API with the GEMINI_API_KEY already used by gemini_judge.py (not the gemini-tts.com reseller, whose free plan
is personal use only). Speech only; sound effects and music stay with Ludo (project_sound_engineer_qwen_s385).

    python ops/Tools/gemini_tts.py <lines.json> <out_dir> [--model gemini-3.8-flash-tts]
lines.json: [{"id": "announcer_a", "voice": "Fenrir", "style": "an excited ring announcer", "text": "..."}, ...]
Writes <out_dir>/<id>.wav (24 kHz mono, as Google returns it) and <id>.ogg (48 kHz, game format, via ffmpeg), and
<out_dir>/board.html: every line playable (audio embedded), its voice, style and words, marked UNHEARD (the ear rule).
"""
import base64
import html
import json
import os
import subprocess
import sys
import wave
from pathlib import Path

import requests

API = "https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent"


def speak(key: str, model: str, voice: str, style: str, text: str) -> bytes:
    body = {
        "contents": [{"parts": [{"text": f"Say it as {style}: {text}"}]}],
        "generationConfig": {"responseModalities": ["AUDIO"],
                             "speechConfig": {"voiceConfig": {"prebuiltVoiceConfig": {"voiceName": voice}}}},
    }
    r = requests.post(API.format(model=model), json=body, headers={"x-goog-api-key": key}, timeout=180)
    if r.status_code != 200:
        raise SystemExit(f"TTS FAIL {r.status_code}: {r.text[:400]}")
    part = r.json()["candidates"][0]["content"]["parts"][0]["inlineData"]
    return base64.b64decode(part["data"])


def main() -> None:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    model = "gemini-3.8-flash-tts"
    if "--model" in sys.argv:
        model = sys.argv[sys.argv.index("--model") + 1]
        args = [a for a in args if a != model]
    lines = json.loads(Path(args[0]).read_text(encoding="utf-8"))
    out = Path(args[1])
    out.mkdir(parents=True, exist_ok=True)
    key = os.environ["GEMINI_API_KEY"]
    rows = []
    for ln in lines:
        pcm = speak(key, model, ln["voice"], ln["style"], ln["text"])
        wav = out / f"{ln['id']}.wav"
        with wave.open(str(wav), "wb") as w:
            w.setnchannels(1)
            w.setsampwidth(2)
            w.setframerate(24000)
            w.writeframes(pcm)
        ogg = out / f"{ln['id']}.ogg"
        subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(wav), "-ar", "48000", "-c:a", "libvorbis", "-q:a", "6",
                        str(ogg)], check=True)
        secs = len(pcm) / 2 / 24000
        rows.append((ln, wav, secs))
        print(f"TTS {ln['id']} {ln['voice']} {secs:.1f} s")
    cards = []
    for i, (ln, wav, secs) in enumerate(rows, 1):
        b64 = base64.b64encode(wav.read_bytes()).decode()
        cards.append(f"""<div class="c"><div class="n">{i}</div><div class="b"><div class="t">{html.escape(ln['id'])}
 <span class="u">UNHEARD</span></div><div class="m">voice {html.escape(ln['voice'])} &middot; {html.escape(ln['style'])}
 &middot; {secs:.1f} s</div><div class="w">&ldquo;{html.escape(ln['text'])}&rdquo;</div>
<audio controls preload="auto" src="data:audio/wav;base64,{b64}"></audio></div></div>""")
    page = f"""<!doctype html><html><head><meta charset="utf-8"><title>Voice test batch</title><style>
body{{background:#14110d;color:#f2e9d8;font:18px Arial,sans-serif;margin:24px}} h1{{color:#f0c040;margin:0 0 6px}}
p{{color:#b9ad97;margin:0 0 18px}} .c{{display:flex;gap:16px;background:#221c15;border-radius:10px;padding:14px;margin:10px 0}}
.n{{font:bold 34px Arial;color:#f0c040;width:40px}} .t{{font-weight:bold;font-size:20px}} .u{{color:#ff8a65;font-size:14px;margin-left:8px}}
.m{{color:#b9ad97;font-size:15px;margin:4px 0}} .w{{margin:6px 0 10px;font-style:italic}} audio{{width:100%}}
</style></head><body><h1>Voice test batch (Gemini text-to-speech, model {html.escape(model)})</h1>
<p>Every line is UNHEARD until you keep it. Tell me by number: keep, redo (what to change), or drop.</p>
{''.join(cards)}</body></html>"""
    (out / "board.html").write_text(page, encoding="utf-8")
    print(f"BOARD {out / 'board.html'}")


if __name__ == "__main__":
    main()
