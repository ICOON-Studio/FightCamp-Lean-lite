"""topic_pages.py - one canonical page per research topic, the project's memory.

OPERATOR 2026-09-27 (S114): "do you understand the role of research ? it is not
done just for 1 session and forget everything about it" / "do the canonical pages
for all topics". 1,300 research files had no map: 39 studies on the corner, 35 on
the clinch, 33 on retargeting, and nothing said which one is the current truth.

Each page `research/topics/<id>.md` has two halves:
  - ABOVE the marker: hand-kept - SETTLED (numbers + the study that settled them),
    OPEN (what no study answers yet), ENGINE (the modules that implement it). New
    research on the topic UPDATES this half; it does not add an orphan file.
  - BELOW the marker: GENERATED here - every study on the topic, newest first.
    Derived by rule, never hand-copied, so it cannot go stale.

    python Tools/topic_pages.py            # regenerate every page + topics/README.md
    python Tools/topic_pages.py --check    # exit 1 if a page is missing or stale
    python Tools/topic_pages.py --which FILE.md   # which topics a study belongs to
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RESEARCH = ROOT / "research"
TOPICS_DIR = RESEARCH / "topics"
MARKER = "<!-- GENERATED BELOW - python Tools/topic_pages.py; edit only above this line -->"

## id: (title, regex over file name + title + opening lines). Order matters only
## for the README. A study may sit on up to three topics.
TOPICS = {
    "striking": ("Striking: punches, speed, reach, the exchange, combinations",
        r"punch|jab|hook|strike speed|striking distance|the exchange|combination|reach|pocket|compubox|strike target|the miss\b|stop.?hit"),
    "kicks_legs": ("Kicks, knees and leg strikes; leg-kick share",
        r"\bkick|leg share|leg kick|teep|knee strike|\bknees\b"),
    "defence": ("Defence: block, slip, evade, counter",
        r"defen[cs]e|evasion|slip|counter|parry|block"),
    "footwork": ("Footwork, stance, ring position, bearing, movement between exchanges",
        r"footwork|stance|southpaw|ring position|bearing|between exchanges|between punches|time.?motion|how much do fighters.*move|move around the ring|locomotion|travel|stride|step|cage size"),
    "feints": ("Feints and commitment", r"feint|commitment|commit window"),
    "clinch": ("The clinch: standing, fence, Muay Thai, clinch breaks",
        r"clinch|fence|plum|over.?under|muay thai (adapter|clinch)"),
    "takedowns_throws": ("Takedowns, throws, judo, balance break (kuzushi), grips",
        r"takedown|\bthrow|judo|ippon|waza|kuzushi|balance break|grip to throw|sprawl|shot\b|wrestl|sambo|landing seat"),
    "ground": ("The ground: seats, ground graph, guard/half/side/mount/back, turtle, traps, submissions, GnP",
        r"ground|guard|mount\b|side control|half guard|back control|turtle|front headlock|\btrap|submission|rear.?naked|armbar|choke|newaza|ne-waza|bjj|jiu.?jitsu|stand.?up|get.?up|scramble|gnp|ground and pound"),
    "knockdowns_stoppage": ("Knockdowns, the count, stoppages, the referee, finish rates, one down/one up",
        r"knockdown|the count|stoppage|referee|\btko\b|finish rate|one down|standing 8|chin|flash"),
    "scoring_results": ("Scoring, judges, decisions, 10-8s, methods of result",
        r"\bscor(ing|ecard|es?|ed)\b|judge|decision\b|10-8|method of|result that|fourth result|fifth method|medal"),
    "pace_calibration": ("Pace, output, round shape, time shares: the validation anchors",
        r"pace|output|round averages|round shape|validation corpus|anchor|time share|fight time|what the sport measures|our numbers|published units|beat stream|engine rhythm|state time"),
    "body_damage": ("Damage, body regions, cardio and fatigue, injury and recovery",
        r"damage|body by region|body map|injur|recover|cardio|heart rate|fatigue|gas tank|tired|limb|heal|physio|medical"),
    "attributes_skill": ("Attributes, stats, skill, technique catalogue and progression",
        r"attribute|stat floor|seven stats|skill|technique catalog|catalogue|move palette|vocabulary|progression|mastery|belt checklist"),
    "plans_corner": ("Fight plans, the corner, between rounds, coach calls",
        r"fight plan|plan\b|the corner|corner|between.?round|pit stop|coach lines|coach says|mic corner"),
    "rules_orgs": ("Rulesets, organizations, federations, belts, tournaments, amateurs, youth",
        r"ruleset|organi[sz]ation|federation|\bbelts?\b|tournament|grand prix|amateur|youth|regulator|sanction|selection|pathway|weigh.?in|champion|challenger|title bump|rival promotion|your own promotion"),
    "retarget_rig": ("Retargeting, rigs, skeletons, rest poses, bakes",
        r"retarget|\brig\b|skeleton|rest pose|silhouette|bake|spine split|girdle|proportion|import convention|root offset|orientation warp"),
    "clips_sources": ("Clips and where they come from: owned packs, Higgsfield, text-to-motion, Mixamo, CMU, Cascadeur, buying",
        r"clip coverage|clip count|owned inventory|every clip|higgsfield|text.?to.?motion|kimodo|mixamo|motifect|\bcmu\b|cascadeur|animation sources|hundreds of clips|asset store|shortlist|martial arts master|hand to hand set|judo pack|what to buy|sku|vendor|motion at scale|drill motion|jab types|mocap|footage|suit"),
    "playback_blend": ("Playback: beats, joins, blends, presenter, degrade/substitute",
        r"blend|joins?\b|the beat|beat adapter|presenter|presentation split|playback|degrade|substitut|crossfade|transition|clip time|stage director|slice|motion match|motion warp|stage realism|fidelity"),
    "contact_collision": ("Contact and collision: capsules, overlap, contact solver, separation, teleports, DOF",
        r"capsule|overlap|contact|collision|separation|teleport|\bdof\b|push.?apart|penetrat|head (sphere|radius|coverage)|rib cage|sternal|dome|flat cap|solver|clearance|pose solver|approach sweep|metres"),
    "paired_holds": ("Paired two-body animation: holds, grips, anchors",
        r"paired|two.?bod|two.?person|hold binding|held pose|grip|anchor|side.?control hold|closed guard|authored clinch|synchronis"),
    "hit_reactions": ("Hit reactions, ragdoll, the man who gets hit",
        r"hit reaction|reaction|ragdoll|the man who gets hit|hit response|struck|sway"),
    "camera_broadcast": ("Fight camera, broadcast layer, HUD, hype, walkout, arena, crowd",
        r"camera|broadcast|\bhud\b|hype|walkout|arena|venue|crowd|slow.?mo|hit cam|ring night|fight night|television|televised"),
    "fighter_looks": ("How fighters look: generator, Character Creator, physique, portraits, kit",
        r"character creator|fighter generator|physique|portrait|dressing|gloves|kit\b|gi and|tripo|the twelve|thirteenth fighter|regenerat|retextur|skinning|body model|cc5|likeness|stature"),
    "career_booking": ("Career, booking, rankings, matchmaking, the path",
        r"career|booking|ranking|matchmak|the path|roster|schedule|the day\b|generations|the week"),
    "money_business": ("Money: purse, contracts, manager, promoter, gate, ledgers",
        r"purse|manager contract|promoter|gate and|attendance|ledger|the books|money|wallet|federation costs|\bearns?\b|\bpay\b|the desk"),
    "gym_market": ("The gym as a business: members, market, crowding, growth",
        r"member|market|crowd(ed|ing) floor|how a gym grows|walk.?in|trial|occupancy"),
    "training_floor": ("Training: the floor, stations, drills, sparring, equipment, camps",
        r"training|drill|sparring|spar\b|equipment|station|fight camp|the camp|legwork|visiting pro|floor events"),
    "gym_rooms_art": ("The gym's rooms and art: office, lobby, locker, physio, decor, props, floor plans",
        r"room|office|lobby|locker|decor|prop|floor plan|walls|front door|gym layout|tier|wear|art direction|art pass|menu art|concept"),
    "staff_coaches": ("Staff and coaches: hiring, famous trainers, fighter-to-coach",
        r"coach|staff|trainer|hire"),
    "years_retirement": ("The years: age, decline, retirement, after the last fight",
        r"the years|\baging|\bage\b|decline|retire|last fight|long career|former read|fighter who stays|birthday"),
    "personality": ("Personality and the fighter as a person", r"personality|grudge|relationship|phone"),
    "ui_screens": ("UI, menus, screens, flow, words, tutorial, profile",
        r"menu|screen|\bui\b|uikit|flow|tutorial|handbook|words|tooltip|profile|hub|read api|type scale|icons|style guide|visual language|seat chip|rail"),
    "competitors": ("Competitor and shipped-game teardowns",
        r"competitor|survey|teardown|wmma|undisputed|punch club|cage legacy|fight business|motorsport manager|nba ?2k|absolver|shipped (fighting )?games|genre|gta"),
    "audio": ("Sound and music", r"sound|audio|music|mic\b"),
    "scouting_film": ("Scouting and the film room", r"scout|film room"),
    "tooling_process": ("Tooling, tests, agents, determinism, codebase health",
        r"suite|contract test|determinism|agent tool|sandbox|codebase|preload|bisect|which commit|red triage|dead.?factory|nothing calls|inert module|asset import|licen[cs]e|provenance|frame pacing|replay"),
}
MAX_TOPICS_PER_STUDY = 3
EXCLUDE = re.compile(r"^(TASK_|_TASK|CLAUDE_LAND_NOTE|S\d+(_S\d+)?_DIGEST)")


def _head(path: Path, lines: int = 25) -> str:
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return ""
    return "\n".join(text.splitlines()[:lines])


def _title(path: Path) -> str:
    for line in _head(path, 12).splitlines():
        if line.startswith("#"):
            return re.sub(r"\s+", " ", line.strip("# ").strip())
    return ""


def classify(path: Path) -> list:
    name = path.stem.replace("_", " ")
    title = _title(path)
    head = _head(path)
    scores = []
    loose = []
    body = _head(path, 60)
    for tid, (_, pattern) in TOPICS.items():
        rx = re.compile(pattern, re.I)
        s = 3 * len(rx.findall(name + " " + title)) + min(3, len(rx.findall(head)) // 2)
        if s >= 3:
            scores.append((s, tid))
        loose.append((len(rx.findall(body)), tid))
    scores.sort(key=lambda x: (-x[0], x[1]))
    if scores:
        return [tid for _, tid in scores[:MAX_TOPICS_PER_STUDY]]
    ## A generically titled study ("C154 digest", "DECISIONS") gets its ONE best
    ## topic from its opening 60 lines, if anything there matches at least twice.
    loose.sort(key=lambda x: (-x[0], x[1]))
    return [loose[0][1]] if loose and loose[0][0] >= 2 else []


def _dates() -> dict:
    """Last commit date per research file, one git call."""
    out = {}
    try:
        log = subprocess.run(["git", "log", "--name-only", "--format=@%cs", "--", "research"],
                             cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace").stdout
    except OSError:
        return out
    day = ""
    for line in log.splitlines():
        if line.startswith("@"):
            day = line[1:]
        elif line.startswith("research/") and line.count("/") == 2:
            out.setdefault(Path(line).name, day)
    return out


def studies_by_topic() -> dict:
    by = {tid: [] for tid in TOPICS}
    for path in sorted(RESEARCH.glob("*.md")):
        if EXCLUDE.match(path.name):
            continue
        for tid in classify(path):
            by[tid].append(path)
    return by


def _page_head(tid: str) -> str:
    title = TOPICS[tid][0]
    return (f"# {title}\n\n"
            "**Canonical page.** Read this before assigning or building anything on this topic. New findings\n"
            "UPDATE the sections below (with the study that settled them); they do not become an orphan file.\n\n"
            "## Settled\n\n_(not yet written - see the studies below)_\n\n"
            "## Open\n\n_(not yet written)_\n\n"
            "## Engine\n\n_(not yet written)_\n\n")


def render(tid: str, studies: list, dates: dict) -> str:
    rows = sorted(studies, key=lambda p: (dates.get(p.name, "0000"), p.name), reverse=True)
    lines = [MARKER, "", f"## Studies on this topic ({len(rows)}, newest first, generated)", ""]
    for p in rows:
        lines.append(f"- `{p.name}` ({dates.get(p.name, 'untracked')}) - {_title(p)[:110]}")
    return "\n".join(lines) + "\n"


def build(check: bool = False) -> int:
    TOPICS_DIR.mkdir(exist_ok=True)
    dates = _dates()
    by = studies_by_topic()
    stale = []
    index = ["# Research topics - the canonical pages", "",
             "GENERATED by `python Tools/topic_pages.py`. One page per topic: SETTLED, OPEN, ENGINE (hand-kept),",
             "then every study on it (generated). `python Tools/prior_research.py <terms>` prints the matching page first.", "",
             "| Topic | Studies | Page |", "|---|---|---|"]
    for tid, (title, _) in TOPICS.items():
        page = TOPICS_DIR / f"{tid}.md"
        head = page.read_text(encoding="utf-8").split(MARKER)[0] if page.exists() else _page_head(tid)
        text = head.rstrip() + "\n\n" + render(tid, by[tid], dates)
        if not page.exists() or page.read_text(encoding="utf-8") != text:
            stale.append(page.name)
            if not check:
                page.write_text(text, encoding="utf-8", newline="\n")
        written = "Settled\n\n_(not yet written" not in head
        index.append(f"| {title} | {len(by[tid])} | [`topics/{tid}.md`]({tid}.md){'' if written else ' (settled: TODO)'} |")
    unplaced = [p.name for p in RESEARCH.glob("*.md") if not EXCLUDE.match(p.name) and not classify(p)]
    index += ["", f"Studies on no topic ({len(unplaced)}): " + ", ".join(f"`{n}`" for n in sorted(unplaced))]
    readme = TOPICS_DIR / "README.md"
    rtext = "\n".join(index) + "\n"
    if not readme.exists() or readme.read_text(encoding="utf-8") != rtext:
        stale.append("README.md")
        if not check:
            readme.write_text(rtext, encoding="utf-8", newline="\n")
    if check:
        if stale:
            print("topic pages stale: " + ", ".join(stale) + " - run python Tools/topic_pages.py")
            return 1
        return 0
    print(f"{len(TOPICS)} topic pages written ({len(stale)} changed); {len(unplaced)} studies on no topic")
    return 0


def main(argv):
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass
    if "--which" in argv:
        p = RESEARCH / argv[argv.index("--which") + 1]
        print(p.name, "->", ", ".join(classify(p)) or "(no topic)")
        return 0
    return build(check="--check" in argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
