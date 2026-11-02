"""Reuse seam-aware MH2 textures with per-character groom colour."""
import json
from pathlib import Path
import sys

cfg=json.load(open(sys.argv[3]))
source=Path(__file__).with_name('mh2_textures.py').read_text()
source=source.replace('hits = glob.glob(EXP + "groom/" + pattern)',
    'current = json.load(open(EXP + "build_report.json"))["grooms"]\n'
    '    hits = [h for h in glob.glob(EXP + "groom/" + pattern) if os.path.basename(h).rsplit(".", 1)[0] in current]')
source=source.replace('HAIR = np.array([42, 31, 24]', 'HAIR = np.array('+repr(cfg.get('hair_color_rgb',[42,31,24])))
exec(compile(source,__file__,'exec'))
