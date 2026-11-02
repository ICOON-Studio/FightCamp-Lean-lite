"""Serial, hidden MH4 launches. Every engine launch receives a fresh watchdog check."""
import ctypes
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time
from mh4_affinity import apply_tree

ROOT = Path(__file__).resolve().parents[2]
TOOLS = Path(__file__).parent
SCRATCH = TOOLS / '.mh4'
OUT = ROOT / 'previews/mh4'
OUT.mkdir(parents=True, exist_ok=True)
SCRATCH.mkdir(exist_ok=True)
# S299: MH4_TARGET_DIR sends the GLB elsewhere (the lean repo E:/FightCamp/Lean/assets/models/metahuman).
TARGET = Path(os.environ.get('MH4_TARGET_DIR', ROOT/'Godot/assets/models/metahuman'))
FLAGS = subprocess.CREATE_NO_WINDOW | subprocess.BELOW_NORMAL_PRIORITY_CLASS

def guard():
    while True:
        result = subprocess.run(['powershell','-NoProfile','-ExecutionPolicy','Bypass','-File',
                                 str(ROOT/'Tools/pc_watchdog.ps1'),'-Once'],
                                capture_output=True,text=True,creationflags=FLAGS)
        print(result.stdout + result.stderr,flush=True)
        if result.returncode == 0:
            return
        if 'RED' not in result.stdout + result.stderr:
            raise RuntimeError('Watchdog unavailable; refusing launch')
        print('MH4 WAIT RED; retry in 45 seconds',flush=True)
        time.sleep(45)

def run(command, label, env=None, heavy=True):
    if heavy:
        guard()
    log = OUT/(label+'.txt')
    with log.open('w',encoding='utf-8') as stream:
        proc = subprocess.Popen(command,cwd=ROOT,env=env,stdout=stream,stderr=subprocess.STDOUT,creationflags=FLAGS)
        print('MH4 LAUNCH',label,'pid='+str(proc.pid),flush=True)
        # Two logical CPUs outside the host's shared Godot/Blender mask 0x3F.
        mask=0x140 if label.endswith('_ue') else 0x3F
        samples=[]
        while proc.poll() is None:
            samples.extend(apply_tree(proc.pid,mask))
            try: proc.wait(timeout=2)
            except subprocess.TimeoutExpired: pass
        rc=proc.returncode
        (OUT/(label+'_affinity.json')).write_text(json.dumps(samples,indent=2)+'\n')
    content=log.read_text(errors='replace')
    print('MH4 RESULT',label,'rc='+str(rc),flush=True)
    if rc or any(v in content for v in ('Traceback (most recent call last)','SCRIPT ERROR:','Fatal error:')):
        print(content[-9000:],flush=True)
        raise RuntimeError('Launch failed: '+str(log))
    return content

def project():
    dst=SCRATCH/'project'
    dst.mkdir(exist_ok=True)
    file=dst/'MH4.uproject'
    if not file.exists():
        file.write_bytes((TOOLS/'ue_project/MHPilot.uproject').read_bytes())
    config_dir=dst/'Config'
    config_dir.mkdir(exist_ok=True)
    (config_dir/'DefaultEngine.ini').write_text(
        '[/Script/Engine.RendererSettings]\nr.SkinCache.CompileShaders=True\n'
        'r.GPUSkin.Support16BitBoneIndex=True\nr.GPUSkin.UnlimitedBoneInfluences=True\nr.Substrate=False\n'
        '[DevOptions.Shaders]\nNumUnusedShaderCompilingThreads=14\nNumUnusedShaderCompilingThreadsDuringGame=14\nShaderCompilerCoreCountThreshold=99\n')
    bridge=dst/'Plugins/Staff1Bridge'
    if not bridge.exists():
        shutil.copytree('E:/FightCamp/metahuman_pilot/MHPilot/Plugins/Staff1Bridge',bridge,
                        ignore=shutil.ignore_patterns('Intermediate'))
    return file

def config(name):
    path=TOOLS/(name+'_mh4.json')
    return path,json.loads(path.read_text())

