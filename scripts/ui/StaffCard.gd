extends RefCounted
## The Staff jobs' plain names (OfficeDesk's staff sheet and StaffDesk's cards read them).
## S547 STAFFCARDS1 (owner S545 on this page: "this screen is terrible"): the Staff page this file drew - the coach slates with
## their bar rows, the job tiles, the members / reputation / dues tiles - is now scripts/ui/StaffDesk.gd (cards, after the S546
## mockup). Nothing else called its drawing, so it went; the git history keeps it (S546 tree, 493 lines).

const ROLE_WORD := {"assistant": "Second coach", "strength": "Strength coach", "physio": "Physio", "cutman": "Cutman"}
