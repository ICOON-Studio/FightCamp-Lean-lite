"""S409 HITREACT2 step 4: head travel after each stage of the conversion.

For the three most-played weak clips, identify WHERE in the conversion pipeline the head travel drops:
  STAGE 1 (source):    the raw FBX head travel, measured in Blender (tools/hit_react_raw.py)
  STAGE 2 (proportion): stage 1 scaled by (game hips-to-head / source hips-to-head)
                        - the head travel the game WOULD have if the only loss was body proportions
  STAGE 3 (game):      the actual game clip head travel, measured in Godot (tools/hit_react_probe.gd)

If stage 3 ~= stage 2: the loss is from skeleton proportions (the MetaHuman is shorter).
If stage 3 < stage 2: the conversion pipeline (rotation retarget, foot IK, smoothing) loses additional travel.

Usage:
  python tools/hit_react_steps.py --clips cross_v3,hook_v5,hook_v2_short \\
    --src-hips-head 0.80 --game-hips-head 0.737 \\
    --src-head 0.226 --game-head 0.111

Or with full data from the probe and raw output:
  python tools/hit_react_steps.py --from-data \\
    --raw "HITREACT_RAW ... head_m=0.2260 hips_to_head=0.800" \\
    --game "HITREACT clip ... head_m=0.1110 hips_to_head=0.737"
"""
import argparse
import re
import sys


def parse_raw_line(line):
    """Parse a HITREACT_RAW output line."""
    m = re.search(r"head_m=([0-9.]+)", line)
    h = float(m.group(1)) if m else 0.0
    m = re.search(r"hips_to_head=([0-9.]+)", line)
    hh = float(m.group(1)) if m else 0.0
    m = re.search(r"trunk_deg=([0-9.]+)", line)
    t = float(m.group(1)) if m else 0.0
    m = re.search(r"peak_head_f=(\d+)", line)
    pf = int(m.group(1)) if m else 0
    return {"head_m": h, "hips_to_head": hh, "trunk_deg": t, "peak_head_f": pf}


def parse_game_line(line):
    """Parse a HITREACT clip output line."""
    m = re.search(r"head_m=([0-9.]+)", line)
    h = float(m.group(1)) if m else 0.0
    m = re.search(r"hips_to_head=([0-9.]+)", line)
    hh = float(m.group(1)) if m else 0.0
    m = re.search(r"trunk_deg=([0-9.]+)", line)
    t = float(m.group(1)) if m else 0.0
    m = re.search(r"peak_head_f=(\d+)", line)
    pf = int(m.group(1)) if m else 0
    m = re.search(r"length_s=([0-9.]+)", line)
    ls = float(m.group(1)) if m else 0.0
    return {"head_m": h, "hips_to_head": hh, "trunk_deg": t, "peak_head_f": pf, "length_s": ls}


def analyze(clip_name, src, game):
    """Compute the three stages and identify where the drop occurs."""
    stage1 = src["head_m"]
    src_hh = src["hips_to_head"]
    game_hh = game["hips_to_head"]
    stage3 = game["head_m"]

    if src_hh > 0.001:
        proportion = game_hh / src_hh
    else:
        proportion = 1.0
    stage2 = stage1 * proportion

    ratio_12 = stage2 / stage1 if stage1 > 0.001 else 1.0
    ratio_23 = stage3 / stage2 if stage2 > 0.001 else 1.0
    ratio_13 = stage3 / stage1 if stage1 > 0.001 else 1.0

    if abs(ratio_23 - 1.0) < 0.05:
        drop_stage = "proportions (MetaHuman is shorter)"
    elif ratio_12 < ratio_23:
        drop_stage = "proportions (stage 2/1 = %.2f) + pipeline (stage 3/2 = %.2f)" % (ratio_12, ratio_23)
    else:
        drop_stage = "conversion pipeline (stage 3/2 = %.2f, proportions alone predict %.2f)" % (ratio_23, ratio_12)

    print(f"HITREACT_STEPS {clip_name}")
    print(f"  STAGE 1 (source):     head_m={stage1:.4f}  hips_to_head={src_hh:.3f}  peak_f={src['peak_head_f']}")
    print(f"  STAGE 2 (proportion): head_m={stage2:.4f}  ratio={proportion:.3f} (game/src height)")
    print(f"  STAGE 3 (game):       head_m={stage3:.4f}  hips_to_head={game_hh:.3f}  peak_f={game['peak_head_f']}")
    print(f"  TRUNK:  src={src['trunk_deg']:.1f} deg  game={game['trunk_deg']:.1f} deg  ratio={game['trunk_deg']/max(src['trunk_deg'],0.1):.2f}")
    print(f"  RATIO 1->2: {ratio_12:.2f}  2->3: {ratio_23:.2f}  1->3: {ratio_13:.2f}")
    print(f"  DROP AT: {drop_stage}")
    print()
    return {"stage1": stage1, "stage2": stage2, "stage3": stage3, "ratio_13": ratio_13, "drop": drop_stage}


CLIPS_DATA = {
    "cross_v3": {
        "src_file": "Box1_M3_Hit_By_Cross_V3.fbx",
        "pools": "cross (3 picks)",
    },
    "hook_v5": {
        "src_file": "Box1_M3_Hit_By_Hook_V5.fbx",
        "pools": "lead_hook, rear_hook (3 picks)",
    },
    "hook_v2_short": {
        "src_file": "Box1_M3_Hit_By_Hook_V2_Short.fbx",
        "pools": "lead_hook, lead_uppercut (2 picks)",
    },
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--raw", nargs="*", default=[], help="HITREACT_RAW output lines (one per clip)")
    ap.add_argument("--game", nargs="*", default=[], help="HITREACT clip output lines (one per clip)")
    ap.add_argument("--from-probe", action="store_true", help="read probe output from stdin")
    args = ap.parse_args()

    if args.from_probe:
        lines = sys.stdin.read().strip().split("\n")
        raw_lines = [l for l in lines if l.startswith("HITREACT_RAW ")]
        game_lines = [l for l in lines if l.startswith("HITREACT clip ")]
        if not raw_lines or not game_lines:
            print("HITREACT_STEPS: need both HITREACT_RAW and HITREACT clip lines on stdin")
            return 1
        for rl in raw_lines:
            name_match = re.search(r"HITREACT_RAW (\S+)", rl)
            if not name_match:
                continue
            fname = name_match.group(1)
            clip_key = None
            for k, v in CLIPS_DATA.items():
                if v["src_file"].replace(".fbx", "") in fname.replace(".fbx", ""):
                    clip_key = k
                    break
            if clip_key is None:
                continue
            src = parse_raw_line(rl)
            gl = None
            for g in game_lines:
                if clip_key.replace("_", " ") in g.lower() or f"pro_hit_by_{clip_key}" in g:
                    gl = g
                    break
            if gl is None:
                continue
            game = parse_game_line(gl)
            analyze(clip_key, src, game)
        return 0

    if args.raw and args.game:
        src = parse_raw_line(args.raw[0])
        game = parse_game_line(args.game[0])
        name_match = re.search(r"HITREACT_RAW (\S+)", args.raw[0])
        clip_name = name_match.group(1).replace(".fbx", "").replace("Box1_M3_Hit_By_", "").lower() if name_match else "clip"
        analyze(clip_name, src, game)
        return 0

    print("HITREACT_STEPS: usage:")
    print("  --raw 'HITREACT_RAW ...' --game 'HITREACT clip ...'  (single clip)")
    print("  --from-probe  (reads combined raw+game output from stdin)")
    return 0


if __name__ == "__main__":
    sys.exit(main() or 0)
