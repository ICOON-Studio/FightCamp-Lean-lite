"""CASCTEST1 pictures, drawn from the joint dumps Cascadeur's Python gave (measure.py) - NOT a viewport capture:
the app's window cannot be grabbed on the hidden desktop (PrintWindow returns a blank frame), so the take is drawn
as a skeleton. Grey = the take as bought, red = after AutoPhysics. python plot.py <out_dir>"""
import json, os, sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from analyse import measure, flat, ang
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = sys.argv[1]
os.makedirs(OUT, exist_ok=True)
BONES = [('Hips', 'Spine'), ('Spine', 'Spine1'), ('Spine1', 'Spine2'), ('Spine2', 'Neck'), ('Neck', 'Head'),
         ('Spine2', 'LeftArm'), ('LeftArm', 'LeftForeArm'), ('LeftForeArm', 'LeftHand'),
         ('Spine2', 'RightArm'), ('RightArm', 'RightForeArm'), ('RightForeArm', 'RightHand'),
         ('Hips', 'LeftUpLeg'), ('LeftUpLeg', 'LeftLeg'), ('LeftLeg', 'LeftFoot'), ('LeftFoot', 'LeftToeBase'), ('LeftToeBase', 'LeftToeEnd'),
         ('Hips', 'RightUpLeg'), ('RightUpLeg', 'RightLeg'), ('RightLeg', 'RightFoot'), ('RightFoot', 'RightToeBase'), ('RightToeBase', 'RightToeEnd')]
REAR = {'RightUpLeg', 'RightLeg', 'RightFoot', 'RightToeBase', 'RightToeEnd'}
Rb, Jb = measure('before'); Ra, Ja = measure('after')
c = Rb['contact_frame']
line = flat(Jb['RightHand'][c] - Jb['RightArm'][c]); side = np.cross([0, 1, 0], line)

def draw(ax, J, f, axis, col, lw, label):
    for a, b in BONES:
        rear = a in REAR and b in REAR
        ax.plot([np.dot(J[a][f], axis), np.dot(J[b][f], axis)], [J[a][f][1], J[b][f][1]], color=col, lw=lw * (1.8 if rear else 1),
                solid_capstyle='round', label=label if (a, b) == BONES[0] else None)
    ax.set_aspect('equal'); ax.axhline(0, color='#888', lw=0.8); ax.set_ylim(-5, 190)

for name, frames in (('1_guard_prep_contact', [0, max(c - 4, 0), c]), ('2_contact_to_recover', [c, c + 3, c + 6])):
    fig, axs = plt.subplots(2, 3, figsize=(19.2, 10.8), dpi=100)
    for i, f in enumerate(frames):
        for r, (axis, view) in enumerate(((line, 'side view (punch goes right)'), (side, 'front view (down the punch line)'))):
            ax = axs[r][i]
            draw(ax, Jb, f, axis, '#9a9a9a', 3.0, 'as bought')
            draw(ax, Ja, f, axis, '#d62728', 1.8, 'after AutoPhysics')
            kb = ang(Jb['RightUpLeg'][f], Jb['RightLeg'][f], Jb['RightFoot'][f]); ka = ang(Ja['RightUpLeg'][f], Ja['RightLeg'][f], Ja['RightFoot'][f])
            ax.set_title('frame %d%s - %s\nrear knee %.0f deg as bought, %.0f after (thick = rear leg)' % (f, ' = CONTACT' if f == c else '', view, kb, ka), fontsize=11)
            if i == 0 and r == 0: ax.legend(loc='upper left')
    fig.suptitle('CASCTEST1 - Box1_M3_Right_Cross in Cascadeur (free tier): as bought vs after AutoPhysics. Drawn from joint dumps, cm.', fontsize=14)
    fig.tight_layout(); fig.savefig(os.path.join(OUT, name + '.png')); plt.close(fig)

n = Rb['frames']; t = np.arange(n)
fig, axs = plt.subplots(2, 2, figsize=(19.2, 10.8), dpi=100)
def curve(ax, fn, title, ref=None):
    ax.plot(t, [fn(Jb, f) for f in t], color='#9a9a9a', lw=3, label='as bought')
    ax.plot(t, [fn(Ja, f) for f in t], color='#d62728', lw=1.8, label='after AutoPhysics')
    ax.axvline(c, color='k', ls=':'); ax.set_title(title); ax.set_xlabel('frame (contact = dotted)')
    if ref is not None: ax.axhline(ref[0], color='#2ca02c', ls='--', label=ref[1])
    ax.legend()
curve(axs[0][0], lambda J, f: ang(J['RightUpLeg'][f], J['RightLeg'][f], J['RightFoot'][f]), 'rear knee angle, deg (180 = straight)', (143, 'study: 143 at the impact (Dinu & Louis 2020)'))
curve(axs[0][1], lambda J, f: float(np.dot(J['Hips'][f] - J['Hips'][0], line)), 'hips forward along the punch line, cm', (27.8, 'study: 27.8 cm by the impact (Cheraghi 2014)'))
curve(axs[1][0], lambda J, f: ang(J['RightLeg'][f], J['RightFoot'][f], J['RightToeBase'][f]) - ang(J['RightLeg'][0], J['RightFoot'][0], J['RightToeBase'][0]), 'rear ankle extension from the guard, deg', (12, 'study: ~12 deg (Cheraghi 2014)'))
curve(axs[1][1], lambda J, f: float(np.linalg.norm(J['RightHand'][f] - Jb['RightHand'][f])), 'rear glove moved by AutoPhysics, cm (grey = 0)')
fig.suptitle('CASCTEST1 - the drive from the floor: as bought vs after AutoPhysics', fontsize=14)
fig.tight_layout(); fig.savefig(os.path.join(OUT, '3_curves.png')); plt.close(fig)
print('wrote 3 pictures to', OUT)
