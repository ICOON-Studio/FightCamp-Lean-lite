# G71 - THE MANAGER CONTRACT: how the gym earns from a fight (Grok, research) - S66, 2026-09-24

FightCamp is a combat-sports gym management game (Godot). The player runs the GYM. The operator has approved a
stage: **let the gym earn from its fighters' bouts through a manager contract.** This brief is the research that
stage needs BEFORE it is built. Design only - no code.

## What the game already rules (do not re-litigate; read `research/J4_THE_DESK_AND_THE_CUT.md` if you can)
- The promoter pays the FIGHTER (J4 E1). The gym is paid only a manager's SHARE of the fighter's ring earnings,
  and only if a manager contract is on file (E23: none filed = exactly 0 - today's game).
- Statutory CAPS, never defaults: NV/CA/NJ 33 1/3% of ring earnings; NY: the fighter must keep >= 50% after
  authorized deductions (`Godot/assets/data/manager_share_caps.json`). E2: "Do not author 10%, 15%, 20% or 33% as
  the game's manager take." Filed contracts seen in CSAC arbitrations used 16 2/3%, 18%, 25%, 30% - not a formula.
- E3: a gym taking >= 10% of a gross purse IS a manager (NV/NJ; CA > 10%) and must be licensed (E7: a flag is
  enough, no licence-exam career). There is no second "gym cut" beside a manager share.
- The gym already pays each fighter a WEEKLY WAGE (a separate employment contract, 26-week terms on the profile).

## The questions
1. **Real terms.** For boxing and MMA management contracts: term length, renewal, exclusivity, what the manager
   provides in exchange (bookings, negotiation, training costs, travel), termination and buyout, what happens to the
   share when the fighter changes gym. Mark each STATUTORY (cite the rule) or CUSTOMARY (cite the source) - and say
   NOT FOUND rather than invent.
2. **Why a fighter signs - or refuses.** What real evidence says drives a fighter's acceptance of a share: career
   stage, market value, who pays camp costs, a manager's record. Is there any published relationship between
   fighter quality and share, or only anecdotes?
3. **What shipped games did.** Football Manager (agents and their fees), Boxing Club Manager, MMA Manager / Pro
   Boxing Manager / WWE General Manager or any other management game with a cut of a fighter's or player's money:
   how the cut is set, negotiated and shown, and what players praised or hated (link reviews/forums).
4. **The minimum contract for FightCamp.** Propose the smallest set of fields, and for EACH field say what in the
   game READS it (settlement, the fighter's morale/loyalty, renewal, the licence flag). Say how the player proposes
   a share and how the fighter answers without inventing a default percentage - e.g. the fighter's ask derived
   from things the game already has (market value, wage vs market, loyalty). Say what you would NOT add, and why.
5. **The trap to name:** a wage AND a purse share on the same fighter - is that real (who does it, where), and how
   does the screen keep the two apart for the player?

## Deliverable
ONE markdown document titled `G71 - THE MANAGER CONTRACT`, pasted IN THE CHAT as one markdown code block (the
operator's side cannot open files in your sandbox), with sources inline, ending with one line saying what is still
unknown.
