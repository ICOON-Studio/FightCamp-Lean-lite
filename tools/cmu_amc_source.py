"""cmu_amc_source.py - S381 OWNED MOCAP: a CMU ASF/AMC trial -> the motion JSON tools/owned_mocap_bake.gd retargets.

The CMU Graphics Lab database ships ASF (skeleton) + AMC (frames) - no FBX/BVH. This reads both (the conventions C149
settled the hard way, see ops/research/C149_CMU_SOURCE.md CORRECTION): a bone's world rotation relative to the ASF rest
pose is  W_b = W_parent @ C_b @ M_b @ C_b^-1,  C_b = euler(axis) and M_b = euler(the frame's rx, ry, rz), each euler
composed Rz @ Ry @ Rx (X applied first);  tip(b) = tip(parent) + W_b @ direction_b * length_b;  the root's rotation is
euler(RX, RY, RZ) and its position the frame's TX TY TZ. Units -> metres with 0.056444 (CMU's 0.45 length unit, inches).

Output (one JSON per take, frames resampled from 120 fps to 30: S383c each output frame is the triangle-weighted mean of
the 7 source frames around it, an anti-alias low-pass; aa=0 = the old every-4th-frame pick):
  {"fps": 30, "source": "CMU 14_01", "rest": {joint: [x,y,z]}, "frames": [{"D": {bone: [x,y,z,w]}, "P": {joint: [x,y,z]}}]}
  D = the bone's world rotation relative to its rest (quaternion), P = world joint positions (Hips, feet, toes).
Bones are named as our boxer names them (MHRig UE5_TO_OURS values), so the bake needs no CMU knowledge.
    python -I tools/cmu_amc_source.py <subject.asf> <trial.amc> <out.json> [t0=<s>] [t1=<s>] [src_fps=120] [aa=1]
"""
import json
import math
import sys

M_PER_UNIT = 0.056444

# Our bone <- the ASF segment whose rotation drives it, and the ASF joint where it starts (a segment starts at its
# parent's tip; "root" = the root position).
BONES = {
    "Hips": "root", "Spine": "lowerback", "Chest": "upperback", "UpperChest": "thorax", "Neck": "lowerneck",
    "Head": "head",
    "LeftShoulder": "lclavicle", "LeftUpperArm": "lhumerus", "LeftLowerArm": "lradius", "LeftHand": "lhand",
    "RightShoulder": "rclavicle", "RightUpperArm": "rhumerus", "RightLowerArm": "rradius", "RightHand": "rhand",
    "LeftUpperLeg": "lfemur", "LeftLowerLeg": "ltibia", "LeftFoot": "lfoot", "LeftToes": "ltoes",
    "RightUpperLeg": "rfemur", "RightLowerLeg": "rtibia", "RightFoot": "rfoot", "RightToes": "rtoes",
}
# Joint positions written to "rest" (aim targets) - our joint name -> ASF segment it is the START of, or "<seg>.tip".
JOINTS = {
    "Hips": "root", "Spine": "lowerback", "Chest": "upperback", "UpperChest": "thorax", "Neck": "lowerneck",
    "Head": "head", "HeadTop": "head.tip",
    "LeftShoulder": "lclavicle", "LeftUpperArm": "lhumerus", "LeftLowerArm": "lradius", "LeftHand": "lhand",
    "LeftHandEnd": "lhand.tip",
    "RightShoulder": "rclavicle", "RightUpperArm": "rhumerus", "RightLowerArm": "rradius", "RightHand": "rhand",
    "RightHandEnd": "rhand.tip",
    "LeftUpperLeg": "lfemur", "LeftLowerLeg": "ltibia", "LeftFoot": "lfoot", "LeftToes": "ltoes", "LeftToesEnd": "ltoes.tip",
    "RightUpperLeg": "rfemur", "RightLowerLeg": "rtibia", "RightFoot": "rfoot", "RightToes": "rtoes",
    "RightToesEnd": "rtoes.tip",
}
TRACKED = ["Hips", "LeftFoot", "RightFoot", "LeftToes", "RightToes", "LeftToesEnd", "RightToesEnd", "Head",
           "LeftHand", "RightHand"]


def rx(a):
    c, s = math.cos(a), math.sin(a)
    return [[1, 0, 0], [0, c, -s], [0, s, c]]


