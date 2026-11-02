"""MH2's mesh pipeline, retaining Epic's fitted Creator outfit instead of trunks.

Blender --background --python staff1_glb.py -- export game_textures output config
"""
import pathlib

source = pathlib.Path(__file__).with_name('mh2_glb.py').read_text()
source = source.replace('assert hair_reference in ("MH_Groom_Head", "SKM_Groom_Head_Legacy02")',
    'assert hair_reference in ("MH_Groom_Head", "SKM_Groom_Head_Legacy01", "SKM_Groom_Head_Legacy02")')
source = source.replace('fit(hair, lhead if hair_reference == "SKM_Groom_Head_Legacy02" else ghead, "hair")',
    '''if hair_reference == "SKM_Groom_Head_Legacy01":
        legacy = imp("groom/SKM_Groom_Head_Legacy01.fbx")
        href = next(o for o in legacy if o.type == 'MESH')
    else:
        href = lhead if hair_reference == "SKM_Groom_Head_Legacy02" else ghead
    fit(hair, href, "hair")''')
source = source.replace('mesh_objects = [body, face, *cards_objects]', '''
outfit_objects = imp('Outfit.fbx')
outfit_meshes = [o for o in outfit_objects if o.type == 'MESH']
lods = [o for o in outfit_meshes if o.name.endswith('_LOD1')]
if not lods:
    lods = [o for o in outfit_meshes if o.name.endswith('_LOD0')]
if not lods:
    assert len(outfit_meshes) == 1, [o.name for o in outfit_meshes]
    lods = outfit_meshes
garment = lods[0]
print('STAFF1 outfit', garment.name, len(garment.data.vertices), [m.name if m else '' for m in garment.data.materials])
print('STAFF1 outfit skin groups', len(garment.vertex_groups), [g.name for g in garment.vertex_groups][:12])
# Creator Core Data preview intentionally skips garment weight transfer when
# HasFaceDNA() is false (MetaHumanDefaultEditorPipelineBase.cpp). Transfer the
# existing body skin over the fitted garment surface; do not remodel clothing.
if not garment.vertex_groups:
    from mathutils.geometry import barycentric_transform
    body.data.calc_loop_triangles()
    triangles = [tuple(t.vertices) for t in body.data.loop_triangles]
    verts = [body.matrix_world @ v.co for v in body.data.vertices]
    surface = bvhtree.BVHTree.FromPolygons(verts, triangles, all_triangles=True)
    groups = {g.index: garment.vertex_groups.new(name=g.name) for g in body.vertex_groups}
    distances = []
    for vertex in garment.data.vertices:
        loc, normal, index, distance = surface.find_nearest(garment.matrix_world @ vertex.co)
        assert index is not None
        tri = triangles[index]
        bary = barycentric_transform(loc, *(verts[i] for i in tri), Vector((1,0,0)), Vector((0,1,0)), Vector((0,0,1)))
        weights = {}
        for vi, factor in zip(tri, bary):
            for g in body.data.vertices[vi].groups:
                weights[g.group] = weights.get(g.group, 0) + max(0, factor) * g.weight
        weights = sorted(weights.items(), key=lambda p: p[1], reverse=True)[:4]
        total = sum(w for _, w in weights)
        assert total > 0, 'Unweighted garment vertex'
        for group, weight in weights:
            groups[group].add([vertex.index], weight / total, 'REPLACE')
        distances.append(distance)
    print('STAFF1 transferred skin', len(distances), 'vertices; max surface distance m', max(distances))
assert len(garment.vertex_groups) > 0, 'Creator outfit has no skin weights'
# Hide the body surface enclosed by the fitted Creator garment. This is a
# clothing coverage mask, not a replacement garment mesh: retaining hidden
# skin makes small differences in the transferred weights show through cuffs.
garment.data.calc_loop_triangles()
cloth_vertices = [garment.matrix_world @ v.co for v in garment.data.vertices]
cloth_triangles = [tuple(t.vertices) for t in garment.data.loop_triangles]
shirt_points = [cloth_vertices[i] for p in garment.data.polygons
    if 'shirt' in garment.data.materials[p.material_index].name.lower() for i in p.vertices]
shorts_points = [cloth_vertices[i] for p in garment.data.polygons
    if 'shirt' not in garment.data.materials[p.material_index].name.lower() for i in p.vertices]
assert shirt_points and shorts_points
hem = min(p.z for p in shorts_points) + 0.05
cuff = max(abs(p.x) for p in shirt_points) - 0.05
collar = max(p.z for p in shirt_points) - 0.025
def welded(index):
    return tuple(round(v, 5) for v in cloth_vertices[index])
edge_counts = collections.Counter(tuple(sorted((welded(a), welded(b))))
    for tri in cloth_triangles for a, b in zip(tri, tri[1:] + tri[:1]))
cloth_surface = bvhtree.BVHTree.FromPolygons(
    cloth_vertices, cloth_triangles, all_triangles=True)
def covered(point):
    # Preserve an overlap of skin under every open edge. The garment has
    # thickness, so its cuff/hem edges may be topologically closed even after
    # welding and must not be mistaken for a fully enclosing surface.
    if point.z <= hem or abs(point.x) >= cuff or point.z >= collar:
        return False
    loc, normal, index, distance = cloth_surface.find_nearest(point)
    if index is None or distance >= 0.16:
        return False
    # A closest point on an open cuff/collar/hem cannot establish coverage.
    # Include intersections as well as enclosed skin: the fitted preview may
    # already penetrate the body slightly before animation.
    tri = cloth_triangles[index]
    for a, b in zip(tri, tri[1:] + tri[:1]):
        if edge_counts[tuple(sorted((welded(a), welded(b))))] != 1:
            continue
        va, vb = cloth_vertices[a], cloth_vertices[b]
        delta = vb - va
        along = max(0, min(1, (loc - va).dot(delta) / max(delta.length_squared, 1e-12)))
        if (loc - (va + delta * along)).length < 0.002:
            return False
    return (point - loc).dot(normal) < -0.0001 or distance < 0.035
masked = []
for polygon in body.data.polygons:
    points = [body.matrix_world @ body.data.vertices[i].co for i in polygon.vertices]
    if all(covered(point) for point in points):
        masked.append(polygon.index)
assert 0 < len(masked) < len(body.data.polygons) * 0.75, ('Unexpected clothing mask', len(masked))
bm = bmesh.new()
bm.from_mesh(body.data)
bm.faces.ensure_lookup_table()
bmesh.ops.delete(bm, geom=[bm.faces[i] for i in masked], context='FACES')
bm.to_mesh(body.data)
bm.free()
print('STAFF1 hidden body polygons', len(masked))
mesh_objects = [body, face, garment, *cards_objects]
''')
begin = source.index('trunks = mat(')
end = source.index('remap =', begin)
source = source[:begin] + '''
# Garment topology and skinning are Epic's exported fitted outfit. Only its
# surface colour changes by role; no handmade or fighter-trunk clothing.
shirt_color = tuple(CFG.get('shirt_color', [0.12, 0.14, 0.17, 1]))
pants_color = tuple(CFG.get('pants_color', [0.06, 0.07, 0.09, 1]))
garment_slots = [m.name.lower() if m else '' for m in garment.data.materials]
garment_indices = [p.material_index for p in garment.data.polygons]
garment.data.materials.clear()
garment.data.materials.append(mat('Staff_Shirt', color=shirt_color, rough=0.88))
garment.data.materials.append(mat('Staff_Shorts', color=pants_color, rough=0.9))
for polygon, original_index in zip(garment.data.polygons, garment_indices):
    polygon.material_index = 0 if 'shirt' in garment_slots[original_index] else 1
garment.name = 'Staff_CreatorOutfit'
''' + source[end:]
source = source.replace('6_000_000', '8_000_000').replace('MH2 asset exceeds 6 MB', 'STAFF1 asset exceeds 8 MB')
exec(compile(source, __file__, 'exec'))
