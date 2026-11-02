"""Inside Cascadeur: key the native MH controllers and export solved GLB.

MOVE is supplied by the caller, one clip per invocation. Units here are cm.
No source clip, retarget, Godot IK layer, or post-export motion patch is used.
"""
import csc
import json
import math
import os
import numpy as np

MOVE = globals().get('MOVE', 'inside_uppercut')
sc = app.current_scene().domain_scene()
mv = sc.model_viewer(); bv = mv.behaviour_viewer(); dv = mv.data_viewer(); lv = sc.layers_viewer()
objects = {mv.get_object_name(o):o for o in mv.get_objects()}
rig = json.load(open(os.path.join(WORKDIR,'RIG.json')))
base = {n:np.array(p,dtype=float) for n,p in rig['controllers'].items()}
joints = {n:np.array(p,dtype=float) for n,p in rig['joints'].items()}
contact = 8
last = 20

def smooth(x):
    x = max(0,min(1,x))
    return x*x*(3-2*x)

def yaw(a):
    c,s = math.cos(a), math.sin(a)
    return np.array([[c,0,s],[0,1,0],[-s,0,c]])

def unit(v): return v/np.linalg.norm(v)

def pitch(a):
    c,s=math.cos(a),math.sin(a)
    return np.array([[1,0,0],[0,c,-s],[0,s,c]])

def strike_at(f):
    # Contact remains frame 8. Four-frame extension, three-frame snap return.
    if MOVE=='guard_pose': return 0.0
    if MOVE=='inside_uppercut':
        return smooth((f-3)/5) if f<=8 else 1-smooth((f-8)/7)
    return smooth((f-4)/4) if f<=8 else 1-smooth((f-8)/3)

frames=[]
for f in range(last+1):
    strike=strike_at(f)
    dip=8*math.sin(math.pi*f/8)**2 if MOVE=='inside_uppercut' and f<8 else 2.5*strike if MOVE=='cross' else 0
    turn={'guard_pose':0,'inside_uppercut':28,'jab':-15,'cross':53,'lead_hook':-52}[MOVE]
    rot=yaw(math.radians(-38+turn*strike))@pitch(math.radians(7))
    pivot=base['pelvis_MainPoint']
    shift=np.array([0,-4.0-dip,0.8+ (3*strike if MOVE=='cross' else 0)])
    row={}
    for n,p in base.items():
        if n.startswith(('pelvis','thigh','spine','neck','clavicle','upperarm')):
            row[n]=pivot+(yaw(math.radians(turn*strike)) if n.startswith(('pelvis','thigh')) else rot)@(p-pivot)+shift
        elif n.startswith('head'):
            neck=base['neck_01_MainPoint']
            row[n]=pivot+rot@(neck-pivot)+shift+rot@pitch(math.radians(10))@(p-neck)
    if MOVE=='jab':
        for n in ['clavicle_MainPoint_l','clavicle_AdditionalPoint_l','upperarm_MainPoint_l']: row[n]+=np.array([0,4*strike,0])
    for side in ['l','r']:
        angle=-25 if side=='l' else -45
        pivot_turn=(45*strike if MOVE=='cross' and side=='r' else -50*strike if MOVE=='lead_hook' and side=='l' else 0)
        foot_rot=yaw(math.radians(angle+pivot_turn))@pitch(math.radians(8 if side=='r' else 0))
        origin=base['foot_MainPoint_'+side]
        ankle=np.array([12.5 if side=='l' else -12.5,origin[1],27.25 if side=='l' else -27.25])
        # A deliberate pivot rotates about the planted ball, not the ankle.
        ball_offset=base['ball_MainPoint_'+side]-origin
        ball=ankle+yaw(math.radians(angle))@ball_offset
        ankle=ball-foot_rot@ball_offset
        for n,p in base.items():
            if n.startswith(('foot','ball')) and n.endswith('_'+side): row[n]=ankle+foot_rot@(p-origin)
        row['calf_LimbDir_'+side]=np.array([12.5 if side=='l' else -12.5,45,65 if side=='l' else 35])
        guard=np.array([-5,158,36.8]) if side=='l' else np.array([-10,150,16.8])
        wrist=guard.copy()
        if side=='l' and MOVE in ['cross','inside_uppercut']: wrist+=np.array([-3,-3,-8])*strike
        if side=='l' and MOVE=='inside_uppercut': wrist[1]-=dip
        shoulder=row['upperarm_MainPoint_'+side]
        length=np.linalg.norm(joints['upperarm_'+side]-joints['lowerarm_'+side])+np.linalg.norm(joints['lowerarm_'+side]-joints['hand_'+side])
        active=(side=='l' and MOVE in ['jab','lead_hook']) or (side=='r' and MOVE in ['cross','inside_uppercut'])
        if active and MOVE in ['jab','cross']:
            direction=unit(np.array([-shoulder[0]*0.18,12,52]))
            target=shoulder+direction*length*.945
            wrist=guard+(target-guard)*strike
        elif active and MOVE=='lead_hook':
            target=shoulder+np.array([7,10,38])
            wrist=guard+(target-guard)*strike+np.array([12*math.sin(math.pi*strike),0,0])
        elif active and MOVE=='inside_uppercut':
            chamber=np.array([-10,130,19])
            if f<=3: wrist=guard+(chamber-guard)*(f/3)
            elif f<=8: wrist=chamber+np.array([4,24,5])*strike
            else: wrist=guard+(chamber+np.array([4,24,5])-guard)*strike
        row['hand_MainPoint_'+side]=wrist
        row['lowerarm_LimbDir_'+side]=np.array([23 if side=='l' else -23,105-dip,8])
        if active and MOVE in ['jab','cross']:
            row['lowerarm_LimbDir_'+side]=np.array([23 if side=='l' else -23,105-dip,8])+np.array([1 if side=='l' else -1,32,7])*strike
        if active and MOVE=='lead_hook':
            row['lowerarm_LimbDir_'+side]=np.array([23,105,8])+np.array([37,35,24])*strike
    frames.append(row)

