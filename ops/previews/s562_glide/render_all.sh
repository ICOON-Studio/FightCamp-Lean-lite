#!/bin/sh
# S562 GLIDE1: every punch run at each page range it reaches (tools/pics2d_anim.gd range=), one windowed render at a time.
cd /e/FightCamp/Lean
G="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
B=/e/FightCamp/Lean/ops/previews/s562_glide
L="blue_jab_,red_jab_,blue_body_jab_,red_body_jab_"
M="blue_jab_,red_jab_,blue_body_jab_,red_body_jab_,blue_lead_hook_,red_lead_hook_,blue_body_hook_,red_body_hook_,blue_cross_,red_cross_,blue_rear_hook_,red_rear_hook_,blue_body_cross_,red_body_cross_"
I="blue_lead_hook_,red_lead_hook_,blue_lead_uppercut_,red_lead_uppercut_,blue_body_hook_,red_body_hook_,blue_cross_,red_cross_,blue_rear_hook_,red_rear_hook_,blue_rear_uppercut_,red_rear_uppercut_,blue_body_cross_,red_body_cross_"
for spec in "3:$L" "2:$M" "1:$I"; do
  r=${spec%%:*}; only=${spec#*:}; O=$B/r$r; mkdir -p $O
  python ops/Tools/godot_slot.py run --who s562 -- python tools/hidden_desktop.py run --timeout=5400 --log=$O/run.log "$G" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim.gd -- $O art=toon set=m south=blue range=$r only=$only
  echo "RANGE $r rc=$? $(grep 'PICS2D_ANIM runs=' $O/run.log)"
done
echo GLIDE_RENDER_DONE
