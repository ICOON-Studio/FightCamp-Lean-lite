#!/usr/bin/env bash
# Make a Claude Code CLOUD session able to do this project's work.
#
# Why (2026-09-13): a session started from the operator's phone lands on a
# Linux container with NO GODOT. That is not a missing nicety - check_scripts.py
# shells Godot --check-only, so even the PARSE GATE cannot run, and with it go
# every test, run_tests.py and the measure tools. The session can then only do
# the no-gate tier, and the first one that tried was told to do S1f and could
# not. godotengine.org is refused by the egress policy (403 on CONNECT), which
# is what makes this look impossible - but the GitHub release asset is allowed
# and is a 75 MB, ~2 second download.
#
# Idempotent and safe to run at the top of every session. On the operator's
# Windows PC it finds the real install and changes nothing.
#
#   bash Tools/cloud_setup.sh
set -u

VERSION="4.7.2-stable"
ASSET="Godot_v${VERSION}_linux.x86_64"
URL="https://github.com/godotengine/godot-builds/releases/download/${VERSION}/${ASSET}.zip"
DEST="/opt/godot"
EXE="${DEST}/godot"

have() { [ -x "$1" ] && "$1" --version >/dev/null 2>&1; }

# 1. An existing Godot always wins - the operator may have fixed the
#    environment already, and re-downloading over their install would hide it.
FOUND=""
for cand in "${GODOT_EXE:-}" "$EXE" "$(command -v godot 2>/dev/null)" "$(command -v godot4 2>/dev/null)"; do
  if [ -n "$cand" ] && have "$cand"; then FOUND="$cand"; break; fi
done

if [ -n "$FOUND" ]; then
  echo "godot: already here -> $FOUND ($("$FOUND" --version))"
else
  echo "godot: not on this box, fetching ${VERSION} from the GitHub release"
  mkdir -p "$DEST" || { echo "godot: cannot write $DEST"; exit 1; }
  if ! curl -fsSL --max-time 300 -o "${DEST}/godot.zip" "$URL"; then
    echo "godot: DOWNLOAD FAILED. The egress policy may have changed."
    echo "       Without Godot this session is research-tier only: no parse"
    echo "       gate, no tests, no measure tools. Say so in the report."
    exit 1
  fi
  unzip -oq "${DEST}/godot.zip" -d "$DEST" && rm -f "${DEST}/godot.zip"
  mv -f "${DEST}/${ASSET}" "$EXE" && chmod +x "$EXE"
  have "$EXE" || { echo "godot: unpacked but will not run"; exit 1; }
  FOUND="$EXE"
  echo "godot: installed -> $FOUND ($("$FOUND" --version))"
fi

# 2. Persist it. Claude Code starts each Bash call from the user's profile and
#    does NOT carry exports between calls, so an `export` here would be gone by
#    the next command - it has to live in the profile itself.
for profile in "$HOME/.bashrc" "$HOME/.profile"; do
  [ -f "$profile" ] || touch "$profile"
  if ! grep -q "^export GODOT_EXE=" "$profile" 2>/dev/null; then
    printf '\n# FightCamp: check_scripts.py and run_tests.py read this\nexport GODOT_EXE=%s\n' "$FOUND" >> "$profile"
  else
    sed -i "s|^export GODOT_EXE=.*|export GODOT_EXE=$FOUND|" "$profile"
  fi
done
echo "GODOT_EXE persisted in ~/.bashrc and ~/.profile -> $FOUND"

# 3. Say plainly what a shallow clone costs, rather than letting the session
#    discover it halfway through a git question.
if [ "$(git rev-parse --is-shallow-repository 2>/dev/null)" = "true" ]; then
  echo "clone: SHALLOW. Branch divergence is not knowable (the triage says so"
  echo "       itself now). \`git fetch --unshallow\` if you need history."
fi

# 3b. THE BINARIES, BEFORE ANYTHING IMPORTS THEM. R143 (2026-09-13) moved every
#     animation pack, vendor pack and raw original to Git LFS. A cloud container
#     has no git-lfs, so each of those files arrives as a ~131 byte POINTER -
#     and Godot imports a pointer as a corrupt asset, writing valid=false into
#     its TRACKED .import sidecar. That is 417 of them, and .git/info/exclude
#     cannot hide a tracked file, so every session had to revert them by hand
#     before staging.
#
#     So install git-lfs and materialise the pointers BEFORE step 4 imports
#     anything. It is 212 files and 0.11 GB - seconds, not a download to dread.
#     Everything here is best-effort: a container without apt, or a credential
#     that does not cover LFS, leaves the session exactly where it was before
#     (simulation/UI/data work fine, animation work impossible) rather than
#     failing the setup.
LFS_READY=0
if ! git lfs version >/dev/null 2>&1; then
  echo "lfs: git-lfs missing, installing"
  if command -v apt-get >/dev/null 2>&1; then
    (apt-get update -qq && apt-get install -y -qq git-lfs) >/dev/null 2>&1 || true
  fi
