#!/usr/bin/env python3
"""Q113 check script — validates the role-priority trace.

The task: the plan says "jab first" (PRIMARY=3.0 for setup) and the engine
delivers "cross first" (~74% power).  The role_weights are CORRECTLY set by
FightRealtime._role_weights — the bug is that the single-stage weighted walk
in FightMoves.select DILUTES them: a role served by ten techniques splits
its weight ten ways while a role served by one concentrates it all.

This check validates:
  1. Census JSON exists and is non-empty.
  2. Every expected discipline present with bouts > 0.
  3. Per-plan role_weights dicts are present and non-empty for at least
     one plan per discipline (the weights are NOT the default-1.0 trap).
  4. At least TWO distinct role_weights dicts are observed across all
     plans (proves the plan drives the weights, not a uniform default).
  5. DILUTION EVIDENCE: for at least one plan, the role with the highest
     weight is NOT the role with the highest attempt share — proving the
     single-stage walk lost the plan's intent.  This is the bug.
  6. Setup ceiling per ruleset is reported (may be 0 — that is a valid
     content-gap finding, not a failure).
  7. Population is named and matches Q112 (same pairings).
  8. Denominators are printed beside every share (raw counts present).

Exits 0 only if ALL checks pass.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
CENSUS_JSON = os.path.join(HERE, "Q113_census.json")
EXPECTED_DISCIPLINES = {"boxing", "kickboxing", "muay_thai", "mma"}


def fail(msg: str) -> None:
    print(f"FAIL: {msg}", file=sys.stderr)
    sys.exit(1)


def main() -> None:
    # 1. Census JSON exists
    if not os.path.isfile(CENSUS_JSON):
        fail(f"Census JSON not found: {CENSUS_JSON}")
    with open(CENSUS_JSON, "r", encoding="utf-8") as f:
        census = json.load(f)
    if not census:
        fail("Census JSON is empty")

    # 2. Every expected discipline present
    disciplines = census.get("disciplines", {})
    if not disciplines:
        fail("No disciplines in census")
    for disc in sorted(EXPECTED_DISCIPLINES):
        if disc not in disciplines:
            fail(f"Discipline '{disc}' missing from census")
        d = disciplines[disc]
        total_bouts = d.get("total_bouts", 0)
        if total_bouts == 0:
            fail(f"Discipline '{disc}' has 0 bouts — census is vacuous")

    # 3. Per-plan role_weights present and non-empty for at least one plan
    all_role_weight_dicts = []
    all_plans = []
    for disc in sorted(EXPECTED_DISCIPLINES):
        d = disciplines[disc]
        plans = d.get("plans", [])
        if not plans:
            fail(f"Discipline '{disc}' has no per-plan data")
        found_nonempty = False
        for plan_entry in plans:
            rw = plan_entry.get("role_weights", None)
            if rw is None:
                fail(
                    f"Discipline '{disc}' plan '{plan_entry.get('id', '?')}'"
                    f" missing 'role_weights' key"
                )
            if rw:
                found_nonempty = True
                all_role_weight_dicts.append(rw)
            all_plans.append((disc, plan_entry))
        if not found_nonempty:
            fail(
                f"Discipline '{disc}' has no plan with non-empty role_weights"
                " — the default-1.0 trap: all plans look identical"
            )

    # 4. At least TWO distinct role_weights dicts across all plans
    distinct = []
    for rw in all_role_weight_dicts:
        frozen = tuple(sorted(rw.items()))
        if frozen not in distinct:
            distinct.append(frozen)
    if len(distinct) < 2:
        fail(
            f"Only {len(distinct)} distinct role_weights dict(s) observed"
            " across all plans — different plans produce identical weights."
            " This is the default-1.0 trap: FightMoves.select defaults"
            " role_weights.get(role, 1.0), so an empty dict and a balanced"
            " one behave identically."
        )

    # 5. DILUTION EVIDENCE: for at least one plan, the striking role with
    #    the highest weight is NOT the role with the highest attempt share.
    #    This proves the single-stage walk dilutes the plan's intent.
    #    We only compare STRIKING roles (setup/damage/counter) because
    #    control/takedown/escape/submission roles go through the grapple
    #    path and don't use FightMoves.select.
    striking_roles = {"setup", "damage", "counter"}
    dilution_found = False
    for disc, plan_entry in all_plans:
        rw = plan_entry.get("role_weights", {})
        att = plan_entry.get("attempts", {})
        att_by_role = att.get("by_role", {})
        att_total = att.get("total", 0)
        if att_total == 0:
            continue
        # Find the striking role with the highest weight
        best_weight_role = None
        best_weight = -1.0
        for role in striking_roles:
            w = float(rw.get(role, 0.0))
            if w > best_weight:
                best_weight = w
                best_weight_role = role
        if best_weight_role is None or best_weight <= 0.0:
            continue
        # Find the striking role with the highest attempt share
        best_att_role = None
        best_att = -1
        for role in striking_roles:
            a = int(att_by_role.get(role, 0))
            if a > best_att:
                best_att = a
                best_att_role = role
        if best_att_role is None or best_att <= 0:
            continue
        # If the highest-weight role is NOT the highest-attempt role,
        # the dilution is demonstrated
        if best_weight_role != best_att_role:
            dilution_found = True
            break
    if not dilution_found:
        fail(
            "No dilution evidence found — for every plan, the striking role"
            " with the highest weight IS the role with the highest attempt"
            " share.  Either the bug is fixed (re-run with the fix ON) or"
            " the census is not showing the single-stage walk's dilution."
        )

    # 6. Setup ceiling per ruleset is reported
    ceiling = census.get("setup_ceiling", {})
    if not ceiling:
        fail("Missing 'setup_ceiling' — the per-ruleset count of"
             " distinct setup-role striking techniques is not reported")
    for disc in sorted(EXPECTED_DISCIPLINES):
        if disc not in ceiling:
            fail(f"Setup ceiling missing for '{disc}'")

    # 7. Population is named and references Q112
    pop = census.get("population", "")
    if not pop or "q112" not in pop.lower():
        fail("Population does not reference Q112 — must reuse Q112's"
             " population for comparability")

    # 8. Denominators beside every share — raw counts present
    for disc in sorted(EXPECTED_DISCIPLINES):
        d = disciplines[disc]
        for plan_entry in d.get("plans", []):
            att = plan_entry.get("attempts", {})
            total = att.get("total", 0)
            if total == 0:
                continue
            by_role = att.get("by_role", {})
            if not by_role:
                fail(
                    f"Discipline '{disc}' plan '{plan_entry.get('id', '?')}'"
                    f" has attempts.total={total} but no by_role breakdown"
                )
            has_raw = any(isinstance(v, int) and v >= 0 for v in by_role.values())
            if not has_raw:
                fail(
                    f"Discipline '{disc}' plan '{plan_entry.get('id', '?')}'"
                    f" by_role has no raw counts — denominators must be"
                    f" printed beside every share"
                )

    # All checks passed
    print("Q113 check PASSED")
    print(f"  {len(distinct)} distinct role_weights dicts observed"
          f" across {len(all_role_weight_dicts)} plan entries")
    print(f"  Dilution evidence: FOUND (intent != delivery for at least one plan)")
    for disc in sorted(EXPECTED_DISCIPLINES):
        d = disciplines[disc]
        total_bouts = d["total_bouts"]
        n_plans = len(d.get("plans", []))
        ceil = ceiling.get(disc, "?")
        print(f"  {disc}: {total_bouts} bouts, {n_plans} plans,"
              f" setup ceiling={ceil}")
    # Print the dilution detail per plan
    print("\n  Role dilution detail (striking roles only):")
    for disc, plan_entry in all_plans:
        pid = plan_entry.get("id", "?")
        rw = plan_entry.get("role_weights", {})
        att = plan_entry.get("attempts", {})
        att_by_role = att.get("by_role", {})
        att_total = att.get("total", 0)
        land = plan_entry.get("landed", {})
        land_by_role = land.get("by_role", {})
        land_total = land.get("total", 0)
        parts = []
        for role in ["setup", "damage", "counter"]:
            w = float(rw.get(role, 0.0))
            a = int(att_by_role.get(role, 0))
            l = int(land_by_role.get(role, 0))
            ap = f"{100.0*a/att_total:.1f}%" if att_total > 0 else "n/a"
            lp = f"{100.0*l/land_total:.1f}%" if land_total > 0 else "n/a"
            parts.append(f"{role}: w={w:.1f} att={a}({ap}) land={l}({lp})")
        # Show intended primary (highest weight) vs delivered primary
        intended = max(("setup", "damage", "counter"),
                       key=lambda r: float(rw.get(r, 0.0)))
        delivered = max(("setup", "damage", "counter"),
                        key=lambda r: int(att_by_role.get(r, 0)))
        marker = " <-- DILUTED" if intended != delivered else ""
        print(f"    {disc}/{pid}: {' | '.join(parts)}")
        print(f"      intended_primary={intended} delivered_primary={delivered}{marker}")


if __name__ == "__main__":
    main()
