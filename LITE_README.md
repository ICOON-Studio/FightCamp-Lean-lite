# FightCamp-Lean-lite (code-only mirror)

This repository is a CODE-ONLY mirror of ICOON-Studio/FightCamp-Lean main (a Godot 4.7.2 boxing-management game),
built by Tools/lite_mirror.py --lean. Models, animations, fonts and images are NOT here - every script, test, tool and
data file is, at the same paths. Read CLAUDE.md first: tests are pure rule-module tests (tests/*_test.gd), run with
  godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd

Work on your own branch and open the PR HERE, into main. It is relayed automatically to ICOON-Studio/FightCamp-Lean
(same branch name, same title and body), where Claude reviews and merges. Never merge anything yourself, and never
delete or weaken a test to go green.
