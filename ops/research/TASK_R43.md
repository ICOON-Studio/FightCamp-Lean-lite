# TASK R43 — THE PURSE IS THE FIGHTER'S (Claude)

**Status: COMPLETE 2026-09-06.** Digest `research/R43_DIGEST.md`. J4 priority rank **1**. No dependency on
any other agent's open task.

Model: Opus, effort high, Fast off. It edits `GameState.gd` settlement and
touches saved career money on both sides of the ledger.

## The bug, exactly

`GameState.gd:10253` settles every bout the player's fighter has:

```gdscript
gym["cash"] = int(gym.get("cash", 0)) + purse + win_bonus + performance_bonus + gate_share - expenses
```

**The gym banks one hundred percent of the fighter's purse.** The line below it
(`:10257`) increments `athlete["career_earnings"]` by the same money — but that
is a COUNTER for the Ambitions "Financial Security" goal, not a wallet. The
athlete receives nothing. `FightContract.settlement_for` (`FightContract.gd:214`)
already computes a fighter-shaped `net` and `:10253` hands it to the gym.

J4 **E1** is the ruling: **the payee is the athlete.** The promoter pays the
contestant named on the commission bout form (Nevada Official Bout Agreement is
Promoter ↔ Contestant; `NAC 467.112` / `467.137(1)`; ABC model contract:
Promoter pays Boxer). The gym is on that form only if it is the **filed
manager**, and then it takes a share **of** the purse, never the purse.

This is not a balance number slightly wrong. It is the wrong party being paid,
and it is the player's own role.

## What to build

### Stage A — the athlete's wallet

- Add `athlete["cash"]` (or `purse_balance`; pick one name and use it
  everywhere). Defaults to 0 on every existing athlete, so an untouched save
  loads and plays identically. This is the R39/R41 additive contract.
- `:10253` pays the **athlete**, not the gym. `career_earnings` keeps counting
  exactly as it does now — it is a lifetime counter and must not become the
  wallet, or Ambitions starts spending itself.
- Expenses stay where J4 **E5** puts them: uncovered travel and accommodation
  come off the fighter's side (`FightContract.gd:220-224` already computes
  them). Promoter-side taxes are NOT a fighter deduction and none exist in the
  code — do not add one.
- The weight-miss fine (D2 / J3 D11) already comes off the purse before this
  line. It keeps coming off the purse, which is now the fighter's.

### Stage B — the gym's share is a filed manager share, or nothing

- **E23 is the default: with no manager contract filed, the gym's delta from
  that purse is `0`.** Ship that. Do not author a default percentage.
- If a share is modelled at all, it is a **manager** share on the athlete's
  contract, capped, and the cap comes from data:
  - NV `NAC 467.102(6)`, CA `4 CCR 221(b)`, NJ `N.J.A.C. 13:46-6.4`:
    **33 1/3%** of ring earnings.
  - NY `19 NYCRR 209.12`: the combatant must still receive **≥ 50%** after
    authorized deductions.
  - **E2: store the CAP, never a default take.** The customary MMA "10–20%" is
    journalism. Inventing a house percentage is the PPV-% mistake in another
    coat (J3 D14).
- **E3: a gym taking ≥ 10% of a gross purse IS a manager** under NV, CA and NJ
  definitions. There is no second `gym_cut` tax next to a manager share — it is
  the same object. Do not add one.

### Stage C — the gym still has to eat

Payroll and upkeep (`_settle_billing`) already run every week against
`gym["cash"]`, and after Stage A the purses stop feeding it. **Say what the gym
now lives on in the report** and, if a hole opens in normal play, name it — do
not paper over it with an invented gym cut. John's J5 is researching the gym's
own ledger in parallel and it is the honest source for whatever fills it.

### Out of scope, deliberately

- The **desk licence flag** (J4 E7, rank 3). It ships only if this stage lets
  the gym take a filed manager share. If Stage B ships the `0` default, the
  licence waits — a gym taking no cut needs no licence.
- **Multi-bout / promotional terms** (J4 rank 4). `FightContract` stays a bout
  form.
- Event medical insurance (E11) is the promoter's; never a gym debit.
- No invented MRI, camp or gym-cut number anywhere (E12 / E13 / E21).
- No UI. Whatever reads `gym["cash"]` and `career_earnings` keeps reading them.

## Rules

- Additive to the save. Every field defaults so an untouched save loads and
  plays identically, and no existing balance is retroactively re-split.
- Any percentage or cap that survives goes in `Godot/assets/data/` with an
  `evidence` field naming the statute (**E21**). No `evidence`, no number.
- Nothing may attribute an invented number to a real organization (J1 §4.1).

## Anchors

- `Godot/scripts/GameState.gd:10253` the settlement line, `:10257`
  `career_earnings`, `_apply_fight_result` around `:10134`.
- `Godot/scripts/FightContract.gd:214-233` `settlement_for`, `:145`
  `opening_terms` (`travel_covered` / `accommodation_covered`), `:93`
  `money_on_table`, `:198` `package_value`.
- `GameState.gd:_settle_billing` — the weekly payroll/upkeep the gym pays.
- `research/J4_THE_DESK_AND_THE_CUT.md` — E1, E2, E3, E5, E18, the
  file-level anchor table, and assertions **E19–E25**.

## Parse gate (before any test run)

```bash
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/FightContract.gd
```

## Tests

New `Godot/tests/purse_payee_test.gd`, from J4's own assertions:

| ID | Assertion |
|----|-----------|
| P1 | After a bout settles, `gym["cash"]` does **not** increase by the contracted `show_purse + win_bonus + performance_bonus + gate_share` (E19) |
| P2 | The athlete's wallet receives the bout-agreement money, and `career_earnings` counts the same money without being the wallet (E20) |
| P3 | With no manager contract filed, the gym's delta from that purse is exactly `0` (E23) |
| P4 | Uncovered travel/accommodation still come off the fighter's side, and no commission or promoter tax is deducted from the purse (E25) |
| P5 | A missed weight still forfeits its fraction, off the fighter's purse, before anyone is paid |
| P6 | No data file carries a `manager_cut` / `gym_cut` / `purse_share` percentage without an `evidence` field (E21); if a share exists it is ≤ the tagged jurisdiction's cap (E22) |
| P7 | A legacy save with no wallet field loads, plays and settles — the first settlement after this stage starts the wallet at the purse, and no historical balance is re-split |

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/purse_payee_test.gd
```

Then `fight_contract_test.gd`, `weight_cut_test.gd` and `smoke_test.gd` must
pass **unchanged**, plus any test that asserts on `gym["cash"]` after a fight —
find them before you edit, not after. Full suite once, in the background,
before the commit.

## Owned files

```
Godot/scripts/GameState.gd
Godot/scripts/FightContract.gd
Godot/assets/data/            (a cap with its evidence, only if one ships)
Godot/tests/purse_payee_test.gd   (new)
```

Check `git status -s` before staging: `GameState.gd` is the file every agent
wants.
