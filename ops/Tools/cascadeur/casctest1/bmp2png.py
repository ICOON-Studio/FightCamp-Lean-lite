"""CASCTEST1: turn shot.py's BMPs into PNGs (then the BMPs are deleted). python bmp2png.py <dir> <stem>"""
import glob, os, sys
from PIL import Image
for f in glob.glob(os.path.join(sys.argv[1], sys.argv[2] + '_*.bmp')):
    im = Image.open(f).convert('RGB'); out = os.path.join(sys.argv[3] if len(sys.argv) > 3 else sys.argv[1], os.path.basename(f)[:-4] + '.png')
    im.save(out); os.remove(f); print(out, im.size, im.getextrema())
