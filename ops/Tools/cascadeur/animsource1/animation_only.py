"""Drop render payloads, retaining the native skeleton and exact animation bytes."""
import copy
import hashlib
import json
import struct
from pathlib import Path
from normalize_export import read


def strip(path, max_bytes=600*1024):
    """max_bytes: the 21-frame punches stay under 600 KB; a 240-frame loop (PADPAIR1) passes its own cap."""
    path = Path(path)
    doc, binary = read(path)
    keep = set()
    for skin in doc['skins']:
        keep.update(skin['joints'])
        if 'skeleton' in skin:
            keep.add(skin['skeleton'])
    for animation in doc['animations']:
        keep.update(c['target']['node'] for c in animation['channels'])
    parents = {c: i for i, n in enumerate(doc['nodes']) for c in n.get('children', [])}
    for node in list(keep):
        while node in parents:
            node = parents[node]
            keep.add(node)
    nodes = sorted(keep)
    mapping = {old: new for new, old in enumerate(nodes)}
    result = {'asset': doc['asset'], 'scene': 0, 'scenes': [{'nodes': [mapping[n] for n in nodes if n not in parents]}],
              'nodes': [], 'skins': copy.deepcopy(doc['skins']), 'animations': copy.deepcopy(doc['animations']),
              'accessors': [], 'bufferViews': []}
    for old in nodes:
        node = copy.deepcopy(doc['nodes'][old])
        for key in ['mesh', 'skin']:
            node.pop(key, None)
        if 'children' in node:
            node['children'] = [mapping[c] for c in node['children'] if c in keep]
        result['nodes'].append(node)
    out = bytearray()
    accessors = {}
    hashes = []
    identical = {}
    def accessor(old):
        if old in accessors:
            return accessors[old]
        a = copy.deepcopy(doc['accessors'][old])
        view = doc['bufferViews'][a['bufferView']]
        assert a['componentType'] == 5126 and 'sparse' not in a
        width = {'SCALAR': 1, 'VEC3': 3, 'VEC4': 4, 'MAT4': 16}[a['type']] * 4
        start = view.get('byteOffset', 0) + a.pop('byteOffset', 0)
        stride = view.get('byteStride', width)
        payload = b''.join(binary[start+i*stride:start+i*stride+width] for i in range(a['count']))
        hashes.append(hashlib.sha256(payload).hexdigest())
        signature=(a['type'],a['count'],payload)
        if signature in identical:
            accessors[old]=identical[signature]
            return accessors[old]
        out.extend(b'\0' * (-len(out) % 4))
        a['bufferView'] = len(result['bufferViews'])
        result['bufferViews'].append({'buffer': 0, 'byteOffset': len(out), 'byteLength': len(payload)})
        out.extend(payload)
        accessors[old] = len(result['accessors'])
        result['accessors'].append(a)
        identical[signature]=accessors[old]
        return accessors[old]
    for skin in result['skins']:
        skin['joints'] = [mapping[n] for n in skin['joints']]
        if 'skeleton' in skin:
            skin['skeleton'] = mapping[skin['skeleton']]
        if 'inverseBindMatrices' in skin:
            skin['inverseBindMatrices'] = accessor(skin['inverseBindMatrices'])
    for animation in result['animations']:
        for channel in animation['channels']:
            channel['target']['node'] = mapping[channel['target']['node']]
        for sampler in animation['samplers']:
            for key in ['input', 'output']:
                sampler[key] = accessor(sampler[key])
    out.extend(b'\0' * (-len(out) % 4))
    result['buffers'] = [{'byteLength': len(out)}]
    header = json.dumps(result, separators=(',', ':')).encode()
    header += b' ' * (-len(header) % 4)
    blob = struct.pack('<III', 0x46546c67, 2, 28+len(header)+len(out)) + struct.pack('<II', len(header), 0x4e4f534a) + header + struct.pack('<II', len(out), 0x004e4942) + out
    assert len(blob) <= max_bytes, len(blob)
    assert len(result['animations']) == 1
    path.write_bytes(blob)
    check, check_binary = read(path)
    assert not any(check.get(k) for k in ['meshes','materials','textures','images'])
    actual=[]
    for a in check['accessors']:
        v=check['bufferViews'][a['bufferView']]
        actual.append(hashlib.sha256(check_binary[v['byteOffset']:v['byteOffset']+v['byteLength']]).hexdigest())
    assert set(actual)==set(hashes), 'Accessor bytes changed during animation-only packing'
    return {'bytes': len(blob), 'sha256': hashlib.sha256(blob).hexdigest(), 'payload_hashes': hashes,
            'meshes': 0, 'materials': 0, 'textures': 0, 'images': 0}
