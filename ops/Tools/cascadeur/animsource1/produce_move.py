"""Orchestrate one move in the already verified hidden Cascadeur app."""
import sys
import json
import subprocess
import time
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from csend import run
from ensure_server import ensure_hidden
from normalize_export import normalize
from animation_only import strip
work=Path(__file__).resolve().parent

def send(code):
    result=run(f'WORKDIR={str(work)!r}\n'+code)
    for message in result.get('messages',[]):
        print(message.get('level'),message.get('text'),flush=True)
    assert result.get('ok'),result
    assert not any(m.get('level')=='Error' for m in result.get('messages',[])),result

def watchdog():
    while True:
        check=subprocess.run(['powershell','-NoProfile','-ExecutionPolicy','Bypass','-File',str(work.parents[1]/'pc_watchdog.ps1'),'-Once'],capture_output=True,text=True)
        print(check.stdout,flush=True)
        if ' RED ' not in check.stdout and 'RED   ' not in check.stdout: return
        print('Waiting for watchdog RED to clear',flush=True)
        time.sleep(15)

def produce(move):
    watchdog()
    assert ensure_hidden()==0
    state=run("print(app.current_scene().get_path_name())")
    paths=[m.get('text','') for m in state.get('messages',[]) if m.get('level')=='Info']
    if any('animsource1' in path for path in paths):
        # Cascadeur can deadlock when replacing a populated scene while the
        # physics worker is active. Only recycle this task's verified instance.
        evidence=json.loads((work/'_hidden_desktop.json').read_text())
        pid_result=run("import os; print(os.getpid())")
        actual=int(next(m['text'] for m in pid_result['messages'] if m['level']=='Info'))
        assert evidence['desktop']=='FightCampCascadeur' and evidence['pid']==actual
        subprocess.run(['powershell','-NoProfile','-Command',f'Stop-Process -Id {actual} -Force'],check=True)
        assert ensure_hidden()==0
    send(f"app.get_tools_manager().get_tool('AutoPhysicsTool').editor(app.current_scene()).turn_off(); csc.app.ProjectLoader.load_from({str(work/'MetaHuman_source.casc')!r},app.current_scene().domain_scene()); print('Native source loaded')")
    watchdog()
    send(f"MOVE={move!r}\n"+(work/'author_moves.py').read_text())
    watchdog()
    physics_log=Path('C:/Users/user/AppData/Local/Nekki Limited/Cascadeur/logs/cascadeur_log.log')
    log_offset=physics_log.stat().st_size
    send("app.get_tools_manager().get_tool('AutoPhysicsTool').editor(app.current_scene()).turn_off(); app.get_action_manager().call_action('AutoPhysicsTool.Switch Auto Physics'); print('AutoPhysics enabled from known off state')")
    watchdog()
    send("app.get_action_manager().call_action('AutoPhysicsTool.Snap to Auto Physics'); print('Snap to working AutoPhysics completed')")
    watchdog()
    send(f"MOVE={move!r}\n"+(work/'finalize_move.py').read_text())
    with physics_log.open('rb') as stream:
        stream.seek(log_offset)
        lines=stream.read().decode('utf-8',errors='replace').splitlines()
    solved=[line for line in lines if 'solved' in line or 'CONVERGENCE' in line or 'Autophysics core finished' in line]
    assert any('Autophysics core finished' in line for line in solved), 'No actual physics completion'
    evidence_path=work/'physics_1b.json'
    evidence=json.loads(evidence_path.read_text()) if evidence_path.exists() else {}
    evidence[move]={'solver_log':solved}
    evidence_path.write_text(json.dumps(evidence,indent=2))
    normalize(move)
    result=strip(work.parents[2]/"Godot/assets/anim/metahuman"/("mh_"+move+".glb"))
    (work/("animation_only_"+move+".json")).write_text(json.dumps(result,indent=2))
    receipt_path=work/("receipt_"+move+".json")
    receipt=json.loads(receipt_path.read_text())
    receipt['normalized_mesh_sha256']=receipt.pop('glb_sha256')
    receipt['glb_sha256']=result['sha256']
    receipt['animation_only']=True
    receipt['clip_bytes']=result['bytes']
    receipt_path.write_text(json.dumps(receipt,indent=2))
    print("ANIMATION_ONLY",move,result["bytes"],flush=True)

if __name__=='__main__':
    for move in sys.argv[1:]: produce(move)
