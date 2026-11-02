"""Read back and export the actual post-AutoPhysics native animation."""
import os, json, csc
MOVE = globals().get('MOVE','inside_uppercut')
sc=app.current_scene().domain_scene();mv=sc.model_viewer();bv=mv.behaviour_viewer();dv=mv.data_viewer()
objects={mv.get_object_name(o):o for o in mv.get_objects()}
frames=sc.layers_viewer().frames_count()
readback={}
for n in ['hand_r','lowerarm_r','hand_l','lowerarm_l','foot_l','foot_r','pelvis','head','spine_05']:
    did=bv.get_behaviour_data(bv.get_behaviour_by_name(objects[n],'Transform'),'global_position')
    readback[n]=[[float(x) for x in dv.get_data_value(did,f)] for f in range(frames)]
json.dump(readback,open(os.path.join(WORKDIR,'readback_'+MOVE+'.json'),'w'),indent=1)
app.current_scene().save(os.path.join(WORKDIR,'mh_'+MOVE+'.casc'))
if MOVE=='guard_pose': app.current_scene().save(os.path.join(WORKDIR,'guard_pose.casc'))
out=os.path.abspath(os.path.join(WORKDIR,'../../../Godot/assets/anim/metahuman'))
options=csc.glb.ExportOptions();options.include_animation=True;options.fps=30
csc.glb.process_export(sc,os.path.join(WORKDIR,'_raw_'+MOVE+'.glb').replace('\\','/'),options)
print('POST_PHYSICS_EXPORTED',MOVE,frames)
