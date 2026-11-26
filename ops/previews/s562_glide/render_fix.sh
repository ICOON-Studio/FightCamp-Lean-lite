#!/bin/sh
# S562 GLIDE1 part 4: the two runs whose contact failed the picture gate by 1-30 mm, with the family's other take.
cd /e/FightCamp/Lean
G="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
B=ops/previews/s562_glide
free_gpu() { while python ops/Tools/godot_slot.py status 2>/dev/null | grep -q "running .*hidden_desktop"; do sleep 30; done; }
until grep -q CHAIN_DONE $B/chain.out 2>/dev/null; do sleep 30; done
for spec in "2:blue_body_hook_landed:pro_kidney_shot" "1:blue_body_hook_landed:pro_kidney_shot" "1:blue_lead_uppercut_blocked:pro_left_uppercut_hard"; do
  r=$(echo $spec | cut -d: -f1); only=$(echo $spec | cut -d: -f2); take=$(echo $spec | cut -d: -f3); O=$B/fix_${only}_r$r; mkdir -p $O
  free_gpu
  python ops/Tools/godot_slot.py run --who s562 -- python tools/hidden_desktop.py run --timeout=1800 --log=$O/run.log "$G" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim.gd -- $O art=toon set=m south=blue range=$r only=$only take=$take
  echo "FIX $only r$r rc=$? $(grep 'PICS2D_ANIM runs=' $O/run.log)"
done
echo FIX_DONE
