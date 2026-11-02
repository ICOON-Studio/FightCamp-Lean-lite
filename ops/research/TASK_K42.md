# TASK K42 — KALLI — ROKOKO STUDIO LIVE FOR BLENDER: CAN WE RETARGET WITH IT, HEADLESS, ON BLENDER 5.2?

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (retarget quality) - forecast research for a bake-off.

**Research only.** No code, no downloads, no sign-ups. Links and dates. One pass. Reply in this chat.

## Why this exists

We are testing free retargeters on our fight clips (RamsterZ FBX, Unreal-style bone names) onto our Tripo fighters
(Godot humanoid bone names). The candidates are Blender 5.2.1 LTS with the official "Retarget" extension, and Unreal
5.8's IK Retargeter. The operator suggested a third: the free Rokoko Studio Live add-on for Blender, with its bone-list
mapper. Our K41 found its retargeting needs no premium plan, but did not settle whether it needs a login.

## What we already hold - do NOT re-research

Our K40 and K41 (the licence rows for Rokoko Studio and the Blender plugin).

## What to find - one row each, labelled DOCUMENTED / SECONDARY / NOT FOUND

1. **Where to get it:** the official download (GitHub releases or rokoko.com), the latest version and date, the file
   name and size, its code licence, and whether it supports **Blender 5.0-5.2** (or only 4.x).
2. **Login:** does the RETARGETING panel work without signing in to a Rokoko account? Quote the docs or code. If a
   login is needed, is it a one-time token saved in Blender's preferences?
3. **Headless use:** can its retarget be run from a Python script with `blender --background`? Name its operator ids
   (for example `rsl.*`), and anything that needs a UI area or a login dialog.
4. **Quality evidence:** does it do anything beyond name mapping plus copying rotations (rest-pose correction, root
   motion, foot handling, differing proportions)? Any published comparison with Blender's Retarget or Expy Kit, or with
   Unreal's IK Retargeter.
5. **Data:** does the plugin send anything (our clips, telemetry) to Rokoko's servers when retargeting local files?

## Your answer's first section: `## DECISIONS`

At most five lines:
- usable on Blender 5.2 (YES / NO);
- login needed for retargeting (YES / NO / ONE-TIME);
- scriptable headless (YES / NO / PARTLY);
- does anything leave the machine;
- is it worth adding to the bake-off next to Blender's Retarget add-on.

Claude collects as: `research/K42_ROKOKO_BLENDER_RETARGET.md`
