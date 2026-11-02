"""prior_research.py - what does the project already know about a topic?

OPERATOR RULE 2026-09-27 (S114): "i am sure this research has been done at least
3 times already" / "this is violation of the rules". G145 (takedown skill gaps)
was assigned to Grok without a search; J20, J33, G141, G143 and G138 already
held the takedown numbers. The rule to check the record first was prose; this is
the tool, and `agent_comms.py start` now refuses a brief without a
'## Prior research' section that names real files or the search it ran.

    python Tools/prior_research.py takedown "td def" sprawl

Every term is searched (case-insensitive) in every research/*.md that is
not a TASK file. Files are ranked by how many DIFFERENT terms they contain, then
by total hits; the first heading and the best matching lines are printed.
Paste the file names you read into the brief's '## Prior research' section, or
'searched: <terms>' when nothing bears on it.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESEARCH = ROOT / "research"


def search(terms, limit=15):
    pats = [re.compile(re.escape(t), re.I) for t in terms]
    rows = []
    for path in RESEARCH.glob("*.md"):
        if path.name.startswith("TASK_"):
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        counts = [len(p.findall(text)) for p in pats]
        distinct = sum(1 for c in counts if c)
        if not distinct:
            continue
        title = next((l.strip("# ").strip() for l in text.splitlines() if l.startswith("#")), "")
        lines = [l.strip() for l in text.splitlines() if any(p.search(l) for p in pats)]
        rows.append((distinct, sum(counts), path.name, title, lines))
    rows.sort(key=lambda r: (-r[0], -r[1], r[2]))
    return rows[:limit]


def main(argv):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    terms = [a for a in argv if a.strip()]
    if not terms:
        print(__doc__)
        return 2
    ## The canonical topic pages come FIRST: they say what is settled and what is open.
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import topic_pages
    pages = []
    for tid, (title, pattern) in topic_pages.TOPICS.items():
        rx = re.compile(pattern, re.I)
        hits = sum(1 for t in terms if rx.search(t) or re.search(re.escape(t), title, re.I))
        if hits:
            pages.append((hits, tid, title))
    pages.sort(key=lambda r: -r[0])
    if pages:
        print("CANONICAL PAGES - read these first (Settled / Open / Engine):")
        for hits, tid, title in pages[:4]:
            print("  research/topics/%s.md  - %s" % (tid, title))
        print()
    rows = search(terms)
    print("PRIOR RESEARCH for: %s   (%d file(s) shown, ranked by distinct terms)" % (", ".join(terms), len(rows)))
    for distinct, total, name, title, lines in rows:
        print("\n%s  [%d/%d terms, %d hits]  %s" % (name, distinct, len(terms), total, title[:90]))
        for line in lines[:3]:
            print("    " + line[:180])
    if not rows:
        print("\nNothing found. Put 'searched: %s' in the brief's '## Prior research'." % " ".join(terms))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
