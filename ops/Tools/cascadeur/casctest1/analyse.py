"""CASCTEST1: the brief's leg/hip/centre-of-mass numbers from the joint dumps measure.py wrote (cm, Y up).
    python ops/Tools/cascadeur/casctest1/analyse.py before rigged after
The fighter is orthodox: rear = Right leg, punch = RightHand. One ruler for every dump.
Definitions (the same words as docs/FP2POSE3_RESULT.md):
  contact      = the frame the rear glove is furthest from the rear shoulder
  prep         = the frame before contact where the rear knee is most bent (its deepest)
  knee angle   = hip-knee-ankle angle (180 = straight)
  knee vs toes = horizontal direction the knee points (knee off the hip-ankle line) against ankle->toe, deg; - = inside
  ankle ext    = change of the shin-to-foot angle (knee-ankle-toe), + = plantarflexion (heel lifts)
  heel         = ankle height above its guard height (the skeleton has no heel bone)
  hips forward = hip travel along the punch line (rear shoulder -> glove, flat) from frame 0
  CoM          = segment-mass centre (Dempster shares) and, when the rig has one, Cascadeur's own;
                 its place between the ankles: 0 = over the rear ankle, 1 = over the lead ankle
"""
import json, math, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))

def ang(a, b, c):
    u, v = a - b, c - b
    return math.degrees(math.acos(np.clip(np.dot(u, v) / (np.linalg.norm(u) * np.linalg.norm(v)), -1, 1)))

def flat(v):
    v = np.array([v[0], 0.0, v[2]]); n = np.linalg.norm(v)
    return v / n if n > 1e-6 else v

def signed(a, b):  # flat angle from a to b about +Y, deg
    return math.degrees(math.atan2(a[2] * b[0] - a[0] * b[2], a[0] * b[0] + a[2] * b[2]))

SEG = [('Head', 'Neck', 0.081), ('Neck', 'Hips', 0.497), ('RightArm', 'RightForeArm', 0.028), ('RightForeArm', 'RightHand', 0.022),
       ('LeftArm', 'LeftForeArm', 0.028), ('LeftForeArm', 'LeftHand', 0.022), ('RightUpLeg', 'RightLeg', 0.100),
       ('RightLeg', 'RightFoot', 0.0465), ('RightFoot', 'RightToeBase', 0.0145), ('LeftUpLeg', 'LeftLeg', 0.100),
       ('LeftLeg', 'LeftFoot', 0.0465), ('LeftFoot', 'LeftToeBase', 0.0145)]

