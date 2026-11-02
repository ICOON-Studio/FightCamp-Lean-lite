"""Reuse Creator outfit/trunks exporters, respecting all binding reference heads."""
import json
from pathlib import Path
import sys

cfg=json.load(open(sys.argv[-1]))
tee=cfg['role']=='boxer' and cfg['sex']=='F' and not cfg.get('top')
path=Path(__file__).with_name('staff1_glb.py' if cfg['role']!='boxer' or tee else 'mh2_glb.py')
source=path.read_text()
# S299 (operator S298 "is that a human?"): the Creator tee had no body under it (hidden faces deleted), so any arm lift
# folded sleeve + chest into a lump. A woman boxer with `top` keeps her whole skin and wears an amateur singlet PAINTED
# on the body surface: every body face above the trunks that is not carried by an arm, the neck or the head goes to
# MH_Top. Fitted by construction (it IS the skin surface), sleeveless (arm holes where the upperarm takes over).
SINGLET = '''
top = mat("MH_Top", None, None, 0.85, TOP_COLOR)
body.data.materials.append(top)
top_slot = len(body.data.materials) - 1
vg_names = {g.index: g.name.lower() for g in body.vertex_groups}
def carried(vertex, parts):
    return sum(g.weight for g in vertex.groups if any(p in vg_names.get(g.group, '') for p in parts))
ARM = ('upperarm', 'lowerarm', 'hand', 'thumb', 'index', 'middle', 'ring', 'pinky')
OFF = ('neck', 'head')   # S299 still 1: the waist carries thigh weights, so leg names left a skin strip under the hem
n_top = 0
for p in body.data.polygons:
    if p.material_index != 0 or (mw @ p.center).z < TR_HI - 0.005:
        continue
    vs = [body.data.vertices[i] for i in p.vertices]
    arm_w = sum(carried(v, ARM) for v in vs) / len(vs)
    off_w = sum(carried(v, OFF) for v in vs) / len(vs)
    if arm_w < 0.45 and off_w < 0.3:
        p.material_index = top_slot; n_top += 1
print("MH1B02 singlet faces", n_top)
assert n_top > 200, "singlet mask too small"
# Ludo S299 kit verdict: a white waistband at the top of the trunks (MH_Trim, its own slot so the game can recolour it).
# Still 1 (S299): Ludo's 10 cm band on the men's trunks line covered the whole hip (read as white briefs) and one-face-row
# piping came out a saw-tooth on this mesh - so the women's trunks top sits at the natural waist, the band is 8 cm, no piping.
white = mat("MH_Trim", None, None, 0.65, (0.92, 0.92, 0.92, 1))
body.data.materials.append(white)
trim_slot = len(body.data.materials) - 1
BAND = 0.08 * CFG["body"]["height"] / 183.0
n_band = 0
for p in body.data.polygons:
    if p.material_index == 1 and (mw @ p.center).z >= TR_HI - BAND:
        p.material_index = trim_slot; n_band += 1
print("MH1B02 waistband faces", n_band)
'''
if cfg.get('top'):
    SINGLET = SINGLET.replace('TOP_COLOR', repr(tuple(cfg.get('top_color', [0.9, 0.9, 0.88, 1]))))
    source = source.replace('remap = {0: 0', SINGLET + 'remap = {0: 0', 1)
    # The women's trunks top at the natural waist (0.617 x height, the men's 0.585 sat on the hip).
    source = source.replace('1.07 * CFG["body"]["height"] / 183.0', '1.13 * CFG["body"]["height"] / 183.0', 1)
    # The waistband's lower edge is cut like the trunks' edges: a straight line, not a staircase of triangles.
    source = source.replace('for z in (TR_LO, TR_HI):', 'for z in (TR_LO, TR_HI, TR_HI - 0.08 * CFG["body"]["height"] / 183.0):', 1)
if tee:
    # Export Epic's tee intact; remove only the garment's shorts faces, leaving
    # the underlying body available for MH2's existing coloured trunks mask.
    boxer_source=Path(__file__).with_name('mh2_glb.py').read_text()
    trunks=boxer_source[boxer_source.index('trunks = mat('):boxer_source.index('remap =')]
    trunks=trunks.replace('(0.55, 0.05, 0.06, 1)',repr(tuple(cfg['trunks_color'])))
    remove_shorts="""
bm = bmesh.new(); bm.from_mesh(garment.data)
shorts_faces = [p for p in bm.faces if 'shirt' not in garment.data.materials[p.material_index].name.lower()]
bmesh.ops.delete(bm, geom=shorts_faces, context='FACES')
bm.to_mesh(garment.data); bm.free()
"""
    transforms=(
        "source=source.replace('if point.z <= hem or', 'if point.z <= min(p.z for p in shirt_points) + 0.03 or')\n"
        "source=source.replace('mesh_objects = [body, face, garment, *cards_objects]',"
        +repr(remove_shorts+"\nmesh_objects = [body, face, garment, *cards_objects]")+")\n"
        "source=source.replace('remap =',"+repr(trunks+'remap =')+")\n")
    source=source.replace("exec(compile(source, __file__, 'exec'))", transforms+"exec(compile(source, __file__, 'exec'))")
elif cfg['role']=='boxer':
    source=source.replace('assert hair_reference in ("MH_Groom_Head", "SKM_Groom_Head_Legacy02")',
                         'assert hair_reference in ("MH_Groom_Head", "SKM_Groom_Head_Legacy01", "SKM_Groom_Head_Legacy02")')
    source=source.replace('fit(hair, lhead if hair_reference == "SKM_Groom_Head_Legacy02" else ghead, "hair")',
                         'legacy = imp("groom/SKM_Groom_Head_Legacy01.fbx") if hair_reference == "SKM_Groom_Head_Legacy01" else []\n'
                         '    href = next(o for o in legacy if o.type == "MESH") if legacy else (lhead if hair_reference == "SKM_Groom_Head_Legacy02" else ghead)\n'
                         '    fit(hair, href, "hair")')
    source=source.replace('(0.55, 0.05, 0.06, 1)',repr(tuple(cfg['trunks_color'])))
source=source.replace('trunks = mat("MH_Trunks", None, None, 0.4,',
                      'trunks = mat("MH_Trunks", None, None, 0.85,')
exec(compile(source,str(path),'exec'),dict(globals(),__file__=str(path)))
