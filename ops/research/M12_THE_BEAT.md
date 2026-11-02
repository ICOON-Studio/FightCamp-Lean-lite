# M12 — THE BEAT: THE MOMENT THE GYM SAYS YES

Maria Art Director · 2026-09-07 · art only (no `.gd` / `.tscn` / `HANDOFF.md` / assets/data)

M11 dressed the STATE of a long career. This pack dresses the MOMENT: the
fighter asks to retire, the gym answers GRANT or DECLINE, and the screen
either holds a room (YES) or leaves a mark (NO). Inside K24 — not reopening it.

## Call: ask + room, never vanish, never modal

K24 ruled: retirement is the ask plus room; on YES a beat with R45 spirit;
a vanish is dishonest; a modal breaks THE DAY grammar.

**Decision: RETIREMENT rides the existing request card (attention strip +
ACTION ROW). GRANT opens a full-bleed TRACK beat (not `UIKit.modal`). DECLINE
leaves a ONE MORE mark (not silence). The closed G9 plate is the last thing
on the retired profile.**

### YES beat (one line)
Full-bleed TRACK room · one figure · MUTED RETIRED chip · short record line · standard BACK TO DESK — not modal, not vanish, not fade-to-nothing.

### NO beat (one line)
In-place LINK reply plate ("One more run…") · ONE MORE / RETURNS LATER chips · ask clears and may re-fire — mark not silence, no punish popup.

## Token map (held from M11)

| Role | UITokens | Notes |
| --- | --- | --- |
| Shell / hairline | `GYM_DEFAULT` | SELECT does not exist |
| Candour / authored | `LINK` | fighter words, epitaph edge, defer line |
| RETIRED / ONE MORE | `MUTED` on `CHIP`/`TRACK` | not BAD, not GOLD |
| Age numeral (veteran) | `DIM` | M11 ink ladder |
| Name / record | `TEXT` | never dimmed for age |
| Medical family | unused | BAD/AMBER/GOOD stay M6 |
| Verdict / belt / GO | unused | GOLD / SODIUM / ICE / GO out |

## UIKit factories (buildable as stands)

| Element | Factory |
| --- | --- |
| Attention strip | `UIKit.day_attention_strip` |
| Request card shell | `UIKit.action_card` |
| GRANT / DECLINE / DESK / ACK | `UIKit.button` (primary/standard — never go) |
| RETIREMENT / RETIRED / ONE MORE / VETERAN | `UIKit.chip` |
| Type | `UIKit.caps` / `UIKit.display` / `UIKit.label` |
| Surfaces | `UIKit.block` |
| Portrait | `UIKit.circle` (+ avatar fill) |
| Epilogue fields | `UIKit.pair` |
| Roster after NO | `UIKit.squad_row` |
| **Forbidden** | `UIKit.modal` · `UIKit.celebration` |

No new factory. No new rail. No new token.

## Boards → `DesignLibrary/screens/the_beat/`

| File | Content |
| --- | --- |
| `m12_01_ask_in_place.png` | RETIREMENT GRANT/DECLINE + words + age ink beside PAY RAISE |
| `m12_02_beat_on_yes.png` | Full-bleed room · not modal/vanish/fade |
| `m12_03_beat_on_no.png` | One more run mark · returns later |
| `m12_04_record_plate_closed.png` | G9 fields on OVER career · candour |
| `m12_05_rejects.png` | Named refusals |
| `m12_06_composed.png` | Optional desk compose |

## Hero career (reachable from Mon 5 Jan 2026)

Sofia Reyes · debut W3 Jan 2026 · peak 2030 · final W40 Oct 2033 · 8 years ·
age 34 · epitaph "Eight years. Never made the gym wait." · unfinished "Never fought abroad".
Peak 2019 refused.

## Refusals

1. Vanish on GRANT · 2. Modal over THE DAY · 3. Fade-to-nothing · 4. BAD/funeral ·
5. GOLD/GO celebrate · 6. Silence on DECLINE · 7. declining/washed copy ·
8. Peak pre-2026 · 9. New token/SELECT · 10. New rail/factory · 11. Funeral epitaph ·
12. Punish popup on NO.

## Delivery

- Spec: `research/M12_THE_BEAT.md`
- Boards: `DesignLibrary/screens/the_beat/m12_*`
- Staging: `_maria_delivery/M12_THE_BEAT.zip`
- Land note: `_maria_delivery/CLAUDE_LAND_NOTE_M12.md` + `research/CLAUDE_LAND_NOTE_M12.md`

Operator relay. Claude writes the HANDOFF block when the pack lands.
