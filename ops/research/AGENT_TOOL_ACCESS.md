# AGENT TOOL ACCESS — what is on this machine, how to drive it, and what is missing

**Verified on disk 2026-09-20 by Claude, not recalled from memory.** Every FOUND path below was
tested with `Test-Path` this session. Operator request: "make sure codex can access all the tools,
blender, higgsfield, rokoko, cascadeur, theia, meshy, tripo ai, harmony 4d etc".

**THE ONE RULE THAT OVERRIDES EVERYTHING HERE: NO API KEY, TOKEN OR PASSWORD IS EVER WRITTEN INTO
THIS REPO.** Not in a task file, not in a tool, not in a digest, not "temporarily". Credentials
reach a tool through an environment variable set at launch, or through that tool's own sign-in which
the operator completes. An agent that cannot reach a service says so and stops.

---

## INSTALLED AND VERIFIED — these five are real and drivable

| tool | path | headless |
|---|---|---|
| **Blender 5.2.1 (portable)** | `D:\Tools\Blender\blender-5.2.1-windows-x64\blender.exe` | `--background --python <script.py> -- <args>` |
| **Blender 5.2 (operator's)** | `C:\Program Files\Blender Foundation\Blender 5.2\blender.exe` | same, **but no add-ons** |
| **Cascadeur** | `C:\Program Files\Cascadeur\cascadeur.exe` | `--run-python-code` (auth via `cascadeur_auth.exe`) |
| **Rokoko Studio** | `C:\Program Files (x86)\Rokoko Electronics ApS\Rokoko Studio\Rokoko Studio.exe` | GUI; streams over its own driver |
| **Unreal 5.8** | `C:\Program Files\Epic Games\UE_5.8\Engine\Binaries\Win64\UnrealEditor.exe` | `-run=pythonscript` / commandlets |

### Blender — USE THE PORTABLE COPY. The add-ons are only there.

**Retarget extension v5.2.0** (KBS-DEV, GPL) at `portable/extensions/user_default/retarget/`, 158
operators, core `armature.retarget_*`. **Higgsfield add-on** at
`bl_ext.user_default.higgsfield_blender`. Working scripts: `Tools/blender_bakeoff/`, write-up
`research/BAKEOFF_BLENDER_RETARGET.md`.

**Five traps, already paid for — do not rediscover them:**

1. A RamsterZ FBX imports as **68 EMPTIES, not an armature**. Rebuild from `T_pose.fbx`, aim bones
   joint-to-child, bake through a constant per-bone offset.
2. "Bind to Active Armature" constrains the SELECTED rig to the ACTIVE one — the clip-carrying rig
   must be **active**.
3. From a script the bind needs the class default `current_m` set, and **the add-on's own bake makes
   no action while reporting FINISHED**. Use `nla.bake(visual_keying=True, clear_constraints=True)`.
4. Import Tripo GLBs with `bone_heuristic="TEMPERANCE"`. The default leaves arm bones sideways and
   leg bones pointing UP.
5. Blender 5 API: `Bone.select` is gone — use `bpy.ops.pose.select_all`.

**And the finding that makes this matter (C134, 2026-09-20):** the armbar contact defect was
**retargeting discarding 1.020 m X and 0.844 m Z of the attacker's hip travel** — trap 1 territory,
since a constant per-bone offset bake is exactly what drops root translation. Codex fixed it at the
runtime retarget source. Any future paired-clip contact problem should suspect root motion first.

### Cascadeur — ⚠️ A LIVE BILLING DEADLINE

**The Pro trial charges EUR 37.66 on 2026-09-27 unless it is unsubscribed.** That is the operator's
decision and it is not made yet. Cascadeur is physics-aware posing, which makes it the best-fit
untried route for a two-body HELD ground position — but **nobody should start a Cascadeur workflow
without the operator having settled the subscription question first.**

### Rokoko / markerless mocap

Rokoko Studio is installed. **Remocapp was recorded in an earlier session as installed and is NOT
on disk now** (searched Program Files, Program Files (x86), LocalAppData, AppData, ProgramData).
Mocap needs two people in front of a camera, so it is not an agent workflow regardless — it is an
operator session.

---

## WEB SERVICES — NOT INSTALLED, AND EACH NEEDS A ROUTE IN

**None of these is on disk. They are accounts, so the question is never "where is the exe" but "how
does an agent reach it without holding a secret".**

| service | what it does | status |
|---|---|---|
| **Higgsfield** | text-to-motion, image/video gen | **MCP server ADDED** — see below |
| **Meshy** | text/image → 3D mesh | no route configured |
| **Tripo AI** | text/image → 3D mesh | **used already** — the project's fighter GLBs are Tripo output |
| **Theia** | markerless mocap (TheiaMarkerless) | no route configured; commercial licence |
| **Harmony4D** | a Hugging Face **dataset**, not a tool | blocked, see below |

### Higgsfield — the MCP route is live, and the login is the operator's

```bash
codex mcp add higgsfield --url https://mcp.higgsfield.ai/mcp
```

**Already run.** Registered, enabled, and in `~/.codex/config.toml` as
`[mcp_servers.higgsfield]`. **Note the `https://`** — it was first added without a scheme and
Codex's log showed the exact failure:

```
ERROR rmcp::transport::worker: worker quit with fatal: Transport channel closed
Client(HttpRequest(HttpRequest("relative URL without a base")))
```

**Still outstanding and it is the operator's:** `codex mcp login higgsfield`. `codex mcp list`
reports **Auth: Unknown** until that is done.

**Why MCP is the right route:** Codex reported Higgsfield **unreachable from her `workspace-write`
sandbox** (no network) and correctly spent zero credits. An MCP server runs *outside* the sandbox,
so it goes around that wall.

**The limits, and they are hard.** ~923.9 credits. Text-to-motion is **0.1 credit per job whatever
its length**. **ONE ACTION PER JOB** — 24 of 30 multi-beat timelines froze. And **the grappling
question is already measured negative** (`HIGGSFIELD_MMA_PIPELINE_STUDY.md`): 8 of 8 two-fighter
generations came back as **ONE BODY**, 0 of 4 armbar prompts reached the ground, and
`compose_takedown.py` scored **0 of 36**. **Do not pay to re-run that.** The only untested residue
is whether a HELD static pose behaves differently from a dynamic entry — three jobs maximum, and
stop if the first three come back as one body.

### Meshy and Theia — the pattern, if the operator wants them

Both are HTTP services. If either publishes an MCP endpoint, the same one-liner applies and is the
clean route because it bypasses the sandbox:

```bash
codex mcp add <name> --url https://<their-mcp-host>/mcp
codex mcp login <name>
```

If they only offer a REST API, the key goes in an **environment variable at launch** and never into
a file:

```powershell
$env:MESHY_API_KEY = "<operator pastes here, never committed>"
```

**I have not configured either, because doing so needs a key and keys are the operator's.**

### Tripo AI — already used, and there is a licence gap

The project's rigged fighter GLBs are Tripo output and Blender trap 4 exists because of them. But
the asset manifest records **"Tripo licence: NOT RECORDED"**. That is a compliance gap on assets
already in the repo, and it is worth closing before anything ships.

### Harmony4D — a dataset, and it is blocked on a licence card

R144 line 4. It is a Hugging Face grappling dataset, not a tool to install. It lives or dies on
**the Hugging Face DATA licence card** (the code licence is not the data licence — that mistake
would sink it) and on whether COCO-WholeBody joints can be read **without** instantiating SMPL. Both
questions need `huggingface.co`, which every cloud session found blocked at CONNECT and which a PC
session can reach. **Not started.**

---

## HOW AN AGENT SHOULD REPORT TOOL ACCESS

**Check, then say — do not assume either way.** Codex's continuation 4 was told to report
reachability before doing anything and came back with exactly the right answer: *"Blender verified;
Higgsfield unreachable from the sandbox. Zero credits spent."* That one line saved a whole run from
being spent fighting a sandbox.

So any agent handed a tool here reports, in one line each:

1. can it **execute** the binary (`blender.exe --version` needs no network);
2. can it **write** where it needs to (assume `D:` is read-only to a sandboxed agent — write into
   the worktree or `$env:TEMP`);
3. does it have **network**, if the tool needs it;
4. and if a login is required that it does not have, **say so and move on**.
