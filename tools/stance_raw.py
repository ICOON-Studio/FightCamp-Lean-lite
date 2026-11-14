"""S472 probe: the source take's guard stance in the rig's terms (BoxerFootwork STANCE_LEN / STANCE_WID / REAR_YAW_DEG).
Front = the lead foot's toe line (the rig's LEAD_YAW_DEG 0 points the lead toes down the fight line).
Run: blender -b --factory-startup --python stance_raw.py -- <fbx> [start_frame]
"""
import math
import sys

import bpy
from mathutils import Vector


def bone(arm, name):
    for b in arm.pose.bones:
        if b.name.split(":")[-1].lower() == name.lower():
            return b
    return None


args = sys.argv[sys.argv.index("--") + 1:]
path = args[0]
start = int(args[1]) if len(args) > 1 else 30
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.fbx(filepath=path, automatic_bone_orientation=False)
arm = next(o for o in bpy.context.scene.objects if o.type == "ARMATURE")
act = arm.animation_data.action
f0, f1 = int(act.frame_range[0]), int(act.frame_range[1])
unit = 0.01 if max(arm.dimensions) > 20 else 1.0
names = {s: [bone(arm, s.capitalize() + n) for n in ["UpLeg", "Leg", "Foot", "ToeBase"]] for s in ["left", "right"]}
hipsb = bone(arm, "Hips")
rows = []
sc = bpy.context.scene
for fr in range(max(f0, start), f1 + 1):
    sc.frame_set(fr)
    mw = arm.matrix_world
    p = {s: [(mw @ b.head) * unit for b in v] for s, v in names.items()}
    for s in p:
        for i in range(4):
            p[s][i] = Vector((p[s][i].x, p[s][i].y, p[s][i].z))
    # lead = the foot further along the toes' mean direction
    toes = {s: (p[s][3] - p[s][2]) for s in p}
    for s in toes:
        toes[s].z = 0.0
    mean = (toes["left"].normalized() + toes["right"].normalized())
    lead = "left" if (p["left"][2] - p["right"][2]).dot(mean) > 0 else "right"
    rear = "right" if lead == "left" else "left"
    front = toes[lead].normalized()
    across = Vector((-front.y, front.x, 0.0))
    d = p[rear][3] - p[lead][3]   # rear ball - lead ball
    d.z = 0.0
    rf = toes[rear].normalized()
    yaw = math.degrees(math.atan2(front.cross(rf).z, front.dot(rf)))
    hip_h = ((mw @ hipsb.head) * unit).z - min(p["left"][3].z, p["right"][3].z)
    pelvis = p["left"][0] - p["right"][0]
    pelvis.z = 0.0
    pel_yaw = math.degrees(math.atan2(front.cross(pelvis).z, front.dot(pelvis)))
    # rear ankle relative to rear hip, across the fight line (+ = outward from her midline side)
    ra = (p[rear][2] - p[rear][0]).dot(across)
    leg = sum((p[s][1] - p[s][0]).length + (p[s][2] - p[s][1]).length for s in p) * 0.5   # S473: hip-knee + knee-ankle
    straight = {k: (p[k][2] - p[k][0]).length / ((p[k][1] - p[k][0]).length + (p[k][2] - p[k][1]).length) for k in p}
    rows.append((abs(d.dot(front)), abs(d.dot(across)), yaw, hip_h, pel_yaw, ra, lead, leg, straight[lead], straight[rear]))
n = len(rows)
avg = lambda k: sum(r[k] for r in rows) / n
print(f"STANCE_RAW {path.split('/')[-1]} frames={n} lead={rows[0][6]}")
print(f"STANCE_RAW ball_to_ball along={avg(0):.3f} across={avg(1):.3f}  (rig STANCE_LEN 0.50, STANCE_WID 0.32)")
print(f"STANCE_RAW rear_toe_yaw_vs_lead={avg(2):.1f} deg  (rig REAR_YAW_DEG -32 orthodox)")
print(f"STANCE_RAW hips_above_balls={avg(3):.3f}  pelvis_line_vs_front={avg(4):.1f} deg  rear_ankle_vs_hip_across={avg(5):.3f}")
# S472 part 2: boxer_footwork_test's valgus (shin tilt in the foot's frontal plane, + = knee on the hip's side), per leg
vals = {"left": [], "right": []}
for fr in range(max(f0, start), f1 + 1):
    sc.frame_set(fr)
    mw = arm.matrix_world
    for s, bs in names.items():
        a, k, an, toe = [(mw @ b.head) * unit for b in bs]
        foot = Vector((toe.x - an.x, toe.y - an.y, 0.0)).normalized()
        lat = foot.cross(Vector((0, 0, 1)))
        sh = k - an
        sx = sh.dot(lat) * (1 if (a - an).dot(lat) >= 0 else -1)
        vals[s].append(math.degrees(math.atan2(sx, sh.z)))
for s in vals:
    v = vals[s]
    print(f"STANCE_RAW valgus {s} ({'lead' if s == rows[0][6] else 'rear'}) mean={sum(v)/len(v):.1f} min={min(v):.1f} max={max(v):.1f} deg (rig test bar |8|)")
print(f"STANCE_RAW leg_len={avg(7):.3f} hips_over_leg={avg(3) / avg(7):.3f}")
print(f"STANCE_RAW leg_straight lead={avg(8):.3f} rear={avg(9):.3f}  (hip-ankle / leg length; 1 = straight)")