def ue(name):
    path,cfg=config(name)
    processes=subprocess.check_output(['powershell','-NoProfile','-Command',
                 '@(Get-Process UnrealEditor* -ErrorAction SilentlyContinue).Count'],text=True,creationflags=FLAGS).strip()
    assert processes=='0','Another Unreal process exists; no concurrent UE launch'
    ini=SCRATCH/'Engine/Config/BaseDeviceProfiles.ini'
    ini.parent.mkdir(parents=True,exist_ok=True)
    base=Path('C:/Program Files/Epic Games/UE_5.8/Engine/Config/BaseDeviceProfiles.ini').read_text()
    ini.write_text(re.sub(r'LODBias=\d+','LODBias=3',re.sub(r'MaxLODSize=\d+','MaxLODSize=1024',base)))
    env=os.environ.copy()
    env.update(MH2_CONFIG=str(path), **{'UE-LocalDataCachePath':str(SCRATCH/'DDC'),'UE-SharedDataCachePath':'None'})
    cmd=['C:/Program Files/Epic Games/UE_5.8/Engine/Binaries/Win64/UnrealEditor-Cmd.exe',
         str(project()),'-run=pythonscript','-script='+str(TOOLS/'mh4_build.py'),
         '-AllowCommandletRendering','-unattended','-nosplash','-nopause','-stdout','-NoSound',
         '-ddc=(EnginePak=InstalledEnginePak,Local)',
         '-ShaderWorkingDir='+str(SCRATCH/'shaders'),
         '-AsyncLoadingThread=0','-iniFile='+ini.as_posix(),'-ExecCmds=r.TextureAsyncCompilationMaxConcurrency 1',
         '-abslog='+str(OUT/(name+'_ue.log'))]
    run(cmd,name+'_ue',env)
    finish_export(name)

def finish_export(name):
    path,cfg=config(name)
    report=json.load(open(Path(cfg['export'])/'build_report.json'))
    assert 'EXC' not in report, report.get('EXC')
    assert all(row['ok'] for row in report['meshes'])
    assert not any(k.startswith('missing_constraint_') for k in report), 'Unknown body constraint'
    if cfg['role']!='boxer' or (cfg['sex']=='F' and not cfg.get('top')):
        assert report['outfit_export'][0]
    key=next(k for k in ('binding_'+cfg['hair']+'_Binding','binding_'+cfg['hair']) if k in report)
    binding=report[key]['source_skeletal_mesh']
    cfg['hair_reference_head']=binding.rsplit('.',1)[-1]
    cfg['hair_has_baked_texture']=(Path(cfg['export'])/'groom'/(cfg['hair']+'_baked.dds')).exists()
    cards=list((Path(cfg['export'])/'groom').glob(cfg['hair']+'*Mesh_Group0_LOD*.fbx'))
    cfg['hair_baked_only']=not bool(cards)
    assert cards or cfg['hair_has_baked_texture'], 'No exported groom representation'
    if cards:
        lods=[int(re.search(r'LOD(\d+)',p.name)[1]) for p in cards]
        # S333 hair_lod_want: 0 = the fullest cards (his "hotter" pass); else LOD2 when there is one.
        want=cfg.get('hair_lod_want')
        cfg['hair_lod']=want if want in lods else (2 if 2 in lods else min(lods))
    path.write_text(json.dumps(cfg,indent=2)+'\n')
    (OUT/(name+'_creator_receipt.json')).write_text(json.dumps(report,indent=2)+'\n')

def finish(name):
    path,cfg=config(name)
    blender=next(p for p in [Path('C:/Program Files/Blender Foundation/Blender 5.2/blender.exe'),
                            Path('C:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe')] if p.is_file())
    def bl(script,args,label):
        run([str(blender),'--background','--factory-startup','--threads','2','--python-exit-code','1','--python',str(TOOLS/script),'--',*args],name+'_'+label)
    bl('staff1_exr.py',[str(path)],'exr')
    def textures(label):
        run([sys.executable,str(TOOLS/'mh4_textures.py'),cfg['export'],cfg['work'],str(path)],name+'_'+label,heavy=False)
    textures('textures')
    target=TARGET/(name+'.glb')
    args=[cfg['export'],cfg['work']+'/game',str(target),str(path)]
    bl('mh4_glb.py',args,'glb_first')
    textures('seam')
    bl('mh4_glb.py',args,'glb_final')
    receipt(name)

