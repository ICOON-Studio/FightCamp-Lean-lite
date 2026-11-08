"""Checks the S403 menu mockups for the faults critics keep finding (round 4): pages that disagree, old attribute names, invented icons or facts.
Usage: python tools/check_mockups.py [page ...]   Exit 1 on any fault. Reads files only; a fact typed by hand on a page is a fault, it must come from facts.json."""
import json
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import build_mockup_facts as B  # noqa: E402

HERE = B.HERE
PAGES = ["home", "fighter_week", "profile", "playbook", "fight_night", "money", "world", "fighter_week_aisha", "profile_aisha", "profile_kwame", "playbook_ground", "playbook_combos"]
NO_RAIL = {"fight_night"}
# Facts that appear on more than one page. Typed by hand in visible text or a tooltip = fault.
HAND = ["$14,820", "$1,720", "$1,417", "$5,668", "+$303", "60.2", "59.6", "56.7", "65.4", "69.2", "86.5", "111.0", "Priya Nair", "Dana Whitfield", "Rosa Lindqvist", "Lucy Jackson", "Mon 16 Mar", "Sat 21 Mar", "Sat 11 Apr", "Thu 5 Mar", "Mon 9 Mar", "Mon 30 Mar", "Fri 6 Mar", "Mon 23 Mar", "68/70"]
# Words that must be gone.
BANNED = [(r"Hand speed|Foot speed", "attributes are one Speed since S404"), (r"Head movement|Blocking|Kick defence|Scrambl|Passing\b", "not one of the 12 skills"),
          (r"60\.4", "Lucy weighs 60.2"), (r"stop the clock", "the top bar and pins say when time stops, not a count"), (r"\bNEW\b", "a feature flag the player never sees"),
          (r"Not one of the two instructions|Nothing is pre-?selected", "a design note shown as screen text"), (r"eleven|11 attributes", "there are 10 attributes"),
          (r"Dues from 31 members", "break-even goes in a tooltip"), (r"[Ll]eaves \d+ weeks?", "use the runway icon and a number")]


def visible(html: str) -> str:
    html = re.sub(r"<style.*?</style>", "", html, flags=re.S)
    html = re.sub(r"<script.*?</script>", "", html, flags=re.S)
    return html


def lookup(facts: dict, path: str) -> bool:
    o = facts
    for k in path.split("."):
        if not isinstance(o, dict) or k not in o:
            return False
        o = o[k]
    return True


def icons() -> set:
    src = (HERE / "kit.js").read_text(encoding="utf-8")
    block = src[src.index("const I = {"):src.index("function get(path)")]
    return set(re.findall(r"^\s+'?([A-Za-z_ ]+?)'?: \[", block, flags=re.M))


def check(page: str, facts: dict, ic: set) -> list:
    path = HERE / f"{page}.html"
    if not path.exists():
        return [f"{page}: file missing"]
    raw = path.read_text(encoding="utf-8")
    v = visible(raw)
    out = []
    if 'src="kit.js"' not in raw or 'src="facts.js"' not in raw:
        out.append("does not load facts.js and kit.js")
    if page not in NO_RAIL:
        if 'data-kit="top"' not in v:
            out.append("has no shared top bar")
        if 'data-kit="rail"' not in v:
            out.append("has no shared rail")
    loose = len(re.findall(r"<svg(?![^>]*data-art)", v))
    if loose:
        out.append(f"{loose} hand-drawn icons: use data-ic (a chart or body drawing carries data-art)")
    for m in sorted(set(re.findall(r'data-f="([^"]+)"', v))):
        if not lookup(facts, m):
            out.append(f"no such fact: {m}")
    for m in sorted(set(k for t in re.findall(r'data-(?:t|tip)="([^"]+)"', v) for k in re.findall(r"\{([^}]+)\}", t))):
        if not lookup(facts, m):
            out.append(f"no such fact: {m}")
    for m in sorted(set(re.findall(r'data-ic="([^"]+)"', v))):
        if m not in ic:
            out.append(f"no such icon: {m}")
    for h in HAND:
        n = v.count(h)
        if n:
            out.append(f'typed by hand {n}x: "{h}"')
    for pat, why in BANNED:
        hits = re.findall(pat, v)
        if hits:
            out.append(f'banned "{hits[0]}" x{len(hits)}: {why}')
    return [f"{page}: {x}" for x in out]


def main() -> int:
    facts = B.build()
    (HERE / "facts.js").write_text("window.FACTS=" + json.dumps(facts, ensure_ascii=False, indent=0) + ";\n", encoding="utf-8")
    ic = icons()
    faults = []
    pages = sys.argv[1:] or PAGES
    for p in pages:
        faults += check(p, facts, ic)
    print("\n".join(faults) if faults else f"MOCKUPS OK: {len(pages)} pages, {len(ic)} icons")
    return 1 if faults else 0


if __name__ == "__main__":
    raise SystemExit(main())
