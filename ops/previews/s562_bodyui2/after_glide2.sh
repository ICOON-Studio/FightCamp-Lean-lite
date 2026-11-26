#!/bin/sh
# S562: the head masks (BODYUI2's render_masks.sh) once his game is closed, GLIDE2's renders are over and no other
# windowed render runs - one job on the PC at a time.
cd /e/FightCamp/Lean
busy() {
  tasklist 2>/dev/null | grep -qi archeage && return 0
  ps -ef | grep -v grep | grep -q "s562_glide2/render.sh" && return 0
  python ops/Tools/godot_slot.py status 2>/dev/null | grep -q "running .*hidden_desktop" && return 0
  return 1
}
while busy; do sleep 60; done
sleep 60
while busy; do sleep 60; done
sh ops/previews/s562_bodyui2/render_masks.sh > ops/previews/s562_bodyui2/render_masks.out 2>&1
echo AFTER_GLIDE2_DONE