def measure(tag):
    d = json.load(open(os.path.join(HERE, tag + '.json')))
    J = {k: np.array(v) for k, v in d['joints'].items()}
    n = d['frames']
    reach = [np.linalg.norm(J['RightHand'][f] - J['RightArm'][f]) for f in range(n)]
    contact = int(np.argmax(reach))
    knee = [ang(J['RightUpLeg'][f], J['RightLeg'][f], J['RightFoot'][f]) for f in range(n)]
    prep = int(np.argmin(knee[:contact + 1]))
    ankle = [ang(J['RightLeg'][f], J['RightFoot'][f], J['RightToeBase'][f]) for f in range(n)]
    line = flat(J['RightHand'][contact] - J['RightArm'][contact])
    def knee_vs_toes(f):
        h, k, a, t = J['RightUpLeg'][f], J['RightLeg'][f], J['RightFoot'][f], J['RightToeBase'][f]
        ax = (a - h) / np.linalg.norm(a - h)
        out = (k - h) - ax * np.dot(k - h, ax)
        v = signed(flat(t - a), flat(out))
        # orthodox right leg: inside = toward the lead (left) side; sign so that - = inside
        left = flat(J['LeftUpLeg'][f] - J['RightUpLeg'][f])
        side = np.dot(flat(out) - flat(t - a) * np.dot(flat(out), flat(t - a)), left)
        return -abs(v) if side > 0 else abs(v)
    def com(f):
        c = np.zeros(3); m = 0
        for a, b, w in SEG:
            c += w * (J[a][f] + J[b][f]) / 2; m += w
        return c / m
    def base(p, f):
        r, l = J['RightFoot'][f], J['LeftFoot'][f]
        ax = np.array([l[0] - r[0], 0, l[2] - r[2]])
        return float(np.dot(np.array([p[0] - r[0], 0, p[2] - r[2]]), ax) / np.dot(ax, ax))
    pelvis_fwd = lambda f: flat(np.cross(J['LeftUpLeg'][f] - J['RightUpLeg'][f], [0, 1, 0]))
    kd = lambda f: flat(J['RightLeg'][f] - (J['RightUpLeg'][f] + J['RightFoot'][f]) / 2)
    res = {
        'frames': n, 'prep_frame': prep, 'contact_frame': contact,
        'knee_at_guard': knee[0], 'knee_at_prep': knee[prep], 'knee_at_contact': knee[contact],
        'knee_prep_to_contact (+ = extends)': knee[contact] - knee[prep],
        'knee_guard_to_contact (+ = extends)': knee[contact] - knee[0],
        'knee_vs_toes_guard': knee_vs_toes(0), 'knee_vs_toes_contact': knee_vs_toes(contact),
        'knee_vs_pelvis_change_guard_to_contact': abs(signed(pelvis_fwd(contact), kd(contact)) - signed(pelvis_fwd(0), kd(0))),
        'ankle_ext_guard_to_contact': ankle[contact] - ankle[0], 'ankle_ext_prep_to_contact': ankle[contact] - ankle[prep],
        'heel_rise_cm (ankle height, guard to contact)': J['RightFoot'][contact][1] - J['RightFoot'][0][1],
        'rear_toe_height_contact': J['RightToeBase'][contact][1], 'rear_toe_height_guard': J['RightToeBase'][0][1],
        'foot_turn_guard_to_contact': abs(signed(flat(J['RightToeBase'][0] - J['RightFoot'][0]), flat(J['RightToeBase'][contact] - J['RightFoot'][contact]))),
        'hip_turn_guard_to_contact': abs(signed(pelvis_fwd(0), pelvis_fwd(contact))),
        'hips_forward_cm_by_contact': float(np.dot(J['Hips'][contact] - J['Hips'][0], line)),
        'hips_forward_cm_max': max(float(np.dot(J['Hips'][f] - J['Hips'][0], line)) for f in range(n)),
        'hips_drop_cm_at_contact': J['Hips'][0][1] - J['Hips'][contact][1],
        'com_between_ankles_guard': base(com(0), 0), 'com_between_ankles_contact': base(com(contact), contact),
        'com_forward_cm_by_contact': float(np.dot(com(contact) - com(0), line)),
        'rear_ankle_slide_cm_guard_to_contact': float(np.linalg.norm((J['RightFoot'][contact] - J['RightFoot'][0])[[0, 2]])),
        'lead_ankle_slide_cm_guard_to_contact': float(np.linalg.norm((J['LeftFoot'][contact] - J['LeftFoot'][0])[[0, 2]])),
        'stance_length_guard_cm': float(np.linalg.norm((J['LeftFoot'][0] - J['RightFoot'][0])[[0, 2]])),
        'glove_reach_contact_cm': reach[contact],
    }
    if 'com' in d:
        C = np.array(d['com'])
        res['casc_com_between_ankles_guard'] = base(C[0], 0); res['casc_com_between_ankles_contact'] = base(C[contact], contact)
        res['casc_com_forward_cm_by_contact'] = float(np.dot(C[contact] - C[0], line))
        res['casc_com_height_guard'] = float(C[0][1]); res['casc_com_height_contact'] = float(C[contact][1])
    return res, J

if __name__ == '__main__':
    tags = sys.argv[1:] or ['before', 'after']
    R = {}; JJ = {}
    for t in tags:
        R[t], JJ[t] = measure(t)
    keys = list(R[tags[0]].keys()) + [k for k in R[tags[-1]] if k not in R[tags[0]]]
    print('%-46s' % 'measure' + ''.join('%12s' % t for t in tags))
    for k in keys:
        print('%-46s' % k + ''.join(('%12.1f' % R[t][k]) if k in R[t] else '%12s' % '-' for t in tags))
    a, b = JJ[tags[0]], JJ[tags[-1]]
    print('\nlargest joint move %s -> %s (cm, any frame):' % (tags[0], tags[-1]))
    for k in sorted(a, key=lambda k: -np.max(np.linalg.norm(a[k] - b[k], axis=1)))[:10]:
        dd = np.linalg.norm(a[k] - b[k], axis=1)
        print('  %-14s max %.2f at frame %d, mean %.2f' % (k, dd.max(), int(dd.argmax()), dd.mean()))
    json.dump(R, open(os.path.join(HERE, 'numbers.json'), 'w'), indent=1)
