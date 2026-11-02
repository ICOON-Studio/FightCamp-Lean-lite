#!/usr/bin/env python3
"""Q112 check script — validates the role census output.

Exits 0 only if the census is present, non-vacuous, and internally
consistent. Derives allowed role names from FightMoves.gd, not from a
hardcoded list.

Checks:
  1. Census JSON exists and is non-empty.
  2. Every discipline has total attempts > 0 (catches 0/0 = 0.0%).
  3. Attempt role shares sum to ~100% (catches forgotten buckets).
  4. Landed role shares sum to ~100%.
  5. Empty-role row is explicitly present (even if 0%).
  6. Digest names a population and a catalogue.
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
CENSUS_JSON = os.path.join(HERE, "Q112_census.json")
DIGEST_MD = os.path.join(HERE, "Q112_ROLE_CENSUS.md")
FIGHT_MOVES = os.path.join(HERE, "..", "scripts", "FightMoves.gd")
EXPECTED_DISCIPLINES = {"boxing", "kickboxing", "muay_thai", "mma"}
TOLERANCE = 2.0  # percentage points


def fail(msg: str) -> None:
    print(f"FAIL: {msg}", file=sys.stderr)
    sys.exit(1)


def derive_roles() -> tuple:
    """Read FightMoves.gd and extract STRIKE_ROLES and POWER_ROLES."""
    if not os.path.isfile(FIGHT_MOVES):
        fail(f"Cannot find FightMoves.gd at {FIGHT_MOVES}")
    text = open(FIGHT_MOVES, "r", encoding="utf-8").read()

    strike_match = re.search(
        r'const\s+STRIKE_ROLES\s*:=\s*\[([^\]]+)\]', text
    )
    if not strike_match:
        fail("Cannot find STRIKE_ROLES in FightMoves.gd")
    strike_roles = re.findall(r'"(\w+)"', strike_match.group(1))

    power_match = re.search(
        r'const\s+POWER_ROLES\s*:=\s*\[([^\]]+)\]', text
    )
    if not power_match:
        fail("Cannot find POWER_ROLES in FightMoves.gd")
    power_roles = re.findall(r'"(\w+)"', power_match.group(1))

    return strike_roles, power_roles


def main() -> None:
    strike_roles, power_roles = derive_roles()
    allowed_roles = set(strike_roles) | {"empty"}

    # 1. Census JSON exists and is non-empty
    if not os.path.isfile(CENSUS_JSON):
        fail(f"Census JSON not found: {CENSUS_JSON}")
    with open(CENSUS_JSON, "r", encoding="utf-8") as f:
        census = json.load(f)
    if not census:
        fail("Census JSON is empty")

    disciplines = census.get("disciplines", {})
    if not disciplines:
        fail("No disciplines in census")

    # 2. Every expected discipline present with attempts > 0
    for disc in sorted(EXPECTED_DISCIPLINES):
        if disc not in disciplines:
            fail(f"Discipline '{disc}' missing from census")
        d = disciplines[disc]
        att_total = d.get("attempts", {}).get("total", 0)
        if att_total == 0:
            fail(
                f"Discipline '{disc}' has 0 total attempts "
                "- census is vacuous"
            )

    # 3-5. Per-discipline share and empty-role checks
    for disc in sorted(EXPECTED_DISCIPLINES):
        d = disciplines[disc]

        att_by_role = d.get("attempts", {}).get("by_role", {})
        land_by_role = d.get("landed", {}).get("by_role", {})

        # 5. Empty-role row must be explicitly present
        if "empty" not in att_by_role:
            fail(
                f"Discipline '{disc}' missing 'empty' role row in attempts "
                "- absent vs 0% are different"
            )
        if "empty" not in land_by_role:
            fail(
                f"Discipline '{disc}' missing 'empty' role row in landed "
                "- absent vs 0% are different"
            )

        # 3. Attempt shares sum to ~100%
        att_total = d.get("attempts", {}).get("total", 0)
        if att_total > 0:
            att_share_sum = sum(
                100.0 * v / att_total for v in att_by_role.values()
            )
            if abs(att_share_sum - 100.0) > TOLERANCE:
                fail(
                    f"{disc} attempt role shares sum to {att_share_sum:.1f}%,"
                    f" expected ~100%"
                )

        # 4. Landed shares sum to ~100%
        land_total = d.get("landed", {}).get("total", 0)
        if land_total > 0:
            land_share_sum = sum(
                100.0 * v / land_total for v in land_by_role.values()
            )
            if abs(land_share_sum - 100.0) > TOLERANCE:
                fail(
                    f"{disc} landed role shares sum to {land_share_sum:.1f}%,"
                    f" expected ~100%"
                )

    # 6. Digest names population and catalogue
    if not os.path.isfile(DIGEST_MD):
        fail(f"Digest not found: {DIGEST_MD}")
    digest = open(DIGEST_MD, "r", encoding="utf-8").read()
    digest_lower = digest.lower()
    if "population" not in digest_lower:
        fail("Digest does not name a population")
    if "catalogue" not in digest_lower and "catalog" not in digest_lower:
        fail("Digest does not name a catalogue")

    print("Q112 check PASSED")
    print(f"  roles derived: strike={strike_roles}, power={power_roles}")
    for disc in sorted(EXPECTED_DISCIPLINES):
        d = disciplines[disc]
        att_total = d["attempts"]["total"]
        land_total = d["landed"]["total"]
        pairings = d.get("pairings", [])
        pairing_names = [p["name"] for p in pairings]
        print(
            f"  {disc}: {att_total} attempts, {land_total} landed,"
            f" {len(pairings)} pairings ({', '.join(pairing_names)})"
        )


if __name__ == "__main__":
    main()
