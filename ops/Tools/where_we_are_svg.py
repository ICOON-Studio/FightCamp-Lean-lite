"""where_we_are_svg.py - Canvas Composer SVG for the Miro frame "P0 Where we are" (S385).

`render(cards)` takes the where_we_are.py JSON ({session, done_earlier, done_session, now, next}; each a list of
{text, who}) and returns the SVG for the whole frame. `python Tools/where_we_are.py svg` prints it.

BOARD + FRAME
    board  https://miro.com/app/board/uXjVEV03QWA=/   (FightCamp production map)
    frame  "P0 Where we are"  widget id 3458764689579200297 (FRAME_ID; also in AgentComms/where_we_are_miro.json)
    link   https://miro.com/app/board/uXjVEV03QWA=/?moveToWidget=3458764689579200297
    It sits directly above the "P0. The whole production" frame, left edge x=6000; its BOTTOM edge is pinned at
    y=-77 (160 above the board title), so a taller frame grows upward and never reaches the board title.

REDRAW = ONE MIRO CALL (no composer skill needed)
    1. python ops/Tools/where_we_are.py svg > E:/FightCamp/tmp/wwa.svg
    2. Miro MCP tool  mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__canvas_update_from_svg  with
           miro_url = "https://miro.com/app/board/uXjVEV03QWA=/"
           svg      = the full text of E:/FightCamp/tmp/wwa.svg
       (load it first: ToolSearch "select:mcp__7308b134-feb7-4aa9-9a3c-39cae47ed6e1__canvas_update_from_svg").
       The frame is targeted by its data-miro-id on the <g data-frame> element, and every child carries its own
       data-miro-id, so the update edits these widgets in place (text, colour, position, frame height). Nothing else
       on the board is touched: update_from_svg only edits ids it is given and only deletes elements marked
       data-deleted="true", and the only ones this module ever marks are its own surplus card slots.
    3. Read step 1's stderr. Nothing printed (same card counts as last time) -> step 2 was the whole job.
       "where_we_are_svg: LEARN ..." (a column gained cards): write the call's result_svg to
       E:/FightCamp/tmp/wwa_result.svg and run
           python ops/Tools/where_we_are_svg.py learn E:/FightCamp/tmp/wwa_result.svg
       It stores the ids Miro gave the new cards in AgentComms/where_we_are_miro.json.
       The file only needs the frame's <g ... data-frame="P0 Where we are"> line, the new elements (the ones that
       had no data-miro-id in wwa.svg; result_svg returns them with id="wwa_card_now_3" etc. plus their new
       data-miro-id) and </g></svg>. Skipping it makes the NEXT redraw create those cards a second time.
       "where_we_are_svg: TRIM ..." (a column lost cards; the update deleted the surplus slots):
           python ops/Tools/where_we_are_svg.py trim E:/FightCamp/tmp/wwa.svg      (the file you pushed)
       Both lines can appear (one column grew, another shrank): run both.
    Expected result of step 2: "0 created, 0 updated" when nothing changed; only the changed cards count as updated.
    The frame is 2970 wide (fixed); its height follows the longest column (12 cards = 1970).

IDS (stable, cheap to recover)
    AgentComms/where_we_are_miro.json maps layout keys (title, legend, hdr_done, panel_now, card:now:2, box:now:2, ...)
    to Miro widget ids. Cards are slots: slot N of a column keeps its two widgets (card + checkbox) forever; a new
    text in that slot just edits the card. If the ledger is lost or out of date, rebuild it with one read:
        canvas_read_as_svg  miro_url=<board>  widget_ids=["3458764689579200297"]   -> save the svg to a file, then
        python ops/Tools/where_we_are_svg.py learn <file>
    `learn` matches by the local ids this module writes, else by position inside the frame (the layout is fixed).

Other commands (tests):
    python ops/Tools/where_we_are_svg.py render <cards.json>        # SVG from a JSON file instead of roadmap.json
    python ops/Tools/where_we_are_svg.py learn <svg> [--json <cards.json>]
    python ops/Tools/where_we_are_svg.py trim <pushed svg>
    python ops/Tools/where_we_are_svg.py ids

Look (owner's other project, scaled x2.5 for this board, whose body text is 33 px): light blue header bars
(#c9daf8) over pale panels (#eef3fb); white rounded cards with a 4 px border in the `who` colour (claude #9b6dff,
agent #4a9fe8, operator #f5a623), 30 px text top-left, a grey checkbox square bottom-left. Cards are 640x100
(256x40 before scaling, not 128x36) so a 34-character text (where_we_are.TEXT_MAX) stays on one line.
"""
from __future__ import annotations

