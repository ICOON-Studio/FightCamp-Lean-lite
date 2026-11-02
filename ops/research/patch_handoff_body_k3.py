from pathlib import Path
import re, sys

path = Path(r"C:\Users\user\OneDrive\Documents\ChatGPT\Game\HANDOFF.md")
raw = path.read_bytes()
has_bom = raw.startswith(b"\xef\xbb\xbf")
text = raw.decode("utf-8-sig")
nl = "\r\n" if "\r\n" in text else "\n"

new_k3 = nl.join([
"### KALLI \u2014 K3: BODY / PROFILE TAB STUDIES (IN PROGRESS 2026-09-04)",
"",
"Operator: polish Body (no dots, leader lines, tooltips, enlarge map, less boxes / more graphs), update HANDOFF so Claude can see it, try again.",
"",
"- **Local review (operator + Claude):** profile research lives under `research/` going forward (not MagicPath links for operator review):",
"  - `research/PROFILE_BODY_MAP_2026-09-04.html`",
"  - `research/fighter-muscle-map-front.png`",
"- Body readiness (graphic-first pass):",
"  - Map / Weight / Medical subtabs",
"  - Full-bleed photoreal muscle map (`fighter-muscle-map-front`); **no circular hotspots**",
"  - SVG **leader lines** from gutter labels to anatomy anchors",
"  - **Tooltips** on invisible body hit-regions (hover/focus) \u2014 right-side Region Focus / Hotspots panel **removed**",
"  - Readiness ring + radar / sparklines / gauges instead of Power/Speed text cells",
"- Sibling tab studies (Athlete Lab, Fight Camp, Skills & Moves) remain exploratory; not ship-shell yet",
"- Research truth for full AAA shell remains `research/PROFILE_MERGED_2026-09-04.html` (K1) + K2 assets under `Godot/assets/ui/`",
"- No `.gd` touched. Local HTML under `research/` is the review surface; Claude owns kit/shell merge when operator greenlights.",
"- Operator ruling this pass: less text and squares, more graphics; leaders + tooltips over description boxes.",
"",
])

new_dir = (
"- **2026-09-04, Kalli (Body readiness pass \u2014 operator feedback):** Body readiness tab study \u2014 "
"full-bleed photoreal muscle map, SVG leader lines to regions, tooltips on body hit-regions "
"(no right description column, no circular hotspot dots). Prefer graphs (readiness ring, radar, sparklines, gauges) "
"over Power/Speed text cells and box stacks. **Local files for Claude/operator review:** "
"`research/PROFILE_BODY_MAP_2026-09-04.html` + `research/fighter-muscle-map-front.png` "
"(profile research under `research/` going forward; do not rely on MagicPath URLs for operator review). "
"Full AAA shell still K1 `PROFILE_MERGED_2026-09-04.html` + K2 `Godot/assets/ui/`. "
"Claude: review art direction from the local Body HTML; do not treat exploratory frames as the ship shell yet."
+ nl
)

k3_re = re.compile(r"### KALLI \u2014 K3:.*?(?=\n### GROK|\r\n### GROK)", re.S)
if not k3_re.search(text):
    print("ERROR: K3 not found", file=sys.stderr); sys.exit(1)
text = k3_re.sub(new_k3, text, count=1)

dir_re = re.compile(
    r"- \*\*2026-09-04, Kalli \((?:MagicPath )?Body(?: readiness)? pass[^\n]*\n",
    re.S,
)
if not dir_re.search(text):
    print("ERROR: Direction note not found", file=sys.stderr); sys.exit(2)
text = dir_re.sub(new_dir, text, count=1)

# scrub accidental form-feeds from prior bad write
text = text.replace("\x0c", "f")

out = text.encode("utf-8")
if has_bom:
    out = b"\xef\xbb\xbf" + out
path.write_bytes(out)

v = path.read_text(encoding="utf-8-sig")
assert "\x0c" not in v
assert "research/PROFILE_BODY_MAP_2026-09-04.html" in v
assert "research/fighter-muscle-map-front.png" in v
assert "magicpath.ai" not in v.lower()
assert "MAGICPATH BODY" not in v
assert "MagicPath Body pass" not in v
print("OK")
print("PROFILE_BODY_MAP", v.count("PROFILE_BODY_MAP_2026-09-04.html"))
print("PNG explicit", v.count("research/fighter-muscle-map-front.png"))
print("magicpath.ai", v.lower().count("magicpath.ai"))
i = v.find("K3:")
print("---K3---")
print(v[v.rfind("###", 0, i): v.find("### GROK", i)][:900])
print("---DIR---")
d = v.find("## Direction notes")
print(v[d: v.find("\n- **2026-09-04, Claude", d)][:900])
