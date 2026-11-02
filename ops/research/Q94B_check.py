"""Q94B gate (written by Claude before launch). Run from the repo root: python research/Q94B_check.py

Q94 counted EVERY action as a strike thrown: 2,655 of the out-boxer's 6,619 "strikes" were circling, stepping and
reading the range. Its cadence drivers also cited a knockdown constant as the strike range and a rate (3.5 throws/s)
that no measured figure supports. Q94B re-measures the same fixture with the meanings pinned. Nothing here trusts
Qwen's classification:
- whether a technique DELIVERS A BLOW is read from U79's census here (U79_admitted_strikes.json, adjudicated per node
  from Q77), and its kind from the CATALOGUE; the strike/setup/sequence totals are recomputed from them. The catalogue's
  match.role is NOT the test: boxing_jab's role is "setup", and a jab is a punch;
- the landed contacts are read from FightStoppageRead.gd's LANDED_CONTACTS here, not typed;
- the impact cadence and tick rate are read from TickBudget.gd and FightRealtime.gd here, and the model's arithmetic
  recomputed;
- every number a cadence driver's sentence cites must come from its own quote, the model, or the measured figures;
- the engine has not changed since Q94 (eb01840), so the action totals must equal Q94's EXACTLY (6619 / 8705).
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
JSON_PATH = GODOT / "research" / "Q94_engine_pace.json"
MD_PATH = GODOT / "research" / "Q94_ENGINE_PACE.md"
TOOL = GODOT / "tools" / "measure_engine_pace.gd"
CATALOGUE = GODOT / "assets" / "data" / "technique_catalog.json"
REALTIME = GODOT / "scripts" / "FightRealtime.gd"
TICKBUDGET = GODOT / "scripts" / "TickBudget.gd"
STOPPAGE = GODOT / "scripts" / "FightStoppageRead.gd"
CENSUS = GODOT / "research" / "U79_admitted_strikes.json"

## THE DEFINITION (Claude, in the task): an action is a STRIKE when U79's census says its technique delivers_blow.
Q94_ACTIONS = {"a": 6619, "b": 8705}

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def near(a, b, rel=0.005, absolute=1e-6):
    return abs(float(a) - float(b)) <= max(absolute, rel * max(abs(float(a)), abs(float(b))))


def catalogue_nodes():
    data = json.loads(CATALOGUE.read_text(encoding="utf-8"))
    nodes = {}
    for disc in data.get("disciplines", []):
        for node in disc.get("nodes", []):
            nid = str(node.get("id", ""))
            if nid and nid not in nodes:
                nodes[nid] = node
    return nodes


def blow_census():
    rows = json.loads(CENSUS.read_text(encoding="utf-8")).get("rows", [])
    return {str(r.get("id", "")): bool(r.get("delivers_blow", False)) for r in rows if r.get("id")}


def landed_contacts():
    text = STOPPAGE.read_text(encoding="utf-8")
    m = re.search(r"const\s+LANDED_CONTACTS\s*:=\s*\[([^\]]*)\]", text)
    if not m:
        fail("FightStoppageRead.gd no longer declares LANDED_CONTACTS - the check cannot derive 'landed'")
        return []
    return re.findall(r'"([^"]+)"', m.group(1))


def source_model():
    tb = TICKBUDGET.read_text(encoding="utf-8")
    m = re.search(r'const\s+CADENCE\s*:=\s*\{[^}]*"impact"\s*:\s*(\d+)', tb)
    rt = REALTIME.read_text(encoding="utf-8")
    h = re.search(r"const\s+DEFAULT_HZ\s*:=\s*(\d+)", rt)
    if not m or not h:
        fail("cannot read the impact cadence from TickBudget.gd or DEFAULT_HZ from FightRealtime.gd")
        return None
    return int(m.group(1)), int(h.group(1))


def check_intervals(label, iv, cap_n):
    try:
        p10, p50, p90, mean = (float(iv[k]) for k in ("p10", "p50", "p90", "mean"))
        n = int(iv["n"])
        s35, s45 = float(iv["share_below_0_35"]), float(iv["share_below_0_45"])
    except (KeyError, TypeError, ValueError):
        fail("%s lacks p10/p50/p90/mean/n/share_below_0_35/share_below_0_45" % label)
        return
    if not (0.0 < p10 <= p50 <= p90) or mean <= 0.0:
        fail("%s is not ordered and positive: %s" % (label, iv))
    if not (0.0 <= s35 <= s45 <= 1.0):
        fail("%s shares are not 0 <= below 0.35 <= below 0.45 <= 1: %s" % (label, iv))
    if not 0 < n <= cap_n:
        fail("%s.n %d is not in (0, %d]" % (label, n, cap_n))
    if p50 < 0.35 and s35 < 0.49:
        fail("%s: p50 %.3f s is below 0.35 s but share_below_0_35 is %.3f (must be at least 0.5)" % (label, p50, s35))
    if p50 >= 0.45 and s45 > 0.51:
        fail("%s: p50 %.3f s is at or above 0.45 s but share_below_0_45 is %.3f (must be at most 0.5)" % (label, p50, s45))


def check_fighter(name, side, round_minutes, nodes, landed, census):
    keys = ["actions", "actions_per_min", "by_kind", "by_role", "strikes_thrown", "strikes_thrown_per_min",
            "strikes_by_contact", "strikes_landed", "strikes_landed_per_min", "setups", "setups_landed",
            "sequence_actions", "punches_per_min_lower_bound", "intervals_s", "strike_intervals_s"]
    for key in keys:
        if key not in side:
            fail("pooled.%s lacks %s" % (name, key))
            return
    actions = int(side["actions"])
    if actions != Q94_ACTIONS[name]:
        fail("pooled.%s.actions %d != Q94's %d on an unchanged engine - STOP and report, do not adjust"
             % (name, actions, Q94_ACTIONS[name]))
    by_kind = side["by_kind"]
    if sum(int(v) for v in by_kind.values()) != actions:
        fail("pooled.%s.by_kind does not sum to actions" % name)
    strikes = setups = sequences = 0
    for tech, count in by_kind.items():
        node = nodes.get(str(tech))
        if node is None:
            fail("pooled.%s.by_kind key %r is not a catalogue technique id" % (name, tech))
            continue
        if str(tech) not in census:
            fail("pooled.%s: %r is not in U79's census - STOP and report it, do not classify it yourself" % (name, tech))
            continue
        if census[str(tech)]:
            strikes += int(count)
            if str(node.get("kind", "")) == "sequence":
                sequences += int(count)
        else:
            setups += int(count)
    if int(side["strikes_thrown"]) != strikes:
        fail("pooled.%s.strikes_thrown %d != %d, the actions whose technique U79 says delivers a blow"
             % (name, int(side["strikes_thrown"]), strikes))
    if int(side["setups"]) != setups:
        fail("pooled.%s.setups %d != %d, the actions whose technique U79 says delivers no blow"
             % (name, int(side["setups"]), setups))
    if int(side["sequence_actions"]) != sequences:
        fail("pooled.%s.sequence_actions %d != %d, the strikes whose catalogue kind is sequence"
             % (name, int(side["sequence_actions"]), sequences))
    by_role = side["by_role"]
    if sum(int(v) for v in by_role.values()) != actions:
        fail("pooled.%s.by_role (the EVENT's own role field) does not sum to actions" % name)
    by_contact = side["strikes_by_contact"]
    if sum(int(v) for v in by_contact.values()) != strikes:
        fail("pooled.%s.strikes_by_contact does not sum to strikes_thrown" % name)
    landed_n = sum(int(by_contact.get(c, 0)) for c in landed)
    if int(side["strikes_landed"]) != landed_n:
        fail("pooled.%s.strikes_landed %d != %d, the strikes whose contact is in LANDED_CONTACTS %s"
             % (name, int(side["strikes_landed"]), landed_n, landed))
    if not 0 <= int(side["setups_landed"]) <= setups:
        fail("pooled.%s.setups_landed is not in [0, setups]" % name)
    if round_minutes > 0:
        for key, count in (("actions_per_min", actions), ("strikes_thrown_per_min", strikes),
                           ("strikes_landed_per_min", landed_n),
                           ("punches_per_min_lower_bound", strikes + sequences)):
            if not near(side[key], count / round_minutes):
                fail("pooled.%s.%s %.3f != %d / round_minutes" % (name, key, float(side[key]), count))
    check_intervals("pooled.%s.strike_intervals_s" % name, side["strike_intervals_s"], strikes)
    return strikes


def numbers_in(text):
    return re.findall(r"(?<![\w.])\d+(?:\.\d+)?", text)


def check_cadence(cadence, pooled, model_src):
    rows = cadence.get("rows", []) if isinstance(cadence, dict) else []
    if len(rows) < 3:
        fail("cadence.rows has %d rows; at least 3 expected" % len(rows))
    for i, row in enumerate(rows):
        if "%%" in str(row.get("what", "")):
            fail("cadence row %d carries a GDScript format escape '%%%%' in plain text" % i)
        missing = [k for k in ("file", "line", "quote", "const", "value", "what") if k not in row]
        if missing:
            fail("cadence row %d lacks %s" % (i, missing))
            continue
        path = ROOT / str(row["file"])
        if not path.is_file():
            fail("cadence row %d: no file %s" % (i, row["file"]))
            continue
        lines = path.read_text(encoding="utf-8").splitlines()
        line_no = int(row["line"])
        quote = str(row["quote"]).strip()
        if not quote or not 1 <= line_no <= len(lines) or quote not in lines[line_no - 1]:
            fail("cadence row %d: quote %r is not ON %s:%d (Q94's was 3 lines away and described another constant)"
                 % (i, quote, row["file"], line_no))
        const = str(row["const"]).strip()
        if const:
            if const not in quote:
                fail("cadence row %d: const %s is not in its own quote %r" % (i, const, quote))
            decl = [l for l in lines if re.match(r"\s*(static\s+)?(const|var)\s+%s\b" % re.escape(const), l)]
            if not decl:
                fail("cadence row %d: %s is not declared in %s" % (i, const, row["file"]))
            elif str(row["value"]).strip() and str(row["value"]).strip() not in decl[0]:
                fail("cadence row %d: %s is declared as %r, not %r" % (i, const, decl[0].strip(), row["value"]))
    model = cadence.get("model", {}) if isinstance(cadence, dict) else {}
    allowed = set()
    if model_src is not None:
        ticks, hz = model_src
        try:
            if int(model["impact_cadence_ticks"]) != ticks or int(model["hz"]) != hz:
                fail("cadence.model impact_cadence_ticks/hz %s/%s != the source's %d/%d"
                     % (model.get("impact_cadence_ticks"), model.get("hz"), ticks, hz))
            period = ticks / float(hz)
            if not near(model["impact_period_s"], period):
                fail("cadence.model.impact_period_s %s != %d / %d" % (model["impact_period_s"], ticks, hz))
            checks = 60.0 / period
            if not near(model["impact_checks_per_min"], checks):
                fail("cadence.model.impact_checks_per_min %s != 60 / %.3f" % (model["impact_checks_per_min"], period))
            for s in ("a", "b"):
                spm = float(pooled[s]["strikes_thrown_per_min"])
                if not near(model["strike_actions_per_min"][s], spm):
                    fail("cadence.model.strike_actions_per_min.%s != pooled.%s.strikes_thrown_per_min" % (s, s))
                if not near(model["share_of_checks_that_throw"][s], spm / checks):
                    fail("cadence.model.share_of_checks_that_throw.%s != strikes a minute / checks a minute" % s)
            for v in (ticks, hz, period, checks):
                allowed.add(v)
            for s in ("a", "b"):
                allowed.add(float(model["strike_actions_per_min"][s]))
                allowed.add(float(model["share_of_checks_that_throw"][s]))
        except (KeyError, TypeError, ValueError) as exc:
            fail("cadence.model is incomplete: %r" % exc)
    for s in ("a", "b", "pair"):
        for k, v in pooled.get(s, {}).items():
            if isinstance(v, (int, float)):
                allowed.add(float(v))
            elif isinstance(v, dict) and k.endswith("intervals_s"):
                allowed.update(float(x) for x in v.values() if isinstance(x, (int, float)))
    drivers = cadence.get("drivers", []) if isinstance(cadence, dict) else []
    if not 1 <= len(drivers) <= 3:
        fail("cadence.drivers has %d entries; 1 to 3 expected" % len(drivers))
    for d in drivers:
        if not isinstance(d, dict) or not 0 <= int(d.get("row", -1)) < len(rows) or not str(d.get("why", "")).strip():
            fail("cadence driver %r does not name a row and a reason" % d)
            continue
        row = rows[int(d["row"])]
        own = str(row.get("quote", "")) + " " + str(row.get("value", ""))
        why = str(d["why"])
        if "%%" in why:
            fail("cadence driver on row %d carries a GDScript format escape '%%%%' in plain text: %r" % (int(d["row"]), why))
        for match in re.finditer(r"(?<![\w.])(\d+(?:\.\d+)?)(\s*%)?", why):
            num = match.group(1)
            is_share = match.group(2) is not None
            value = float(num)
            if value <= 10 and value == int(value) and not is_share:
                continue
            if num in own:
                continue
            decimals = len(num.split(".")[1]) if "." in num else 0
            if is_share and any(round(a * 100.0, max(0, decimals)) == value for a in allowed):
                continue
            if not is_share and any(round(a, decimals) == value for a in allowed):
                continue
            fail("cadence driver on row %d cites %s, which is not in its quote, the model or any measured figure: %r"
                 % (int(d["row"]), num, d["why"]))


def main():
    for p in (JSON_PATH, MD_PATH, TOOL, CATALOGUE, REALTIME, TICKBUDGET, STOPPAGE, CENSUS):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for banned in ("Q88_engine_rhythm", "Q88_ENGINE_RHYTHM", "Q94_check", "Q94B_check"):
        if banned in tool:
            fail("the tool names %s - it must measure, not read" % banned)
    for needed in ("run_to_completion", "demo_fighter", "Q94_engine_pace.json", "U79_admitted_strikes.json"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)
    nodes = catalogue_nodes()
    landed = landed_contacts()
    census = blow_census()

    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    if pop.get("ruleset") != "boxing":
        fail("population.ruleset is %r" % pop.get("ruleset"))
    if sorted(int(s) for s in pop.get("seeds", [])) != list(range(900, 930)):
        fail("population.seeds are not the 30 seeds 900..929")
    fighters = pop.get("fighters", [])
    styles = [str(f.get("style", "")).strip() for f in fighters]
    if len(fighters) != 2 or not all(styles) or styles[0] == styles[1]:
        fail("population.fighters must be two men with two different, named styles: %s" % fighters)
    if sorted(pop.get("landed_contacts", [])) != sorted(landed):
        fail("population.landed_contacts %s != FightStoppageRead.LANDED_CONTACTS %s" % (pop.get("landed_contacts"), landed))
    if str(pop.get("blow_census", "")) != "res://research/U79_admitted_strikes.json":
        fail("population.blow_census must be res://research/U79_admitted_strikes.json")
    rounds = int(pop.get("rounds", 0))
    full = rounds * float(pop.get("round_seconds", 0.0))

    bouts = data.get("bouts", [])
    if len(bouts) != 30:
        fail("bouts has %d rows, 30 expected" % len(bouts))
    counted = 0.0
    for b in bouts:
        secs = float(b.get("round_seconds_counted", -1))
        counted += secs
        method = str(b.get("method", "")).lower()
        if method in ("decision", "draw"):
            if abs(secs - full) > 0.11:
                fail("seed %s went the distance but counts %.2f s of round time, not %.0f" % (b.get("seed"), secs, full))
        elif not 0.0 < secs < full:
            fail("seed %s ended by %s but counts %.2f s of round time" % (b.get("seed"), method, secs))

    pooled = data.get("pooled", {})
    round_minutes = float(pooled.get("round_minutes", 0.0))
    if not near(round_minutes, counted / 60.0, rel=0.0005, absolute=0.01):
        fail("pooled.round_minutes %.3f != the bouts' counted round time %.3f min" % (round_minutes, counted / 60.0))
    for name in ("a", "b", "pair"):
        if name not in pooled:
            fail("pooled lacks %s" % name)
    if failures:
        return finish()
    sa = check_fighter("a", pooled["a"], round_minutes, nodes, landed, census)
    sb = check_fighter("b", pooled["b"], round_minutes, nodes, landed, census)
    pair = pooled["pair"]
    for key in ("actions", "strikes_thrown", "strikes_thrown_per_min", "strike_intervals_s"):
        if key not in pair:
            fail("pooled.pair lacks %s" % key)
    if failures:
        return finish()
    if int(pair["strikes_thrown"]) != int(sa or 0) + int(sb or 0):
        fail("pooled.pair.strikes_thrown != a + b")
    check_intervals("pooled.pair.strike_intervals_s", pair["strike_intervals_s"], int(pair["strikes_thrown"]))

    check_cadence(data.get("cadence", {}), pooled, source_model())

    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    first = next((l for l in md if l.strip()), "")
    if first.strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 40:
        fail("the digest is %d lines, 40 at most" % len(md))
    text = "\n".join(md)
    for style in styles:
        if style and style.lower() not in text.lower():
            fail("the digest does not name the population style %r" % style)
    for s in ("a", "b"):
        figure = "%.1f" % float(pooled[s]["strikes_thrown_per_min"])
        if figure not in text:
            fail("the digest does not print fighter %s's strikes thrown a minute (%s)" % (s, figure))
    if "Q94 counted" not in text:
        fail("the digest does not say, in a line starting 'Q94 counted', what Q94 got wrong")
    return finish()


def finish():
    if failures:
        print("Q94B_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("Q94B_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