import datetime as _dt
import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from xml.sax.saxutils import escape

OPS = Path(__file__).resolve().parent.parent
LEDGER = OPS / "AgentComms" / "where_we_are_miro.json"
BOARD = "https://miro.com/app/board/uXjVEV03QWA=/"
FRAME_ID = "3458764689579200297"  # filled by the S385 build; the ledger's "frame" wins if they differ
TITLE = "P0 Where we are"

# Layout in the owner's units (his other board), multiplied by S for this board, whose body text is 33 px.
S = 2.5
FRAME_X = 6000          # left edge = the P0 frame's left edge
FRAME_BOTTOM = -77      # board title "FightCamp production map" starts at y=83; 160 gap
PAD = 24                # frame inner padding
CARD_W, CARD_H, CARD_GAP = 256, 40, 8   # 256 (not 128) so a 34-character card text stays on one line
INNER = 12              # panel inner padding
COL_GAP = 16
HDR_H = 32
SUB_H = 16
BOX = 8                 # checkbox square
TITLE_Y, TITLE_SIZE = PAD, 36
LEGEND_Y, LEGEND_SIZE = PAD + 60, 12   # the 90 px title renders 129 tall
COLS_Y = PAD + 52 + 18 + 22
CARD_FONT, HDR_FONT, SUB_FONT = 12, 14, 11

HDR_FILL, PANEL_FILL = "#c9daf8", "#eef3fb"
INK, SUB_INK, BOX_FILL = "#1a1a1a", "#7f7f7f", "#cccccc"
WHO = {"claude": "#9b6dff", "agent": "#4a9fe8", "operator": "#f5a623"}
FONT = "noto_sans"


def _s(v: float) -> int:
    return int(round(v * S))


def _geometry() -> dict:
    done_w = 2 * CARD_W + INNER + 2 * INNER
    one_w = CARD_W + 2 * INNER
    x_done = PAD
    x_now = x_done + done_w + COL_GAP
    x_next = x_now + one_w + COL_GAP
    return {"done_w": done_w, "one_w": one_w, "x_done": x_done, "x_now": x_now, "x_next": x_next,
            "frame_w": x_next + one_w + PAD,
            # card columns: key -> left x of the cards
            "card_x": {"done_earlier": x_done + INNER, "done_session": x_done + INNER + CARD_W + INNER,
                       "now": x_now + INNER, "next": x_next + INNER}}


def _counts(cards: dict) -> dict:
    return {k: len(cards.get(k) or []) for k in ("done_earlier", "done_session", "now", "next")}