names=sorted(frames[0])
dids={n:bv.get_behaviour_data(bv.get_behaviour_by_name(objects[n],'Transform'),'global_position') for n in names}
tracks={lv.layer_id_by_obj_id_or_null(objects[n]) for n in names}
rotations={}
hand_rotation_data={}
hand_rotation_matrices={}
def unit(v): return v/np.linalg.norm(v)
for side in ['l','r']:
    def rotation_data(n, prop):
        return bv.get_behaviour_data(bv.get_behaviour_by_name(objects[n],'Transform'),prop)
    hand_box='hand_Box_'+side
    hand_global=dv.get_data_value(rotation_data(hand_box,'global_rotation'),0)
    matrix=np.array(hand_global.to_rotation_matrix())
    finger=unit(joints['middle_03_'+side]-joints['hand_'+side])
    across=unit(joints['index_01_'+side]-joints['pinky_01_'+side])
    palm=unit(np.cross(across,finger))*(1 if side=='r' else -1)
    local_finger=matrix.T@finger;local_palm=matrix.T@palm
    local_basis=np.column_stack([local_finger,local_palm,np.cross(local_finger,local_palm)])
    target_finger=np.array([0,1,0],dtype=float)
    target_palm=np.array([0,0,-1],dtype=float)
    target_basis=np.column_stack([target_finger,target_palm,np.cross(target_finger,target_palm)])
    rotation=csc.math.Rotation.from_rotation_matrix(np.array(target_basis@local_basis.T,dtype=np.float32))
    rotations[rotation_data(hand_box,'global_rotation')]=rotation
    hand_rotation_data[side]=rotation_data(hand_box,'global_rotation')
    hand_rotation_matrices[side]=target_basis@local_basis.T
    tracks.add(lv.layer_id_by_obj_id_or_null(objects[hand_box]))
    for finger_name in ['index','middle','ring','pinky','thumb']:
        for segment in range(1,4):
            box=f'{finger_name}_{segment:02}_Box_{side}'
            did=rotation_data(box,'local_rotation')
            original=dv.get_data_value(did,0)
            global_matrix=np.array(dv.get_data_value(rotation_data(box,'global_rotation'),0).to_rotation_matrix())
            bone=f'{finger_name}_{segment:02}_{side}'
            if segment<3:
                direction=unit(joints[f'{finger_name}_{segment+1:02}_{side}']-joints[bone])
            else:
                direction=unit(joints[bone]-joints[f'{finger_name}_02_{side}'])
            hinge=global_matrix.T@unit(np.cross(direction,palm))
            degrees=[55,85,60][segment-1] if finger_name!='thumb' else [20,30,20][segment-1]
            bend=csc.math.Rotation.from_angle_axis(math.radians(degrees),np.array(hinge,dtype=np.float32))
            rotations[did]=original*bend
            tracks.add(lv.layer_id_by_obj_id_or_null(objects[box]))
