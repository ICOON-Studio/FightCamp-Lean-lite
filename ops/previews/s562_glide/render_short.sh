#!/bin/sh
# S562 GLIDE1 part 2: the falls-short runs - a punch thrown from further than it reaches (Long: the hooks, crosses, body
# shots; Long and Mid: the uppercuts). Missed only, both corners. One windowed render at a time.
cd /e/FightCamp/Lean
G="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
B=/e/FightCamp/Lean/ops/previews/s562_glide
L="blue_lead_hook_,red_lead_hook_,blue_body_hook_,red_body_hook_,blue_cross_,red_cross_,blue_rear_hook_,red_rear_hook_,blue_body_cross_,red_body_cross_,blue_lead_uppercut_,red_lead_uppercut_,blue_rear_uppercut_,red_rear_uppercut_"
M="blue_lead_uppercut_,red_lead_uppercut_,blue_rear_uppercut_,red_rear_uppercut_"
for spec in "3:$L" "2:$M"; do
  r=${spec%%:*}; only=${spec#*:}; O=$B/short_r$r; mkdir -p $O
  python ops/Tools/godot_slot.py run --who s562 -- python tools/hidden_desktop.py run --timeout=3600 --log=$O/run.log "$G" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim.gd -- $O art=toon set=m south=blue range=$r short=1 only=$only
  echo "SHORT RANGE $r rc=$? $(grep 'PICS2D_ANIM runs=' $O/run.log)"
done
echo SHORT_RENDER_DONE