def ry(a):
    c, s = math.cos(a), math.sin(a)
    return [[c, 0, s], [0, 1, 0], [-s, 0, c]]


def rz(a):
    c, s = math.cos(a), math.sin(a)
    return [[c, -s, 0], [s, c, 0], [0, 0, 1]]


def mm(a, b):
    return [[sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]


def mv(a, v):
    return [sum(a[i][k] * v[k] for k in range(3)) for i in range(3)]


def tr(a):
    return [[a[j][i] for j in range(3)] for i in range(3)]


def euler(x, y, z):
    """Degrees, X applied first: Rz @ Ry @ Rx."""
    return mm(rz(math.radians(z)), mm(ry(math.radians(y)), rx(math.radians(x))))


def quat(m):
    t = m[0][0] + m[1][1] + m[2][2]
    if t > 0:
        s = math.sqrt(t + 1.0) * 2
        w, x, y, z = 0.25 * s, (m[2][1] - m[1][2]) / s, (m[0][2] - m[2][0]) / s, (m[1][0] - m[0][1]) / s
    elif m[0][0] > m[1][1] and m[0][0] > m[2][2]:
        s = math.sqrt(1.0 + m[0][0] - m[1][1] - m[2][2]) * 2
        w, x, y, z = (m[2][1] - m[1][2]) / s, 0.25 * s, (m[0][1] + m[1][0]) / s, (m[0][2] + m[2][0]) / s
    elif m[1][1] > m[2][2]:
        s = math.sqrt(1.0 + m[1][1] - m[0][0] - m[2][2]) * 2
        w, x, y, z = (m[0][2] - m[2][0]) / s, (m[0][1] + m[1][0]) / s, 0.25 * s, (m[1][2] + m[2][1]) / s
    else:
        s = math.sqrt(1.0 + m[2][2] - m[0][0] - m[1][1]) * 2
        w, x, y, z = (m[1][0] - m[0][1]) / s, (m[0][2] + m[2][0]) / s, (m[1][2] + m[2][1]) / s, 0.25 * s
    return [round(x, 6), round(y, 6), round(z, 6), round(w, 6)]


def read_asf(path):
    bones, parent, order = {}, {}, []
    lines = open(path, encoding="latin-1").read().splitlines()
    i, section = 0, ""
    cur = None
    while i < len(lines):
        ln = lines[i].strip()
        i += 1
        if ln.startswith(":"):
            section = ln.split()[0]
            continue
        if section == ":bonedata":
            if ln == "begin":
                cur = {"dof": []}
            elif ln == "end":
                bones[cur["name"]] = cur
                order.append(cur["name"])
            elif cur is not None and ln:
                p = ln.split()
                if p[0] == "name":
                    cur["name"] = p[1]
                elif p[0] == "direction":
                    cur["direction"] = [float(v) for v in p[1:4]]
                elif p[0] == "length":
                    cur["length"] = float(p[1])
                elif p[0] == "axis":
                    cur["axis"] = [float(v) for v in p[1:4]]
                elif p[0] == "dof":
                    cur["dof"] = p[1:]
        elif section == ":hierarchy" and ln and ln not in ("begin", "end"):
            p = ln.split()
            for c in p[1:]:
                parent[c] = p[0]
    for b in bones.values():
        b["C"] = euler(*b["axis"])
        b["Ci"] = tr(b["C"])
    return bones, parent, order


def read_amc(path):
    frames, cur = [], None
    for ln in open(path, encoding="latin-1"):
        ln = ln.strip()
        if not ln or ln.startswith("#") or ln.startswith(":"):
            continue
        p = ln.split()
        if p[0].isdigit() and len(p) == 1:
            cur = {}
            frames.append(cur)
        elif cur is not None:
            cur[p[0]] = [float(v) for v in p[1:]]
    return frames


def pose(bones, parent, order, fr):
    """World rotation (relative to rest) and start/tip of every segment for one frame (fr=None = the rest pose)."""
    W, start, tip = {}, {}, {}
    if fr is None:
        W["root"] = euler(0, 0, 0)
        tip["root"] = [0.0, 0.0, 0.0]
    else:
        r = fr["root"]
        W["root"] = euler(r[3], r[4], r[5])
        tip["root"] = [r[0], r[1], r[2]]
    start["root"] = tip["root"]
    pending = list(order)
    while pending:
        nxt = []
        for n in pending:
            par = parent.get(n)
            if par not in W:
                nxt.append(n)
                continue
            b = bones[n]
            ang = {"rx": 0.0, "ry": 0.0, "rz": 0.0}
            if fr is not None and n in fr:
                for d, v in zip(b["dof"], fr[n]):
                    ang[d] = v
            Mloc = euler(ang["rx"], ang["ry"], ang["rz"])
            W[n] = mm(W[par], mm(b["C"], mm(Mloc, b["Ci"])))
            start[n] = tip[par]
            d = mv(W[n], b["direction"])
            tip[n] = [start[n][k] + d[k] * b["length"] for k in range(3)]
        if len(nxt) == len(pending):
            raise SystemExit("ASF hierarchy has unreachable bones: %s" % nxt)
        pending = nxt
    return W, start, tip


def joint_pos(start, tip, spec):
    if spec.endswith(".tip"):
        v = tip[spec[:-4]]
    else:
        v = start[spec]
    return [round(c * M_PER_UNIT, 5) for c in v]


def main():
    a = sys.argv[1:]
    asf, amc, out = a[0], a[1], a[2]
    opt = dict(x.split("=", 1) for x in a[3:])
    src_fps = float(opt.get("src_fps", 120))
    step = int(round(src_fps / 30.0))
    bones, parent, order = read_asf(asf)
    frames = read_amc(amc)
    t0 = float(opt.get("t0", 0.0))
    t1 = float(opt.get("t1", len(frames) / src_fps))
    i0, i1 = int(round(t0 * src_fps)), min(len(frames), int(round(t1 * src_fps)))
    _, s0, p0 = pose(bones, parent, order, None)
    rest = {j: joint_pos(s0, p0, spec) for j, spec in JOINTS.items()}
    # S383c anti-alias: each 30 fps frame is the triangle-weighted mean of the source frames around it
    # ([1 2 3 4 3 2 1] / 16 at 120 fps: a 2.5 Hz bounce keeps 98 %, 15 Hz and up - which would fold back into the 30 fps
    # clip as a shake - is cut to 43 % and less). aa=0 = the old every-4th-frame pick.
    aa = opt.get("aa", "1") != "0"
    half = step - 1 if aa else 0
    tri = [float(step - abs(k)) for k in range(-half, half + 1)]
    cache = {}

    def at(i):
        i = min(max(i, 0), len(frames) - 1)
        if i not in cache:
            W, s, t = pose(bones, parent, order, frames[i])
            cache[i] = ({ours: quat(W[seg]) for ours, seg in BONES.items()},
                        {j: joint_pos(s, t, JOINTS[j]) for j in TRACKED})
        return cache[i]

    outf = []
    for i in range(i0, i1, step):
        for old in [k for k in cache if k < i - step]:
            del cache[old]
        Dc, Pc = at(i)
        D = {b: [0.0, 0.0, 0.0, 0.0] for b in Dc}
        P = {j: [0.0, 0.0, 0.0] for j in Pc}
        for k, w in zip(range(-half, half + 1), tri):
            Dk, Pk = at(i + k)
            for b, q in Dk.items():
                sg = 1.0 if sum(q[c] * Dc[b][c] for c in range(4)) >= 0.0 else -1.0
                for c in range(4):
                    D[b][c] += w * sg * q[c]
            for j, v in Pk.items():
                for c in range(3):
                    P[j][c] += w * v[c]
        tw = sum(tri)
        for b, q in D.items():
            nq = math.sqrt(sum(c * c for c in q)) or 1.0
            D[b] = [round(c / nq, 6) for c in q]
        for j in P:
            P[j] = [round(c / tw, 5) for c in P[j]]
        outf.append({"D": D, "P": P})
    json.dump({"fps": 30, "source": "CMU " + amc.replace("\\", "/").split("/")[-1].split(".")[0],
               "t0": t0, "src_frames": len(frames), "src_fps": src_fps, "rest": rest, "frames": outf}, open(out, "w"))
    print("CMU_SOURCE %s frames %d (%.2f s at %g fps) -> %d at 30 fps -> %s" % (
        amc, len(frames), len(frames) / src_fps, src_fps, len(outf), out))


if __name__ == "__main__":
    main()
