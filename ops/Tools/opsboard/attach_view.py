"""Attachments for board questions (S191).

Operator S191: "when i need to approve something i want to be able to see it on the opsboard".
A question in AgentComms/questions.json may carry "attach": [repo paths]. The board shows a .md/.txt as a
readable page and an image inline. Only the roots and suffixes below are served - nothing else.
"""
from __future__ import annotations

import html
import re
from pathlib import Path

ATTACH_ROOTS = ("research/", "Godot/docs/", "Godot/concepts/", "AgentComms/")
ATTACH_IMAGES = {".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg", ".webp": "image/webp", ".gif": "image/gif"}
ATTACH_TEXT = (".md", ".txt")

PAGE_STYLE = (
    "body{background:#16130f;color:#eee4d6;font:14px/1.5 system-ui,sans-serif;max-width:1100px;margin:16px auto;padding:0 16px}"
    "table{border-collapse:collapse;margin:8px 0;display:block;overflow-x:auto}td,th{border:1px solid #4a4038;padding:4px 8px;vertical-align:top}"
    "th{background:#2b2520}pre{background:#221d18;padding:8px;overflow:auto}a{color:#f0b84a}img{max-width:100%}"
)


def attach_path(root: Path, rel: str) -> Path | None:
    rel = (rel or "").strip().replace("\\", "/").lstrip("/")
    if not rel or ".." in rel.split("/") or not rel.startswith(ATTACH_ROOTS):
        return None
    full = (root / rel).resolve()
    try:
        full.relative_to(root.resolve())
    except ValueError:
        return None
    suffix = full.suffix.lower()
    if not full.is_file() or (suffix not in ATTACH_IMAGES and suffix not in ATTACH_TEXT):
        return None
    return full


def _inline(text: str) -> str:
    out = html.escape(text, quote=False)
    out = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", out)
    out = re.sub(r"`([^`]+)`", r"<code>\1</code>", out)
    out = out.replace("&lt;br&gt;", "<br>")
    # Ludo writes small LaTeX bits: $\times 1.35$, $\ge 3$, $>45\text{ s}$
    out = re.sub(r"\$\\times\s*([0-9.]+)\$", r"x\1", out)
    out = re.sub(r"\$\\ge\s*([0-9.]+)\$", r"&ge; \1", out)
    out = re.sub(r"\$&gt;([0-9.]+)\\text\{\s*([a-z]+)\}\$", r"&gt; \1 \2", out)
    out = out.replace("$\\rightarrow$", "&rarr;")
    return out


def md_to_html(text: str) -> str:
    """Small Markdown subset: headings, tables, code fences, bullets, paragraphs."""
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    bullet = re.compile(r"\s*[-*•]\s+")
    while i < len(lines):
        line = lines[i]
        if line.strip().startswith("```"):
            block: list[str] = []
            i += 1
            while i < len(lines) and not lines[i].strip().startswith("```"):
                block.append(lines[i])
                i += 1
            out.append("<pre>" + html.escape("\n".join(block)) + "</pre>")
            i += 1
            continue
        if line.lstrip().startswith("|"):
            rows: list[str] = []
            while i < len(lines) and lines[i].lstrip().startswith("|"):
                rows.append(lines[i])
                i += 1
            cells = [[c.strip() for c in r.strip().strip("|").split("|")] for r in rows]
            cells = [c for c in cells if not all(re.fullmatch(r":?-{2,}:?", x or "--") for x in c)]
            if cells:
                head, body = cells[0], cells[1:]
                out.append("<table><tr>" + "".join(f"<th>{_inline(c)}</th>" for c in head) + "</tr>"
                           + "".join("<tr>" + "".join(f"<td>{_inline(c)}</td>" for c in r) + "</tr>" for r in body) + "</table>")
            continue
        m = re.match(r"(#{1,4})\s+(.*)", line)
        if m:
            level = len(m.group(1)) + 1
            out.append(f"<h{level}>{_inline(m.group(2))}</h{level}>")
            i += 1
            continue
        if bullet.match(line):
            items: list[str] = []
            while i < len(lines) and bullet.match(lines[i]):
                items.append(bullet.sub("", lines[i], count=1))
                i += 1
            out.append("<ul>" + "".join(f"<li>{_inline(x)}</li>" for x in items) + "</ul>")
            continue
        if not line.strip():
            i += 1
            continue
        para = [line]
        i += 1
        while i < len(lines) and lines[i].strip() and not lines[i].lstrip().startswith(("|", "#", "```")) and not bullet.match(lines[i]):
            para.append(lines[i])
            i += 1
        out.append("<p>" + _inline(" ".join(x.strip() for x in para)) + "</p>")
    return "\n".join(out)


def render(root: Path, rel: str, as_page: bool) -> tuple[int, bytes, str]:
    """(status, body, content type) for /attach (full page) and /api/attach (fragment json is built by the caller)."""
    full = attach_path(root, rel)
    if full is None:
        return 404, b"not an attachment\n", "text/plain; charset=utf-8"
    suffix = full.suffix.lower()
    if suffix in ATTACH_IMAGES:
        return 200, full.read_bytes(), ATTACH_IMAGES[suffix]
    body = md_to_html(full.read_text(encoding="utf-8", errors="replace"))
    if not as_page:
        return 200, body.encode("utf-8"), "text/html; charset=utf-8"
    page = (f"<!doctype html><meta charset=utf-8><meta name=viewport content='width=device-width,initial-scale=1'>"
            f"<title>{html.escape(full.name)}</title><style>{PAGE_STYLE}</style><p><a href='/'>&larr; ops board</a></p>{body}")
    return 200, page.encode("utf-8"), "text/html; charset=utf-8"
