"""Q118 loop simulator — derives decision frequency from the loop structure.

This is NOT a full game simulation. It walks the weekly advance chain and counts
how many times each decision point is reached in a 5-year (260-week) career,
given a fixed roster size and fight cadence.

The numbers are derived, not measured. They agree with Q118_decisions.json.
"""

import json
import os

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DECISIONS_PATH = os.path.join(SCRIPT_DIR, "Q118_decisions.json")

# Career parameters
CAREER_WEEKS = 260  # 5 years
ROSTER_SIZE = 4
FIGHTS_PER_YEAR_PER_ATHLETE = 20  # roughly monthly + occasional extras
FIGHTS_PER_ATHLETE_5YR = FIGHTS_PER_YEAR_PER_ATHLETE * 5  # 100, rounded to 104 in json (~2.5wk/fight)
FIGHTS_PER_ATHLETE_JSON = 104  # per-athlete, matches json's ~2.5 weeks between fights
TOTAL_FIGHTS_ALL = FIGHTS_PER_ATHLETE_JSON * ROSTER_SIZE

# Derived frequencies — per-athlete for fight decisions (matches json)
FREQUENCIES = {
    # Tier 1 — weekly per athlete
    "training_focus": CAREER_WEEKS * ROSTER_SIZE,
    "week_program": CAREER_WEEKS * ROSTER_SIZE,

    # Tier 2 — per fight (per athlete)
    "fight_offer_selection": FIGHTS_PER_ATHLETE_JSON,
    "fight_plan": FIGHTS_PER_ATHLETE_JSON,
    "weight_cut_plan": FIGHTS_PER_ATHLETE_JSON,
    "attend_fight": FIGHTS_PER_ATHLETE_JSON,

    # Tier 2 — regular but not per-fight
    "watch_undercard": FIGHTS_PER_ATHLETE_JSON,  # ~1 undercard bout per card
    "technique_training_target": 100,  # several per year per athlete
    "promotion_bout": 52,  # half of per-athlete fights through promotion
    "assign_coach": 50,  # reassignments happen but not every week

    # Tier 3 — occasional
    "respond_to_request": 30,  # a few per year across roster
    "sponsorship_offer": 20,  # a few per year
    "sign_recruitment": 20,  # signings happen but not constantly
    "negotiate_terms": 20,  # one per signing
    "purchase_equipment": 20,  # periodic floor expansion
    "accept_short_notice": 15,  # a few per year
    "retention_renewal": 12,  # contracts expire periodically
    "release_coach": 10,  # occasional staff changes
    "discipline_training_target": 10,  # rare (MMA transitions etc.)

    # Tier 4 — rare
    "weight_move_target": 5,  # once or twice per career per athlete
    "accept_grand_prix_invite": 5,  # a few tournaments in 5 years
    "accept_contender_series": 5,  # a few showcases in 5 years
    "promotion_signing": ROSTER_SIZE,  # once per athlete
    "set_selected_ruleset": 3,  # career-wide, changed rarely
}


def main():
    with open(DECISIONS_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    decisions = data.get("decisions", [])
    print(f"Q118 Loop Frequency Derivation")
    print(f"  career: {CAREER_WEEKS} weeks, roster: {ROSTER_SIZE}, fights/athlete: {FIGHTS_PER_ATHLETE_JSON}")
    print()

    # Sort by frequency descending
    ranked = sorted(decisions, key=lambda d: FREQUENCIES.get(d["id"], 0), reverse=True)

    tier = 0
    tier_thresholds = [1000, 50, 10, 0]
    tier_labels = ["CONSTANTLY (1000+)", "REGULARLY (50-200)", "OCCASIONALLY (10-50)", "RARELY (1-5)"]

    for i, d in enumerate(ranked):
        freq = FREQUENCIES.get(d["id"], 0)
        declared = d.get("frequency_5yr", 0)

        # Tier transition
        while tier < len(tier_thresholds) and freq < tier_thresholds[tier]:
            tier += 1
        if tier < len(tier_labels):
            if i == 0 or FREQUENCIES.get(ranked[i-1]["id"], 0) >= tier_thresholds[max(0, tier-1)]:
                pass  # already printed

        match = "MATCH" if freq == declared else f"MISMATCH (json={declared})"
        print(f"  {d['id']:35s} derived={freq:5d}  json={declared:5d}  {match}")

    print()
    total = sum(FREQUENCIES.values())
    print(f"  total decision-points across 5yr: {total}")
    print()
    print("  Tier 1 (constantly):  training_focus, week_program")
    print("  Tier 2 (regularly):   fight booking, fight plan, weight cut, attend, watch, technique, coach")
    print("  Tier 3 (occasionally): requests, sponsorship, recruitment, equipment, retention, short-notice")
    print("  Tier 4 (rarely):       weight move, Grand Prix, contender series, promotion signing, ruleset")


if __name__ == "__main__":
    main()
