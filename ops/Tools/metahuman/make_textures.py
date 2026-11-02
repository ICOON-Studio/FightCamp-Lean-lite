"""MH1: game textures for the pilot that need no MetaHuman Core Data.
Without the Core Data option the MetaHuman Creator cannot synthesize skin (its face textures are 128 px placeholders), so
this builds a PLACEHOLDER skin in MetaHuman UV space from bundled data only: one skin tone, the bundled head AO
(T_MH_BentNormal_AO alpha), lips tinted from the bundled UV region guide; and a real eye from the bundled sclera + iris.
Re-run the UE script after Core Data is installed and the synthesized textures replace these."""
from PIL import Image, ImageFilter, ImageChops, ImageDraw
import numpy as np, sys, os
SRC = "E:/FightCamp/metahuman_pilot/export/tex/"
OUT = sys.argv[1] if len(sys.argv) > 1 else "E:/FightCamp/metahuman_pilot/game/"
os.makedirs(OUT, exist_ok=True)
TONE = np.array([168, 116, 88], np.float32)  # medium warm skin, sRGB
N = 2048

ao = Image.open(SRC + "T_MH_BentNormal_AO.tga").convert("RGBA").split()[3].resize((N, N), Image.BICUBIC)
ao = np.asarray(ao.filter(ImageFilter.GaussianBlur(3)), np.float32) / 255.0
guide = np.asarray(Image.open(SRC + "T_Gray_Head_D.tga").convert("RGB").resize((N, N), Image.BICUBIC), np.float32)
r, g, b = guide[..., 0], guide[..., 1], guide[..., 2]
lips = ((r > 170) & (g < 120) & (b < 130)).astype(np.float32)        # the guide paints the lips red
lips = np.asarray(Image.fromarray((lips * 255).astype(np.uint8)).filter(ImageFilter.MaxFilter(9)).filter(ImageFilter.GaussianBlur(10)), np.float32) / 255.0
rng = np.random.default_rng(7)
mottle = np.asarray(Image.fromarray((rng.random((256, 256)) * 255).astype(np.uint8)).resize((N, N), Image.BICUBIC).filter(ImageFilter.GaussianBlur(12)), np.float32) / 255.0 - 0.5
head = TONE[None, None, :] * (0.55 + 0.45 * ao[..., None]) * (1.0 + 0.06 * mottle[..., None])
lipcol = np.array([150, 80, 72], np.float32)
head = head * (1 - 0.55 * lips[..., None]) + lipcol * 0.55 * lips[..., None] * (0.6 + 0.4 * ao[..., None])
if os.path.exists(SRC + "face_basecolor.tga"):   # the REAL synthesized MetaHuman face (Core Data installed)
    head = np.asarray(Image.open(SRC + "face_basecolor.tga").convert("RGB").resize((N, N), Image.BICUBIC), np.float32)
    print("using synthesized face_basecolor.tga")
Image.fromarray(np.clip(head, 0, 255).astype(np.uint8)).save(OUT + "mh_pilot_head_albedo.jpg", quality=90)
body = TONE[None, None, :] * (1.0 + 0.05 * mottle[..., None])
Image.fromarray(np.clip(body, 0, 255).astype(np.uint8)).save(OUT + "mh_pilot_body_albedo.jpg", quality=90)

# Eye: bundled sclera with the bundled iris in the centre (MetaHuman eyeball UV: iris centred, radius ~0.15 UV).
E = 1024
sclera = Image.open(SRC + "T_EyeSclera_D.tga").convert("RGB").resize((E, E), Image.BICUBIC)
iris = Image.open(SRC + "T_Iris001_01_D.tga").convert("RGBA")
IR = 0.15
d = int(2 * IR * E)
iris_s = iris.resize((d, d), Image.BICUBIC).convert("RGB")
mask = Image.new("L", (d, d), 0)
ImageDraw.Draw(mask).ellipse((0, 0, d - 1, d - 1), fill=255)
mask = mask.filter(ImageFilter.GaussianBlur(d * 0.02))
eye = sclera.copy()
eye.paste(iris_s, ((E - d) // 2, (E - d) // 2), mask)
eye.save(OUT + "mh_pilot_eye_albedo.jpg", quality=92)
# Pores: bundled tileable micro normal, used as a detail normal in Godot.
Image.open(SRC + "T_SkinMicroNormal.tga").convert("RGB").save(OUT + "mh_skin_micro_normal.png")
print("ok", os.listdir(OUT))
