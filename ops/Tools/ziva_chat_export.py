"""S265: Ziva chat logs -> readable markdown transcripts (operator: "ziva is compacting the text can you get it all out ?").

Ziva (zivacode sidecar) appends every chat, uncut, to %APPDATA%/Godot/app_userdata/FightCamp/ziva/zivacode-chats/<ts>_<id>.jsonl.
Compaction only shortens the model's working context - the log keeps every message, so nothing is lost; this writes it out.

Each transcript: user messages, Ziva's text and thinking in full, every tool call (name + args), tool results cut at
--result-chars (default 3000; 0 = whole), the compaction summaries in full. The raw .jsonl is copied beside it as a backup.
usage: python Tools/ziva_chat_export.py [--out research/ziva_chats] [--raw E:/FightCamp/ziva_chats_backup] [--result-chars N]
"""
import argparse
import json
import os
import shutil
from pathlib import Path

ZIVA = Path(os.environ.get("APPDATA", "")) / "Godot" / "app_userdata" / "FightCamp" / "ziva"


def _text(parts, result_chars: int) -> list:
    out = []
    if isinstance(parts, str):
        parts = [{"type": "text", "text": parts}]
    for p in parts or []:
        if not isinstance(p, dict):
            continue
        kind = p.get("type")
        if kind == "text":
            t = str(p.get("text", ""))
            if result_chars and len(t) > result_chars:
                t = t[:result_chars] + "\n... [%d more chars cut]" % (len(t) - result_chars)
            out.append(t)
        elif kind == "thinking":
            out.append("> _thinking:_ " + str(p.get("thinking", "")).replace("\n", "\n> "))
        elif kind in ("toolCall", "tool_call", "tool_use"):
            args = p.get("arguments", p.get("input", {}))
            out.append("**tool `%s`**\n```\n%s\n```" % (p.get("name", "?"), json.dumps(args, ensure_ascii=False, indent=1)[:6000]))
        elif kind == "image":
            out.append("_[image]_")
    return out


def export(path: Path, out_dir: Path, result_chars: int) -> Path:
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    md = ["# Ziva chat %s" % path.stem, "", "Source: `%s` (%d log entries)" % (path.name, len(lines)), ""]
    for raw in lines:
        try:
            e = json.loads(raw)
        except ValueError:
            continue
        ts = str(e.get("timestamp", ""))[:19].replace("T", " ")
        kind = e.get("type")
        if kind == "message":
            m = e.get("message") or {}
            role = m.get("role", "?")
            cut = result_chars if role == "toolResult" else 0
            body = _text(m.get("content"), cut)
            if role == "toolResult":
                md.append("#### result `%s` %s\n```\n%s\n```" % (m.get("toolName", "?"), ts, "\n".join(body).replace("```", "'''")))
            else:
                md.append("## %s %s\n\n%s" % (role.upper(), ts, "\n\n".join(body)))
        elif kind == "compaction":
            summary = e.get("summary") or e.get("text") or json.dumps({k: v for k, v in e.items() if k not in ("id", "parentId")}, ensure_ascii=False)
            md.append("## COMPACTION %s\n\n%s" % (ts, summary))
        elif kind in ("custom_message", "context_edit"):
            md.append("## %s %s\n\n%s" % (kind.upper(), ts, "\n\n".join(_text(e.get("content"), 0)) or json.dumps(e, ensure_ascii=False)[:3000]))
        elif kind == "model_change":
            md.append("_model: %s %s_" % (e.get("modelId"), ts))
        md.append("")
    out = out_dir / ("ZIVA_CHAT_%s.md" % path.stem)
    out.write_text("\n".join(md), encoding="utf-8")
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="research/ziva_chats")
    ap.add_argument("--raw", default="E:/FightCamp/ziva_chats_backup")
    ap.add_argument("--result-chars", type=int, default=3000)
    a = ap.parse_args()
    out_dir, raw_dir = Path(a.out), Path(a.raw)
    out_dir.mkdir(parents=True, exist_ok=True)
    raw_dir.mkdir(parents=True, exist_ok=True)
    for src in sorted((ZIVA / "zivacode-chats").glob("*.jsonl")) + sorted((ZIVA / "memory").glob("*.md")):
        shutil.copy2(src, raw_dir / src.name)
    for src in sorted((ZIVA / "zivacode-chats").glob("*.jsonl")):
        out = export(src, out_dir, a.result_chars)
        print("ZIVA_EXPORT %s -> %s (%d KB)" % (src.name, out, out.stat().st_size // 1024))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