def layout(cards: dict, today: str | None = None) -> tuple[dict, list[dict]]:
    """Frame box + every child as {key, tag, attrs, body}; coordinates in board units, relative to the frame."""
    g = _geometry()
    n_max = max([1] + list(_counts(cards).values()))
    panel_y = COLS_Y + HDR_H
    cards_y0 = panel_y + INNER + SUB_H + CARD_GAP
    panel_h = (cards_y0 - panel_y) + n_max * (CARD_H + CARD_GAP) - CARD_GAP + INNER
    frame_h = panel_y + panel_h + PAD
    today = today or _dt.date.today().isoformat()
    session = str(cards.get("session") or "").strip() or "this session"
    el: list[dict] = []

    def text(key, y, size, body, color, bold=False, w=None, x=PAD):
        a = {"x": _s(x), "y": _s(y), "width": _s(w or (g["frame_w"] - 2 * PAD)), "fill": color,
             "font-family": FONT, "font-size": _s(size), "text-align": "left"}
        if bold:
            a["font-weight"] = "bold"
        el.append({"key": key, "tag": "textArea", "attrs": a, "body": body})

    def rect(key, x, y, w, h, fill, **extra):
        a = {"x": _s(x), "y": _s(y), "width": _s(w), "height": _s(h), "fill": fill}
        a.update(extra)
        el.append({"key": key, "tag": "rect", "attrs": a, "body": None})

    text("title", TITLE_Y, TITLE_SIZE, TITLE, INK, bold=True)
    # The legend is 4 text pieces side by side: Miro folds any run of spaces (plain, no-break, em) into one, so a
    # single text could not keep the gaps. Width per piece = a roomy estimate of its text width (0.62 em a character).
    lx = PAD
    for i, piece in enumerate(("purple = Claude", "blue = agent seats", "orange = waiting on you", f"updated {today}")):
        w = 0.62 * LEGEND_SIZE * len(piece) + 16
        text("legend" if i == 0 else f"legend_{i}", LEGEND_Y, LEGEND_SIZE, piece, "#595959", w=w, x=lx)
        lx += w + 3 * LEGEND_SIZE

    label = {"data-text-color": INK, "data-font-family": FONT, "data-font-weight": "bold",
             "data-text-align": "center", "data-text-align-vertical": "middle", "stroke": "none"}
    for name, x, w in (("done", g["x_done"], g["done_w"]), ("now", g["x_now"], g["one_w"]),
                       ("next", g["x_next"], g["one_w"])):
        rect(f"hdr_{name}", x, COLS_Y, w, HDR_H, HDR_FILL, **{"data-content": name.upper(),
                                                              "data-font-size": str(_s(HDR_FONT)), **label})
        rect(f"panel_{name}", x, panel_y, w, panel_h, PANEL_FILL, stroke="none")
    for key, col, body in (("sub_earlier", "done_earlier", "Earlier"),
                           ("sub_session", "done_session", f"Added in {session}")):
        el.append({"key": key, "tag": "textArea", "body": body,
                   "attrs": {"x": _s(g["card_x"][col]), "y": _s(panel_y + INNER), "width": _s(CARD_W),
                             "fill": SUB_INK, "font-family": FONT, "font-size": _s(SUB_FONT), "text-align": "left"}})

    for col in ("done_earlier", "done_session", "now", "next"):
        for i, c in enumerate(cards.get(col) or []):
            x, y = g["card_x"][col], cards_y0 + i * (CARD_H + CARD_GAP)
            who = c.get("who") if c.get("who") in WHO else "claude"
            rect(f"card:{col}:{i}", x, y, CARD_W, CARD_H, "#ffffff", rx=str(_s(6)), stroke=WHO[who],
                 **{"stroke-width": str(max(2, _s(1.6))), "data-content": " ".join(str(c.get("text", "")).split()),
                    "data-text-color": INK, "data-font-family": FONT, "data-font-size": str(_s(CARD_FONT)),
                    "data-text-align": "left", "data-text-align-vertical": "top"})
            rect(f"box:{col}:{i}", x + 8, y + CARD_H - 8 - BOX, BOX, BOX, BOX_FILL, rx=str(_s(1)), stroke="none")
    frame = {"x": FRAME_X, "y": FRAME_BOTTOM - _s(frame_h), "width": _s(g["frame_w"]), "height": _s(frame_h)}
    return frame, el


def _local(key: str) -> str:
    return "wwa_" + key.replace(":", "_")


def _attr(a: dict) -> str:
    return " ".join(f'{k}="{escape(str(v), {chr(34): "&quot;"})}"' for k, v in a.items())


