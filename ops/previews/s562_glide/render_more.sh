#!/bin/sh
# S562 GLIDE1 part 3: the feint at Mid and Inside, the push off from the page's Inside spots to Mid (tools/pics2d_anim_more.gd).
cd /e/FightCamp/Lean
G="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
O=/e/FightCamp/Lean/ops/previews/s562_glide/more; mkdir -p $O
python ops/Tools/godot_slot.py run --who s562 -- python tools/hidden_desktop.py run --timeout=2400 --log=$O/run.log "$G" --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_anim_more.gd -- $O art=toon set=m south=blue mask=off only=blue_feint_r2,blue_feint_r1,red_feint_r2,red_feint_r1,push
echo "MORE rc=$? $(grep 'PICS2D_ANIM runs=' $O/run.log)"
echo MORE_RENDER_DONE
