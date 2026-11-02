"""MH4 Creator build; reuse STAFF1/MH2 without modifying their scripts."""
import os
from pathlib import Path

cfg = __import__('json').load(open(os.environ['MH2_CONFIG']))
# S299: a woman boxer with a painted `top` is built bare like the men (full skin; the singlet is a body mask in mh4_glb).
clothed = cfg['role'] != 'boxer' or (cfg['sex'] == 'F' and not cfg.get('top'))
path = Path(__file__).with_name('staff1_build.py' if clothed else 'mh2_build.py')
# STAFF1 resolves its source relative to __file__; keep its original filename.
source = path.read_text()
if not clothed:
    source = source.replace('("MH_Groom_Head", "SKM_Groom_Head_Legacy02")',
                            '("MH_Groom_Head", "SKM_Groom_Head_Legacy01", "SKM_Groom_Head_Legacy02")')
exec(compile(source, str(path), 'exec'), dict(globals(), __file__=str(path)))
