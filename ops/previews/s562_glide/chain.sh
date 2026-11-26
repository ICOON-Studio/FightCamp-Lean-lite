#!/bin/sh
# waits for the Inside render, then the falls-short and the feint/push renders, one at a time; before each, waits until
# no other windowed render (hidden_desktop) is running in the Godot queue (the BODYUI2 worker's masks share the GPU).
cd /e/FightCamp/Lean
B=ops/previews/s562_glide
free_gpu() { while python ops/Tools/godot_slot.py status 2>/dev/null | grep -q "running .*hidden_desktop"; do sleep 30; done; }
until grep -q GLIDE_RENDER_DONE $B/render_all.out 2>/dev/null; do sleep 30; done
sleep 20; free_gpu
sh $B/render_short.sh > $B/render_short.out 2>&1
free_gpu
sh $B/render_more.sh > $B/render_more.out 2>&1
echo CHAIN_DONE
