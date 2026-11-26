#!/bin/sh
# S562: the falls-short runs again - the first set gave the other man ground (the missed staging); now he stands.
cd /e/FightCamp/Lean
B=ops/previews/s562_glide
free_gpu() { while python ops/Tools/godot_slot.py status 2>/dev/null | grep -q "running .*hidden_desktop"; do sleep 30; done; }
until grep -q FIX_DONE $B/render_fix.out 2>/dev/null; do sleep 30; done
free_gpu
rm -rf $B/short_r3 $B/short_r2
sh $B/render_short.sh > $B/render_short2.out 2>&1
echo FIX2_DONE