def receipt(name):
    path=TARGET/(name+'.glb')
    log=(OUT/(name+'_glb_final.txt')).read_text(errors='replace')
    assert 'MH1B02 wrote' in log and 'Traceback (most recent call last)' not in log
    data=path.read_bytes()
    (OUT/(name+'_delivery.json')).write_text(json.dumps({'name':name,'bytes':len(data),
            'sha256':hashlib.sha256(data).hexdigest()},indent=2)+'\n')

def godot(args,label):
    engine=next(p for p in [Path(os.environ['LOCALAPPDATA'])/'Programs/Godot/Godot_v4.7.2-stable_win64_console.exe',
                            Path('C:/ProgramData/chocolatey/lib/godot/tools/Godot_v4.7.2-stable_win64_console.exe')] if p.is_file())
    env=os.environ.copy()
    # Isolate renderer cache/log writes inside the owned worktree scratch.
    # Test runner isolation remains in effect when it supplies APPDATA.
    if not os.environ.get('MH4_TEST_RUN'):
        env['APPDATA']=str(SCRATCH/'appdata')
        (SCRATCH/'appdata').mkdir(exist_ok=True)
    if '--headless' in args:
        cmd=[str(engine),*args]
    else:
        env['FIGHTCAMP_GODOT_EXE']=str(engine).replace('_console.exe','.exe')
        cmd=['powershell','-NoProfile','-ExecutionPolicy','Bypass','-File',str(ROOT/'Tools/godot_hidden.ps1'),*args]
    print(run(cmd,label,env),flush=True)

def batch_import(batch,names):
    # Preserve res:// paths and importer settings in a tiny temporary project.
    # A root --import scans unrelated unhydrated LFS art even with seeded cache.
    stage=SCRATCH/('import_'+batch)
    stage.mkdir(exist_ok=True)
    (stage/'project.godot').write_text('config_version=5\n[application]\nconfig/name="MH4 batch import"\n[rendering]\nrenderer/rendering_method="gl_compatibility"\n')
    models=stage/'assets/models/metahuman'
    models.mkdir(parents=True,exist_ok=True)
    source=ROOT/'Godot/assets/models/metahuman'
    template=(source/'mh_boxer_01.glb.import').read_text()
    oldhash=hashlib.md5(b'res://assets/models/metahuman/mh_boxer_01.glb').hexdigest()
    for name in names:
        shutil.copy2(source/(name+'.glb'),models/(name+'.glb'))
        existing=source/(name+'.glb.import')
        if existing.exists():
            shutil.copy2(existing,models/existing.name)
        else:
            newhash=hashlib.md5(('res://assets/models/metahuman/'+name+'.glb').encode()).hexdigest()
            metadata=template.replace('mh_boxer_01',name).replace(oldhash,newhash)
            metadata=re.sub(r'^uid=.*\n','',metadata,flags=re.M)
            (models/(name+'.glb.import')).write_text(metadata)
    godot(['--headless','--path',str(stage),'--import'],'import_'+batch+'_scoped')
    for file in models.iterdir():
        if file.suffix!='.glb':
            shutil.copy2(file,source/file.name)
    imported=ROOT/'Godot/.godot/imported'
    imported.mkdir(parents=True,exist_ok=True)
    for file in (stage/'.godot/imported').iterdir():
        shutil.copy2(file,imported/file.name)
    print('MH4_SCOPED_IMPORT',batch,'models='+str(len(names)),flush=True)

if __name__=='__main__':
    mode=sys.argv[1]
    if mode=='build':
        for name in sys.argv[2:]:
            ue(name)
            finish(name)
    elif mode=='ue': ue(sys.argv[2])
    elif mode=='adopt': finish_export(sys.argv[2])
    elif mode=='finish': finish(sys.argv[2])
    elif mode=='receipt': receipt(sys.argv[2])
    elif mode=='import': batch_import(sys.argv[2],sys.argv[3:])
    elif mode=='lineup':
        godot(['--path','Godot','--resolution','1920x1080','--script','tools/mh_lineup.gd','--',
               'names='+','.join(sys.argv[3:]),'out='+str(OUT/('lineup_'+sys.argv[2]+'.png'))],'lineup_'+sys.argv[2])
    elif mode=='engine':
        label='test_'+next((Path(a).stem for a in sys.argv[2:] if a.endswith('.gd')),'version')
        godot(sys.argv[2:],label)