def load_ledger() -> dict:
    try:
        d = json.loads(LEDGER.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        d = {}
    d.setdefault("board", BOARD)
    d.setdefault("frame", "")
    d.setdefault("ids", {})
    return d


def render(cards: dict, today: str | None = None, ledger: dict | None = None) -> str:
    """The Canvas Composer SVG for the whole frame. With a ledger, every known widget carries its data-miro-id."""
    led = ledger if ledger is not None else load_ledger()
    ids = led.get("ids", {})
    frame, el = layout(cards, today)
    fid = led.get("frame") or ""
    if FRAME_ID and not ids:
        raise SystemExit(f"where_we_are_svg: no widget ids in {LEDGER} - rebuild it first (canvas_read_as_svg "
                         f"widget_ids=[\"{FRAME_ID}\"], save, `learn <file>`); a render now would draw a second frame")
    out = ['<svg xmlns="http://www.w3.org/2000/svg">']
    mid = f' data-miro-id="{fid}"' if fid else ""
    out.append(f'<g id="wwa_frame"{mid} transform="translate({frame["x"]},{frame["y"]})" data-frame="{TITLE}">')
    out.append(f'<rect data-type="frame" x="0" y="0" width="{frame["width"]}" height="{frame["height"]}" '
               f'fill="#ffffff" data-title="{TITLE}" />')
    new = 0
    for e in el:
        a = {"id": _local(e["key"])}
        if e["key"] in ids:
            a["data-miro-id"] = ids[e["key"]]
        else:
            new += 1
        a.update(e["attrs"])
        if e["tag"] == "textArea":
            out.append(f"<textArea {_attr(a)}>{escape(e['body'])}</textArea>")
        else:
            out.append(f"<rect {_attr(a)} />")
    out.append("</g>")
    keys = {e["key"] for e in el}
    gone = [k for k in ids if k not in keys]
    for k in sorted(gone):  # surplus card slots from a longer column: this module's own widgets only
        if k.startswith(("card:", "box:")):
            out.append(f'<rect data-miro-id="{ids[k]}" data-deleted="true" />')
    out.append("</svg>")
    if fid and gone:
        print(f"where_we_are_svg: TRIM after the update ({len(gone)} surplus widgets marked deleted): "
              f"python ops/Tools/where_we_are_svg.py trim E:/FightCamp/tmp/wwa.svg", file=sys.stderr)
    if fid and new:
        print(f"where_we_are_svg: LEARN after the update ({new} new widgets): save result_svg to "
              f"E:/FightCamp/tmp/wwa_result.svg, then python ops/Tools/where_we_are_svg.py learn "
              f"E:/FightCamp/tmp/wwa_result.svg", file=sys.stderr)
    # ASCII only (non-ASCII as &#N; refs): Windows prints stdout in cp1252, which would break the UTF-8 SVG.
    return ("\n".join(out) + "\n").encode("ascii", "xmlcharrefreplace").decode("ascii")


def _num(v) -> float | None:
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


COLS = ("done_earlier", "done_session", "now", "next")


def _key_from_local(local: str) -> str | None:
    """'wwa_card_done_earlier_3' -> 'card:done_earlier:3', 'wwa_hdr_now' -> 'hdr_now'; None if not ours."""
    if not local.startswith("wwa_"):
        return None
    rest = local[4:]
    for kind in ("card", "box"):
        for col in COLS:
            pre = f"{kind}_{col}_"
            if rest.startswith(pre) and rest[len(pre):].isdigit():
                return f"{kind}:{col}:{rest[len(pre):]}"
    return rest if rest != "frame" else None


def _parse(svg_text: str):
    return ET.fromstring(re.sub(r'\sxmlns="[^"]+"', "", svg_text, count=1))


def learn(svg_text: str, cards: dict, ledger: dict | None = None) -> dict:
    """Add the Miro ids found in a result_svg (or a canvas_read_as_svg of the frame) to the ledger; returns it.

    Our local ids (id="wwa_...") map straight to their keys; a read's ids (id="m<miro id>") are matched by
    position and size against the layout of `cards`. Known ids that are not in the svg are kept."""
    led = ledger if ledger is not None else load_ledger()
    root = _parse(svg_text)
    frame_g = None
    for g in root.iter("g"):
        if "where we are" in (g.get("data-frame") or g.get("data-title") or "").lower() \
                or (led.get("frame") and g.get("data-miro-id") == led.get("frame")):
            frame_g = g
            break
    if frame_g is None:
        raise SystemExit("no 'P0 Where we are' frame in that svg")
    _, el = layout(cards)
    found: dict[str, str] = {}
    for child in frame_g:
        mid = child.get("data-miro-id")
        if not mid or child.get("data-deleted") == "true" or child.get("data-type") == "frame":
            continue
        key = _key_from_local(child.get("id") or "")
        if key is None:  # a read gives id="m<miro id>": match by position and size inside the frame
            x, y, w = _num(child.get("x")), _num(child.get("y")), _num(child.get("width"))
            for cand in el:
                ca = cand["attrs"]
                if cand["tag"] == child.tag and x is not None and y is not None \
                        and abs(x - ca["x"]) <= 3 and abs(y - ca["y"]) <= 3 \
                        and (w is None or abs(w - ca["width"]) <= 3) and cand["key"] not in found:
                    key = cand["key"]
                    break
        if key is not None:
            found[key] = mid
    ids = dict(led.get("ids", {}))
    ids.update(found)
    missing = [e["key"] for e in el if e["key"] not in ids]
    if missing:
        print(f"where_we_are_svg: {len(missing)} widgets still without an id: {missing[:6]}", file=sys.stderr)
    return {"board": led.get("board", BOARD), "frame": frame_g.get("data-miro-id") or led.get("frame", ""),
            "ids": ids}


def trim(pushed_svg: str, ledger: dict | None = None) -> tuple[dict, int]:
    """Forget the ids that the pushed svg marked data-deleted="true" (after that update went through)."""
    led = ledger if ledger is not None else load_ledger()
    dead = {e.get("data-miro-id") for e in _parse(pushed_svg).iter() if e.get("data-deleted") == "true"}
    keep = {k: v for k, v in led.get("ids", {}).items() if v not in dead}
    n = len(led.get("ids", {})) - len(keep)
    led["ids"] = keep
    return led, n


def _cards_from(path: str | None) -> dict:
    if path:
        return json.loads(Path(path).read_text(encoding="utf-8"))
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import where_we_are  # noqa: PLC0415
    return where_we_are.cards()


def main(argv: list[str]) -> int:
    if not argv or argv[0] in ("-h", "--help"):
        print(__doc__)
        return 0
    cmd, rest = argv[0], argv[1:]
    if cmd == "render":
        sys.stdout.write(render(_cards_from(rest[0] if rest else None)))
        return 0
    if cmd == "learn":
        if not rest:
            print("learn <svg file> [--json cards.json]")
            return 2
        js = rest[rest.index("--json") + 1] if "--json" in rest else None
        led = learn(Path(rest[0]).read_text(encoding="utf-8"), _cards_from(js))
        LEDGER.write_text(json.dumps(led, indent=1) + "\n", encoding="utf-8")
        print(f"frame {led['frame']}: {len(led['ids'])} widget ids -> {LEDGER}")
        return 0
    if cmd == "trim":  # after an update that deleted surplus slots: forget their ids
        if not rest:
            print("trim <the svg you pushed>")
            return 2
        led, n = trim(Path(rest[0]).read_text(encoding="utf-8"))
        LEDGER.write_text(json.dumps(led, indent=1) + "\n", encoding="utf-8")
        print(f"trimmed {n} ids; {len(led['ids'])} left -> {LEDGER}")
        return 0
    if cmd == "ids":
        print(json.dumps(load_ledger(), indent=1))
        return 0
    print(f"unknown command {cmd!r}")
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
