# TASK_C143 — CODEX — THE BLIND CONTRACT TEST FOR THE AUTHORED CLINCH HOLD

**Agent:** Codex · **Model:** gpt-5.6-luna · **Effort:** MEDIUM (the only setting) · **Fast:** off
**Launch:** `Tools\codex_task.cmd <FULL Windows path to this file>` from PowerShell.
**Branch:** master, main checkout. **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

**Test tier — you ADD one `.gd` test file and edit no script, so:** parse gate
(`python Godot/tools/check_scripts.py Godot/tests/fight_clinch_binding_test.gd`) then **that
ONE test**, direct:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_clinch_binding_test.gd
```

**NO full suite, no `--only` subsets.** A new test file cannot break another test.

---

## THIS IS A BLIND CONTRACT TEST. DO NOT LOOK AT THE IMPLEMENTATION.

Claude is authoring a paired clinch hold in Cascadeur **right now, in this same checkout**, and
will bind it. You are writing the test for that binding **from the contract below and from
nothing else.** This split paid off two days running — C142 wrote the `CASCY_TO_UE4` contract
test blind, Cursor wrote the map, and the two agreed with no contact. Repeat that.

**Specifically forbidden:** reading any branch other than master, reading Claude's working tree
changes to `Godot/scripts/FightClipBinding.gd`, or `git diff`ing to see what is being built.
You may read `FightClipBinding.gd` **on master as it stands today** to learn the SHAPE of the
existing tables (`PAIRED_BINDINGS` at line 882, `PAIRED_STRIKE_BINDINGS` at line 1008,
`paired_strike_metadata_for` at line 1030) — that is the public surface, not the answer.

**It must SKIP GREEN while the entry does not exist yet** — print a SKIP line, `failures=0`,
exit 0 — so it can land on master before Claude's work does, and start passing for real the
moment the entry appears. That is exactly what C142 did.

---

## THE CONTRACT

Claude will add ONE entry to `FightClipBinding.PAIRED_STRIKE_BINDINGS`, keyed by the technique
id **`"mma_dirty_boxing"`**. Assert all of this:

1. `FightClipBinding.PAIRED_STRIKE_BINDINGS` has the key `"mma_dirty_boxing"`.
   **Absent ⇒ SKIP GREEN, exit 0.** Everything below runs only when it is present.
2. The entry carries exactly the **six** fields the other entries carry, no more and no fewer:
   `pair_key`, `att`, `vic`, `start_s`, `end_s`, `content_s`.
3. `pair_key` is the exact string `"Cascy_CageClinch"`.
4. `att` ends with `"_Att.glb"` and `vic` ends with `"_Vic.glb"`. **`.glb`, not `.fbx`** — a
   Cascadeur export is glTF and the RamsterZ pack is FBX; a `.fbx` suffix here means the wrong
   pipeline was bound.
5. Both `att` and `vic` resolve to files that EXIST (`FileAccess.file_exists` on the
   `res://`-relative path via `ProjectSettings.globalize_path`, or `ResourceLoader.exists` —
   your choice, but one of them must genuinely touch the disk).
6. `att` and `vic` are DIFFERENT paths. (A hold whose two halves are the same file is one body
   played twice.)
7. `content_s` equals `end_s - start_s` to within 0.001.
8. `start_s >= 0.0` and `end_s > start_s`.
9. **`content_s` is between 3.0 and 8.0 seconds inclusive.** J32 (the clinch research memo,
   2026-09-21) puts a real clinch episode at roughly 4–7 s — mean per clinch 5.0/5.4/6.0 s
   across rounds in Davis et al.'s Olympic boxing data, by inference from total clinch time ÷
   frequency. A hold shorter than 3 s is a statue with a twitch; longer than 8 s is outside
   anything measured. **Write that sentence, with the source, as a comment above the
   assertion** — a bound with no study named beside it is the thing this project keeps getting
   wrong.
10. `FightClipBinding.is_paired_strike("mma_dirty_boxing")` returns `true`.
11. `FightClipBinding.paired_strike_metadata_for("mma_dirty_boxing")` returns a Dictionary with
    all **seven** keys — the six above plus `reference` — and its six carried values equal the
    entry's, field for field.
12. **The reference must resolve to the Cascadeur rest, not the RamsterZ T-pose.**
    `FightClipRetarget.reference_for(<the entry's att path>, "")` must equal
    `FightClipRetarget.CASCY_REFERENCE`
    (`"res://assets/anim/audition/cascadeur/Cascy_rest_reference.glb"`), and must NOT equal
    `FightClipBinding.PAIRED_REFERENCE`. This is the one that silently produces a subtly wrong
    pose rather than an error: corrections computed against the wrong rest still load.
13. `FightClipRetarget.is_cascadeur_clip(<att>)` and `is_cascadeur_clip(<vic>)` are both `true`.
14. **Nothing else moved.** `PAIRED_STRIKE_BINDINGS` has at most 2 keys, and `"mma_guard_gnp"`
    is still one of them with `pair_key == "Paired_FullMount_H2H_Punches"`. A new binding that
    disturbs the bound ground-and-pound entry is a regression.

---

## PROVE IT WITH MUTANTS — AT LEAST FIVE, IN A SCRATCH COPY

`C117` passed thirty checks against a lock on a swinging foot. A contract test nobody has tried
to break is a green light with no bulb in it. Copy `FightClipBinding.gd` to your scratchpad,
break it each of these ways, and confirm the test goes RED each time. Put the five results in
the digest as a table:

1. `pair_key` changed to `"Cascy_Clinch"` (must fail on 3).
2. `att` given the `.fbx` extension (must fail on 4 **and** 12/13 — say which fired first).
3. `vic` set equal to `att` (must fail on 6).
4. `content_s` set to `end_s - start_s + 0.5` (must fail on 7).
5. `content_s` set to 1.667 — a plausible-looking number copied from the existing
   `grapple_control` entry (must fail on 9). **This is the realistic mistake**, which is why it
   is on the list.

If the entry does not exist on master when you run, mutate a **hand-written stub entry** in
your scratch copy so the mutants are still exercised, and say in the digest that the real
binding was absent and the test SKIPPED green against the real tree.

## OWNED FILES

- `Godot/tests/fight_clinch_binding_test.gd` (new)
- `research/C143_CLINCH_BINDING_CONTRACT.md` (new, the digest — keep it under 60 lines)

**Touch NOTHING else.** Do not edit `FightClipBinding.gd`, `FightClipRetarget.gd` or any other
test. Claude is inside `FightClipBinding.gd` this session.

## THE ONE TRAP

**`var x := <call>` fails when the call returns Variant** — and `Dictionary.get()` on an
untyped value is exactly that. Every value you pull out of `PAIRED_STRIKE_BINDINGS` needs its
type written: `var entry: Dictionary = ...`, `var content: float = float(entry["content_s"])`.
A parse error here does not fail the test, it HANGS it until the timeout.

Second trap, smaller: `FightClipBinding` and `FightClipRetarget` are scripts, not autoloads.
`load()` them inside `_initialize()`; do not add a top-level `preload`.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push master, then one line:

```
python Tools/agent_comms.py send --from codex --to claude --topic c143-ready --body "<one line>"
```

The CLI takes `--topic`, not `--subject`. Do NOT edit `HANDOFF.md`. Check `git status -s`
before staging — another agent's WIP may be pre-staged, and `AgentComms/messages` in
particular must be unstaged before any commit that is not the mail itself.