fi
if git lfs version >/dev/null 2>&1; then
  git lfs install --local >/dev/null 2>&1 || true
  if git lfs pull >/dev/null 2>&1; then
    LFS_READY=1
    echo "lfs: pointers materialised ($(git lfs ls-files 2>/dev/null | wc -l) files)"
  else
    echo 'lfs: git-lfs is here but `git lfs pull` FAILED - the credential may not'
    echo '     cover LFS. Every asset is still a pointer: do NOT commit .import'
    echo '     churn, and do no animation, clip or retarget work in this session.'
  fi
else
  echo "lfs: git-lfs NOT available and could not be installed - every LFS asset"
  echo "     is a 131-byte pointer. Godot marks them valid=false on import."
  echo "     NEVER commit .import churn. No animation/clip/retarget work here."
fi

# 4. Import the project ONCE. Without this the first headless test does the
#    importing itself, inline, and looks exactly like the parse-error hang the
#    rules warn about: smoke_test.gd sat for the full 600s timeout and was
#    killed. It is 1015 .import files over 423 MB and takes about ten seconds
#    up front. The operator's PC never pays it - its .godot/ already exists.
if [ ! -d Godot/.godot ]; then
  echo "project: no Godot/.godot - importing 1015 assets once (~10s)"
  "$FOUND" --headless --import --path Godot >/dev/null 2>&1
  if [ -d Godot/.godot ]; then
    echo "project: imported"
  else
    echo "project: IMPORT FAILED - expect the first test to hang, not fail"
  fi
else
  echo "project: Godot/.godot present, no import needed"
fi

# 5. Keep the import's churn out of everyone's way. Importing writes ~500 .uid
#    sidecars, ~373 .import sidecars for preview/research images whose sidecars
#    were never committed, and extracts ~36 textures out of the fighter GLBs.
#    None of it belongs in a commit. It goes in .git/info/exclude - LOCAL only,
#    never committed, and it cannot hide a TRACKED file, so a real edit to a
#    tracked .import still shows up. (Caveat: a genuinely new asset's sidecar
#    would also be hidden. `git status --ignored` if you add an asset here -
#    though with LFS unavailable, see below, you probably cannot.)
MARK="# FightCamp cloud session: Godot import churn"
EXCLUDE=".git/info/exclude"
if [ -d .git ] && ! grep -qF "$MARK" "$EXCLUDE" 2>/dev/null; then
  {
    printf '\n%s\n' "$MARK"
    printf '%s\n' '*.uid' '*.import'
    printf '%s\n' 'Godot/assets/models/fighters/*_Color_*.jpg'
    printf '%s\n' 'Godot/assets/models/fighters/*_NormalGL_*.jpg'
    printf '%s\n' 'Godot/assets/models/fighters/*_ORM_*.jpg'
    # S167: the staff MetaHuman GLBs (STAFF1, not yet committed with their textures) extract 28 more on import.
    printf '%s\n' 'Godot/assets/models/metahuman/mh_staff_*_mh*_*'
  } >> "$EXCLUDE"
  echo "churn: import sidecars excluded locally (.git/info/exclude)"
fi

# 6. THE BINARIES ARE NOT HERE. R143 (2026-09-13) moved every animation pack,
#    vendor pack and raw original to Git LFS, and this container has no git-lfs,
#    so each of those files is a ~131 byte POINTER. Godot imports a pointer as a
#    corrupt asset and writes valid=false into its .import - which is why the
#    churn above must never be committed: it would mark 417 assets invalid in
#    the operator's project. Simulation, UI and data work are unaffected;
#    animation, retarget and clip work CANNOT be done in a cloud session.
if [ "${LFS_READY:-0}" = "1" ]; then
  echo 'LFS: real binaries on disk - the import above wrote VALID sidecars, so'
  echo '     `git status` should be clean. Animation and clip work are possible.'
else
  echo "LFS: assets are still pointers (see the lfs line above). Godot marked"
  echo "     them valid=false on import. NEVER commit .import churn, and send"
  echo "     animation, clip and retarget work to the operator's PC."
fi

echo "cloud_setup: ready. Parse gate: python Godot/tools/check_scripts.py <file.gd>"
