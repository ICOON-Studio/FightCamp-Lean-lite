# FightCamp - Steam AI content disclosure, draft (S396, 2026-11-07)

Steam's content survey asks developers to describe AI use: content made with AI before release ("pre-generated"), and content
generated while the game runs ("live-generated"). Plan s2: Claude drafts, the operator reads, confirms and submits. Draft, not
legal advice. Recheck against the shipped build before submitting: if an asset is added or removed, this changes.

## What the shipped build contains (checked in the repo S396)
| Content | Made how | AI? |
| --- | --- | --- |
| Sound effects and the crowd loop (28 files) | Ludo.ai audio generation, on the operator's paid plan (assets/audio/sounds.json, every `source`) | Yes, pre-generated |
| Boxing boots 3D model and textures | Higgsfield tripo_3d, job c5591bc5 (assets/models/kit/CREDITS.md) | Yes, pre-generated |
| Fighters, coaches, corner team | Epic MetaHuman Creator | No (character creator, not generative AI) |
| Gloves | "Boxing Glove" by Incg5764, CC BY 4.0, edited by script | No |
| Motion | CMU motion capture, Mixamo, Quaternius/ActionForge, clips authored on the rig | No |
| Menu pictures (training cards, move cards, portraits) | Rendered from the game's own 3D fighters | No |
| Icons, fonts | Lucide, Barlow, Bebas Neue, Permanent Marker | No |
| Game code, game text, rules and balance numbers | Written with AI coding assistants (Claude and others), directed and reviewed by the developer | Yes, AI-assisted |

Nothing is generated while the game runs: no AI model ships in the build and the game makes no network calls.

## Draft answer for the survey
**Pre-generated:** "FightCamp's sound effects and its boxing boot model were created with AI generation tools (Ludo.ai, Higgsfield)
and then selected and edited by the developer. The game's code and text were written with the help of AI coding assistants under
the developer's direction and review. Characters were made with MetaHuman Creator; motion comes from motion capture libraries;
all menu pictures are renders of the game's own 3D scenes."
**Live-generated:** "None. The game does not generate content with AI while it runs."

## Before submitting
- Operator: read the Ludo.ai and Higgsfield terms in force today and keep a copy (plan s2 says unread).
- If the sounds or the boot are replaced by human-made assets before launch, delete those rows.