def key(me,ue,su):
    for tr in tracks:
        for f in range(last+1): me.layers_editor().set_fixed_interpolation_or_key_if_need(tr,f,True)
    me.fit_animation_size_by_layers()
    for f,row in enumerate(frames):
        for n in names: me.data_editor().set_data_value(dids[n],f,np.array(row[n],dtype=np.float32))
        su.run_update(set(dids.values()),f)
        for did,rotation in rotations.items():me.data_editor().set_data_value(did,f,rotation)
        strike=strike_at(f)
        side='l' if MOVE in ['jab','lead_hook'] else 'r'
        if MOVE in ['jab','cross']:
            # Knuckles rotate forward and palm pronates down during extension.
            pitch=np.array(csc.math.Rotation.from_angle_axis(math.pi/2*strike,np.array([1,0,0],dtype=np.float32)).to_rotation_matrix())
            roll=np.array(csc.math.Rotation.from_angle_axis(math.pi*smooth((strike-2/3)*3),np.array([0,1,0],dtype=np.float32)).to_rotation_matrix())
            me.data_editor().set_data_value(hand_rotation_data[side],f,csc.math.Rotation.from_rotation_matrix(np.array(pitch@roll@hand_rotation_matrices[side],dtype=np.float32)))
        elif MOVE=='lead_hook':
            turn=np.array(csc.math.Rotation.from_angle_axis(math.pi/2*strike,np.array([0,0,1],dtype=np.float32)).to_rotation_matrix())
            me.data_editor().set_data_value(hand_rotation_data[side],f,csc.math.Rotation.from_rotation_matrix(np.array(turn@hand_rotation_matrices[side],dtype=np.float32)))
        su.run_update(set(rotations),f)
assert sc.modify_update('Author MetaHuman '+MOVE,key), 'controller keying failed'
if MOVE=='guard_pose': app.current_scene().save(os.path.join(WORKDIR,'guard_pose.casc'))
print('KEYED', MOVE,lv.frames_count(),'frames',len(names),'controllers')
readback={}
for n in ['hand_r','lowerarm_r','hand_l','lowerarm_l','foot_l','foot_r','pelvis','head']:
    did=bv.get_behaviour_data(bv.get_behaviour_by_name(objects[n],'Transform'),'global_position')
    readback[n]=[[float(x) for x in dv.get_data_value(did,f)] for f in range(last+1)]
json.dump(readback,open(os.path.join(WORKDIR,'readback_'+MOVE+'.json'),'w'),indent=1)
app.current_scene().save(os.path.join(WORKDIR,'mh_'+MOVE+'.casc'))
out=os.path.abspath(os.path.join(WORKDIR,'../../../Godot/assets/anim/metahuman'))
os.makedirs(out,exist_ok=True)
options=csc.glb.ExportOptions();options.include_animation=True;options.fps=30
csc.glb.process_export(sc,os.path.join(WORKDIR,'_raw_'+MOVE+'.glb').replace('\\','/'),options)
print('EXPORTED',MOVE)
