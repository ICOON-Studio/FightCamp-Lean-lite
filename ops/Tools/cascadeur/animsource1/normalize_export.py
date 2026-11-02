"""Repair Cascadeur GLB packaging only: units, alignment, original materials.

Bone names, hierarchy, local rests and all bone animation bytes stay unchanged.
Cascadeur's FBX armature root is 100x; restore its metre scale (including its
scale channel), keep the already-metre mesh positions and adjust inverse-bind linear
columns consistently. This is unit conversion, never motion retargeting.
"""
import copy
import hashlib
import json
import struct
import sys
from pathlib import Path
import numpy as np

work=Path(__file__).resolve().parent
repo=work.parents[2]
def read(path):
    b=path.read_bytes(); length=struct.unpack_from('<I',b,12)[0]
    return json.loads(b[20:20+length]),b[28+length:]

def normalize(move, output_dir=None):
    destination=Path(output_dir) if output_dir is not None else repo/'Godot/assets/anim/metahuman'
    destination.mkdir(parents=True, exist_ok=True)
    dst=destination/('mh_'+move+'.glb')
    raw=work/('_raw_'+move+'.glb')
    if not raw.exists(): raw.write_bytes(dst.read_bytes())
    d, binary=read(raw)
    source, source_bin=read(repo/'Godot/assets/models/metahuman/mh_boxer_01.glb')
    views=[bytearray(binary[v.get('byteOffset',0):v.get('byteOffset',0)+v['byteLength']]) for v in d['bufferViews']]
    root_idx=next(i for i,n in enumerate(d['nodes']) if n.get('name')=='MH_Boxer_01')
    assert np.allclose(d['nodes'][root_idx]['scale'],[100,100,100])
    d['nodes'][root_idx]['scale']=[1,1,1]
    def data(index):
        a=d['accessors'][index]
        assert a['componentType']==5126 and 'sparse' not in a
        count={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}[a['type']]
        v=d['bufferViews'][a['bufferView']]
        stride=v.get('byteStride',count*4)
        return np.ndarray((a['count'],count),dtype='<f4',buffer=views[a['bufferView']],offset=a.get('byteOffset',0),strides=(stride,4))
    for index in {s['inverseBindMatrices'] for s in d['skins'] if 'inverseBindMatrices' in s}:
        data(index)[:,:12]*=100
    # FBX mesh vertices remain in Blender Z-up coordinates despite Cascadeur
    # exporting identity mesh nodes. Bake the FBX object axis transform, which
    # the armature root already carries, into vertices and normals only.
    for mesh in d['meshes']:
        for semantic in ['POSITION','NORMAL']:
            for index in {p['attributes'][semantic] for p in mesh['primitives']}:
                values=data(index)
                old=values.copy()
                values[:,1]=old[:,2]
                values[:,2]=-old[:,1]
                if semantic=='POSITION':
                    d['accessors'][index]['min']=values.min(axis=0).tolist()
                    d['accessors'][index]['max']=values.max(axis=0).tolist()
    # FBX UVs use bottom-left texture coordinates; glTF uses top-left.
    for index in {p['attributes']['TEXCOORD_0'] for m in d['meshes'] for p in m['primitives'] if 'TEXCOORD_0' in p['attributes']}:
        values=data(index)
        values[:,1]=1-values[:,1]
    unchanged=[]
    for anim in d['animations']:
        anim['name']='boxing_'+move
        for channel in anim['channels']:
            idx=anim['samplers'][channel['sampler']]['output']
            values=data(idx)
            if channel['target']['node']==root_idx and channel['target']['path']=='scale':
                values[:]*=.01
            else:
                unchanged.append((idx,hashlib.sha256(values.tobytes()).hexdigest()))
    old_materials=d['materials']
    material_names={m['name']:i for i,m in enumerate(source['materials'])}
    for mesh in d['meshes']:
        for primitive in mesh['primitives']:
            if 'material' in primitive:
                primitive['material']=material_names[old_materials[primitive['material']]['name']]
    d['materials']=copy.deepcopy(source['materials'])
    d['textures']=copy.deepcopy(source.get('textures',[]))
    d['samplers']=copy.deepcopy(source.get('samplers',[]))
    d['images']=copy.deepcopy(source.get('images',[]))
    for img in d['images']:
        v=source['bufferViews'][img['bufferView']]
        payload=source_bin[v.get('byteOffset',0):v.get('byteOffset',0)+v['byteLength']]
        img['bufferView']=len(views)
        views.append(bytearray(payload))
        d['bufferViews'].append({'buffer':0,'byteLength':len(payload)})
    extra={i for i,n in enumerate(d['nodes']) if n.get('name')=='Icosphere'}
    for scene in d['scenes']:scene['nodes']=[i for i in scene['nodes'] if i not in extra]
    out=bytearray()
    for view,payload in zip(d['bufferViews'],views):
        out.extend(b'\0'*(-len(out)%4))
        view['byteOffset']=len(out);view['byteLength']=len(payload);out.extend(payload)
    out.extend(b'\0'*(-len(out)%4))
    d['buffers']=[{'byteLength':len(out)}]
    header=json.dumps(d,separators=(',',':')).encode();header+=b' '*(-len(header)%4)
    result=struct.pack('<III',0x46546c67,2,28+len(header)+len(out))+struct.pack('<II',len(header),0x4e4f534a)+header+struct.pack('<II',len(out),0x004e4942)+out
    dst.write_bytes(result)
    check,check_bin=read(dst)
    assert {check['nodes'][i]['name'] for s in check['skins'] for i in s['joints']} == {source['nodes'][i]['name'] for i in source['skins'][0]['joints']}
    for index,expected in unchanged:
        accessor=check['accessors'][index];view=check['bufferViews'][accessor['bufferView']]
        count={'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}[accessor['type']]
        values=np.ndarray((accessor['count'],count),dtype='<f4',buffer=check_bin,offset=view.get('byteOffset',0)+accessor.get('byteOffset',0),strides=(view.get('byteStride',count*4),4))
        assert hashlib.sha256(values.tobytes()).hexdigest()==expected, index
    joint_names={source['nodes'][i]['name'] for i in source['skins'][0]['joints']}
    def parents(doc):
        table={c:i for i,n in enumerate(doc['nodes']) for c in n.get('children',[])}
        return {n['name']:doc['nodes'][table[i]]['name'] if i in table and doc['nodes'][table[i]]['name'] in joint_names else None for i,n in enumerate(doc['nodes']) if n.get('name') in joint_names}
    assert parents(source)==parents(check), 'MetaHuman joint hierarchy changed'
    receipt={'move':move,'source_sha256':hashlib.sha256((repo/'Godot/assets/models/metahuman/mh_boxer_01.glb').read_bytes()).hexdigest(),'cascadeur_raw_sha256':hashlib.sha256(raw.read_bytes()).hexdigest(),'glb_sha256':hashlib.sha256(result).hexdigest(),'unchanged_animation_outputs':len(unchanged),'animation_output_hash':hashlib.sha256(json.dumps(unchanged).encode()).hexdigest(),'unit_conversion':'armature root scale /100, metre mesh vertices unchanged, IBM linear columns *100','mesh_packaging':'FBX Z-up to glTF Y-up, flip FBX UV V, restore exact source materials/textures, 4-byte buffer alignment','joint_set_count':341,'source_joint_hierarchy_unchanged':True,'retarget':False}
    (work/('receipt_'+move+'.json')).write_text(json.dumps(receipt,indent=2))
    print('NORMALIZED',move,len(result),'bytes',len(unchanged),'untouched animation outputs')

if __name__=='__main__':
    for move in sys.argv[1:]:normalize(move)
