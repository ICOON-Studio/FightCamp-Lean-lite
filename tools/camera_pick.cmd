@echo off
rem CAMPICK1 (S559): the two men in the guard; turn the camera, Enter saves the angle for the pictures. Esc closes.
start "" "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --path E:\FightCamp\Lean --windowed --resolution 1600x900 --audio-driver Dummy --script res://tools/camera_pick.gd -- user://campick art=toon
