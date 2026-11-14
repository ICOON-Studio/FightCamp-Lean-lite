"""design_loop.py - S459 (operator: "use all free agents on loop until all mechanics have been designed . critics need to
rate them at least 6 at depth and 6 at general design etc"). Builds the briefs the chat seats get and queues them.

  python ops/Tools/design_loop.py critic  <ID> <map.md> --seat john|kalli|maria|dola
      a fresh critic scores DEPTH, GENERAL DESIGN and PLAY out of 10 (the bar: 6+ depth AND 6+ general design), with the
      'To reach 10/10' list (operator S405) and a 1920x1080 HTML of its 10/10 (S411).
  python ops/Tools/design_loop.py revise  <ID> <map.md> --seat ... --critics <critic.md> [<critic.md> ...] --out <next_map.md>
      a designer seat writes the next version of the map answering every point of the critics' lists.
Each brief = the task + CRITIC_ACCESS pointer + CRITIC_PACK (the whole game, facts only) + the map (+ the critics' files).
The brief is written to ops/research/DESIGN_<ID>_<kind>_<seat>.md and queued with seat_queue.py add.
Tracker: ops/research/DESIGN_LOOP_S459.md (one row per mechanic; update it by hand when an answer lands).
"""
import argparse
import re
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RES = os.path.join(ROOT, "ops", "research")

CRITIC_TASK = """# {id} - score this mechanic's DESIGN (S459 design loop)

You are a fresh critic. Read the whole game first (the critic pack below: facts only, no earlier scores), then the design map
at the end. Judge the MECHANIC, not the look of any screen.

Score, each out of 10, with the reasons:
1. DEPTH - real choices with trade-offs that change outcomes; no dominant pick; it interacts with the rest of the game.
2. GENERAL DESIGN - clear, consistent with the game's rules and words, buildable from what the game has, nothing useless.
3. PLAY - fun week to week: anticipation, a reason to come back, a reward the player feels.
The bar (owner S459): the mechanic is DESIGNED when critics give it 6+ on DEPTH and 6+ on GENERAL DESIGN.

Also answer: which options are missing, which are useless, and what each option changes (owner S403).
End with **To reach 10/10**: the concrete changes that would take it to 10, most important first, each specific enough to
build (owner S405). Then describe your 10/10 as a 1920x1080 page (an HTML file is welcome) (owner S411).
Plain words; names only in headers (the body says "your boxer", "the opponent"). Real-world boxing evidence where it helps.
"""

REVISE_TASK = """# {id} - write the NEXT version of this mechanic's design map (S459 design loop)

You are the designer. Read the whole game (critic pack below), the current map, and the critics' answers at the end. Write
the next version of the map in full (not a diff): answer EVERY point of each critic's 'To reach 10/10' list (do it, or say
in one line why not), keep every rule the owner agreed (quoted in the map), keep it buildable from what the game has, and
keep the map's table of every menu the mechanic appears on and what each is wired to (owner S425).
The bar it must reach with fresh critics: 6+ DEPTH and 6+ GENERAL DESIGN (owner S459). Numbers: say which are ESTIMATES.
Plain words; names only in headers. Return only the new map, starting with its title line.
"""


def _read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


def _letters(s):
    idx = [i for i, c in enumerate(s) if c.isalnum()]
    return "".join(s[i].lower() for i in idx), idx


def reply_only(text):
    """S470: Dola's saved answer is her WHOLE chat (the brief again, then her reply): a revise brief that embedded it
    carried the 90k brief twice and passed the Grok bots' message limit (SQ115: 218k characters, 'text exceeds the
    maximum length'). Keep the header and what follows the brief's last words (matched on letters only: the chat page
    drops the markdown)."""
    m = re.search(r"^Brief: (\S+)", text, re.M)
    if "whole fresh chat" not in text or not m:
        return text
    brief = os.path.join(os.path.dirname(RES), m.group(1)) if not os.path.isabs(m.group(1)) else m.group(1)
    if not os.path.isfile(brief):
        brief = os.path.join(RES, os.path.basename(m.group(1)))
    if not os.path.isfile(brief):
        return text
    nb, _ = _letters(_read(brief))
    nt, it = _letters(text)
    for n in (60, 40, 25):
        k = nt.rfind(nb[-n:])
        if k >= 0:
            head = text[:text.find("---")] if "---" in text[:800] else ""
            return head + "(the brief is cut; her reply:)\n" + text[it[k + n - 1] + 1:]
    return text


def build(kind, mid, map_path, critics, seat):
    task = (CRITIC_TASK if kind == "critic" else REVISE_TASK).format(id=mid)
    parts = [task, "\n> Also read `ops/research/CRITIC_ACCESS.md`: the Miro board, the real screens, the mockups.\n",
             "\n\n" + _read(os.path.join(RES, "CRITIC_PACK.md")),
             "\n\n# THE DESIGN MAP TO JUDGE\n\n" + _read(map_path)]
    for c in critics:
        parts.append("\n\n# CRITIC ANSWER: %s\n\n" % os.path.basename(c) + reply_only(_read(c)))
    out = os.path.join(RES, "DESIGN_%s_%s_%s.md" % (mid, kind.upper(), seat.upper()))
    with open(out, "w", encoding="utf-8") as f:
        f.write("".join(parts))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("kind", choices=["critic", "revise"])
    ap.add_argument("id")
    ap.add_argument("map")
    ap.add_argument("--seat", required=True, choices=["john", "kalli", "maria", "dola"])
    ap.add_argument("--critics", nargs="*", default=[])
    ap.add_argument("--no-queue", action="store_true")
    a = ap.parse_args()
    brief = build(a.kind, a.id, os.path.abspath(a.map), [os.path.abspath(c) for c in a.critics], a.seat)
    print("BRIEF", os.path.relpath(brief, ROOT), os.path.getsize(brief), "bytes")
    if not a.no_queue:
        rel = os.path.relpath(brief, os.path.join(ROOT, "ops"))
        r = subprocess.run([sys.executable, os.path.join(ROOT, "ops", "Tools", "seat_queue.py"), "add", "--seat", a.seat,
                            "--brief", rel], cwd=os.path.join(ROOT, "ops"), capture_output=True, text=True, encoding="utf-8")
        print((r.stdout or r.stderr).strip())


if __name__ == "__main__":
    main()
