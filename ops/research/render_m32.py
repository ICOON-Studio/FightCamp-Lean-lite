#!/usr/bin/env python3
"""M32 render: before/after mocks for GYM CREATION and THE DAY.
Pillow only. Supersampled 2x then downscaled. BEFORE boards are
reconstructions from live code (CreationFlowPanel/CreationChrome/UIKit,
ShellChrome/DayFeedPanel/UIKitShell at repo HEAD 2662c01), not screenshots.
All strings not taken from code are EXAMPLE copy (words are Kalli's)."""
import math, os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

OUT = os.path.dirname(os.path.abspath(__file__))
S = 2
G = '/usr/share/fonts/truetype/sand-box/google/'
INTER = G + 'Inter/Inter-VariableFont_opsz,wght.ttf'
BEBAS = G + 'Bebas Neue/BebasNeue-Regular.ttf'
PLEX = G + 'IBM Plex Mono/IBMPlexMono-Medium.ttf'
WARN = []

def hx(h, a=255):
    h = h.lstrip('#'); return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16), a)
def lighten(c, t):
    return tuple(int(c[i] + (255 - c[i]) * t) for i in range(3)) + (c[3],)
def darken(c, t):
    return tuple(int(c[i] * (1 - t)) for i in range(3)) + (c[3],)
def alpha(c, a):
    return c[:3] + (int(a * 255),)

# ---- live tokens (UITokens.gd) ----
GROUND = hx('#1c2230'); GROUND_2 = hx('#242c3d'); PANEL = hx('#2a3347'); PANEL_HI = hx('#34405a')
PANEL_LO = hx('#222a3b'); PANEL_GLASS = (34, 42, 59, 240); TRACK = hx('#111621'); EDGE = hx('#121722')
LINE = hx('#4a5a78'); LINE_SOFT = hx('#2b3340'); TEXT = hx('#f3f5fa'); TEXT_2 = hx('#c9d1e0')
MUTED = hx('#94a1b8'); DIM = hx('#6d7688'); INK = hx('#1b1207'); LINK = hx('#7fb6ee')
GOLD = hx('#f0c233'); GOLD_HI = hx('#f7d65a'); GOLD_EDGE = hx('#7a5c0c'); GYM = hx('#2f6fb0')
GO = hx('#22c55e'); GO_EDGE = hx('#0b4a23'); SLATE = hx('#3f4a62'); CONTROL = hx('#303a52')
CHIP = hx('#333d52'); AVATAR = hx('#3b4557'); DAY = hx('#171a22'); DAY_TODAY = hx('#1e2836')
GOOD = hx('#4fc46a'); AMBER = hx('#f0a020'); BAD = hx('#e5433a')
GYM_DEEP = darken(GYM, .45); GYM_LO = darken(GYM, .22); GYM_HI = lighten(GYM, .16)
# ---- M32 proposed deltas ----
MUTED_32 = hx('#a3afc4')      # lifted MUTED: 5.7:1 on PANEL, 4.68:1 on PANEL_HI
HAIR = (255, 255, 255, 18)    # rim hairline
DIVIDER = hx('#36405a')
BAD_TEXT = hx('#f2766f')

_fc = {}
def F(fam, size, w=400):
    k = (fam, size, w)
    if k in _fc: return _fc[k]
    if fam == 'inter':
        f = ImageFont.truetype(INTER, int(size * S))
        f.set_variation_by_axes([max(14, min(32, size)), w])
    elif fam == 'bebas':
        f = ImageFont.truetype(BEBAS, int(size * S))
    else:
        f = ImageFont.truetype(PLEX, int(size * S))
    _fc[k] = f; return f

class C:
    def __init__(self, w=1920, h=1080, bg=GROUND, name=''):
        self.w, self.h, self.name = w, h, name
        self.im = Image.new('RGB', (w * S, h * S), bg[:3])
        self.d = ImageDraw.Draw(self.im, 'RGBA')  # RGB base + RGBA ink = true alpha blending
    def _b(self, x, y, w, h):
        return [x * S, y * S, (x + w) * S - 1, (y + h) * S - 1]
    def rect(self, x, y, w, h, fill=None, r=0, outline=None, ow=1):
        if fill is not None and len(fill) == 4 and fill[3] < 255:
            lay = Image.new('RGBA', self.im.size, (0, 0, 0, 0)); dd = ImageDraw.Draw(lay)
            dd.rounded_rectangle(self._b(x, y, w, h), r * S, fill=fill)
            self.im.paste(lay, (0, 0), lay); fill = None
        if fill is not None or outline is not None:
            if outline is not None and len(outline) == 4 and outline[3] < 255:
                if fill is not None:
                    self.d.rounded_rectangle(self._b(x, y, w, h), r * S, fill=fill)
                lay = Image.new('RGBA', self.im.size, (0, 0, 0, 0)); dd = ImageDraw.Draw(lay)
                dd.rounded_rectangle(self._b(x, y, w, h), r * S, outline=outline, width=int(ow * S))
                self.im.paste(lay, (0, 0), lay)
            else:
                self.d.rounded_rectangle(self._b(x, y, w, h), r * S, fill=fill, outline=outline, width=int(ow * S))
    def dashed(self, x, y, w, h, col, r=8, dash=8, gap=6, ow=1.5):
        lay = Image.new('RGBA', self.im.size, (0, 0, 0, 0)); dd = ImageDraw.Draw(lay)
        pts = []
        per = 2 * (w + h)
        t = 0
        def at(s):
            if s < w: return (x + s, y)
            s -= w
            if s < h: return (x + w, y + s)
            s -= h
            if s < w: return (x + w - s, y + h)
            s -= w
            return (x, y + h - s)
        while t < per:
            a = at(t); b = at(min(t + dash, per - 0.01))
            if abs(a[0] - b[0]) < 0.01 or abs(a[1] - b[1]) < 0.01:
                dd.line([a[0] * S, a[1] * S, b[0] * S, b[1] * S], fill=col, width=int(ow * S))
            t += dash + gap
        self.im.paste(lay, (0, 0), lay)
    def vgrad(self, x, y, w, h, top, bot, r=0, horizontal=False):
        g = Image.new('RGBA', (int(w * S), int(h * S)))
        gd = ImageDraw.Draw(g)
        n = int((w if horizontal else h) * S)
        for i in range(n):
            t = i / max(1, n - 1)
            c = tuple(int(top[k] + (bot[k] - top[k]) * t) for k in range(4))
            if horizontal: gd.line([i, 0, i, h * S], fill=c)
            else: gd.line([0, i, w * S, i], fill=c)
        m = Image.new('L', g.size, 0)
        ImageDraw.Draw(m).rounded_rectangle([0, 0, g.size[0] - 1, g.size[1] - 1], r * S, fill=255)
        lay = Image.new('RGBA', self.im.size, (0, 0, 0, 0))
        lay.paste(g, (int(x * S), int(y * S)), m)
        self.im.paste(lay, (0, 0), lay)
    def shadow(self, x, y, w, h, r=8, blur=12, a=0.35, dy=4):
        lay = Image.new('RGBA', self.im.size, (0, 0, 0, 0))
        ImageDraw.Draw(lay).rounded_rectangle(self._b(x, y + dy, w, h), r * S, fill=(0, 0, 0, int(255 * a)))
        lay = lay.filter(ImageFilter.GaussianBlur(blur * S / 2))
        self.im.paste(lay, (0, 0), lay)
    def surface(self, x, y, w, h, level=1, r=8, gym=None):
        """M32 surfaces: 0 sunk, 1 resting, 2 lifted, 3 hero."""
        if level == 0:
            self.rect(x, y, w, h, TRACK, r); self.rect(x, y, w, h, None, r, (255, 255, 255, 14), 1); return
        if level == 1:
            self.shadow(x, y, w, h, r, 10, .28, 3)
            self.vgrad(x, y, w, h, lighten(PANEL, .02), PANEL, r)
            self.rect(x, y, w, h, None, r, HAIR, 1); return
        if level == 2:
            self.shadow(x, y, w, h, r, 16, .34, 5)
            self.vgrad(x, y, w, h, lighten(PANEL_HI, .03), PANEL_HI, r)
            self.rect(x, y, w, h, None, r, (255, 255, 255, 30), 1); return
        g = gym or GYM
        self.shadow(x, y, w, h, r, 24, .45, 8)
        self.vgrad(x, y, w, h, darken(g, .38), lighten(PANEL, .01), r, horizontal=True)
        self.vgrad(x, y, w, h, (255, 255, 255, 14), (0, 0, 0, 0), r)
        self.rect(x, y, w, h, None, r, alpha(lighten(g, .3), .35), 1)
    def text(self, x, y, s, font, fill, anchor='la', maxw=None, feat=None, track=0.0):
        if track:
            wtot = sum(font.getlength(ch) for ch in s) / S + track * (len(s) - 1)
            if anchor[0] == 'r': x -= wtot
            elif anchor[0] == 'm': x -= wtot / 2
            a2 = 'l' + anchor[1]
            cx = x
            for ch in s:
                self.d.text((cx * S, y * S), ch, font=font, fill=fill, anchor=a2)
                cx += font.getlength(ch) / S + track
            wd = wtot
        else:
            kw = {'features': feat} if feat else {}
            self.d.text((x * S, y * S), s, font=font, fill=fill, anchor=anchor, **kw)
            wd = self.d.textlength(s, font=font, **kw) / S
        if maxw is not None and wd > maxw + 0.5:
            WARN.append('%s: "%s" %.0f > %.0f' % (self.name, s[:40], wd, maxw))
        return wd
    def tw(self, s, font, feat=None, track=0):
        kw = {'features': feat} if feat else {}
        return self.d.textlength(s, font=font, **kw) / S + track * max(0, len(s) - 1)
    def wrap(self, x, y, s, font, fill, maxw, lh, maxlines=3):
        words = s.split(' '); lines = []; cur = ''
        for wd in words:
            t = (cur + ' ' + wd).strip()
            if self.tw(t, font) <= maxw: cur = t
            else: lines.append(cur); cur = wd
        lines.append(cur)
        if len(lines) > maxlines: WARN.append('%s: wrap overflow "%s"' % (self.name, s[:30]))
        for i, l in enumerate(lines[:maxlines]):
            self.text(x, y + i * lh, l, font, fill)
        return len(lines[:maxlines])
    def circle(self, cx, cy, r, fill=None, outline=None, ow=1):
        self.d.ellipse([(cx - r) * S, (cy - r) * S, (cx + r) * S, (cy + r) * S], fill=fill, outline=outline, width=int(ow * S))
    def line(self, pts, col, w=2):
        self.d.line([(p[0] * S, p[1] * S) for p in pts], fill=col, width=int(w * S), joint='curve')
    def arc(self, cx, cy, r, a0, a1, col, w=2):
        self.d.arc([(cx - r) * S, (cy - r) * S, (cx + r) * S, (cy + r) * S], a0, a1, fill=col, width=int(w * S))
    def poly(self, pts, fill=None, outline=None):
        self.d.polygon([(p[0] * S, p[1] * S) for p in pts], fill=fill, outline=outline)
    def save(self, path):
        out = self.im.resize((self.w, self.h), Image.LANCZOS).convert('RGB')
        out.save(path); return out

# ------------------------------------------------------------ icons (line, Lucide-like; drawn, not copied)
def icon(c, name, cx, cy, s, col, w=2.0):
    h = s / 2
    L = lambda pts: c.line(pts, col, w)
    if name == 'sun':
        c.circle(cx, cy, s * .2, None, col, w)
        for i in range(8):
            a = i * math.pi / 4
            L([(cx + math.cos(a) * s * .33, cy + math.sin(a) * s * .33), (cx + math.cos(a) * s * .46, cy + math.sin(a) * s * .46)])
    elif name == 'dumbbell':
        L([(cx - h * .5, cy), (cx + h * .5, cy)])
        for sx in (-1, 1):
            c.rect(cx + sx * h * .62 - s * .07, cy - s * .26, s * .14, s * .52, None, 2, col, w)
            L([(cx + sx * h * .92, cy - s * .12), (cx + sx * h * .92, cy + s * .12)])
    elif name == 'users':
        c.circle(cx - s * .1, cy - s * .16, s * .16, None, col, w)
        c.arc(cx - s * .1, cy + s * .42, s * .3, 200, 340, col, w)
        c.arc(cx + s * .2, cy - s * .16, s * .14, 280, 80, col, w)
        c.arc(cx + s * .2, cy + s * .42, s * .3, 280, 340, col, w)
    elif name == 'activity':
        L([(cx - h, cy), (cx - h * .45, cy), (cx - h * .2, cy - h * .7), (cx + h * .2, cy + h * .7), (cx + h * .45, cy), (cx + h, cy)])
    elif name == 'calendar':
        c.rect(cx - h * .85, cy - h * .7, s * .85, s * .8, None, 3, col, w)
        L([(cx - h * .85, cy - h * .25), (cx + h * .85, cy - h * .25)])
        L([(cx - h * .4, cy - h * .95), (cx - h * .4, cy - h * .55)]); L([(cx + h * .4, cy - h * .95), (cx + h * .4, cy - h * .55)])
    elif name == 'search':
        c.circle(cx - s * .06, cy - s * .06, s * .3, None, col, w)
        L([(cx + s * .16, cy + s * .16), (cx + h * .9, cy + h * .9)])
    elif name == 'trophy':
        c.arc(cx, cy - s * .2, s * .3, 0, 180, col, w)
        L([(cx - s * .3, cy - s * .2), (cx - s * .3, cy - s * .4), (cx + s * .3, cy - s * .4), (cx + s * .3, cy - s * .2)])
        L([(cx, cy + s * .1), (cx, cy + s * .3)]); L([(cx - s * .22, cy + s * .38), (cx + s * .22, cy + s * .38)])
        c.arc(cx - s * .34, cy - s * .22, s * .1, 90, 270, col, w); c.arc(cx + s * .34, cy - s * .22, s * .1, 270, 90, col, w)
    elif name == 'briefcase':
        c.rect(cx - h * .9, cy - h * .45, s * .9, s * .68, None, 3, col, w)
        c.rect(cx - h * .35, cy - h * .8, s * .35, s * .2, None, 2, col, w)
        L([(cx - h * .9, cy - h * .05), (cx + h * .9, cy - h * .05)])
    elif name == 'bell':
        c.arc(cx, cy - s * .08, s * .28, 180, 360, col, w)
        L([(cx - s * .28, cy - s * .08), (cx - s * .3, cy + s * .2), (cx - s * .38, cy + s * .28), (cx + s * .38, cy + s * .28), (cx + s * .3, cy + s * .2), (cx + s * .28, cy - s * .08)])
        c.arc(cx, cy + s * .32, s * .1, 0, 180, col, w)
    elif name == 'chev':
        L([(cx - s * .12, cy - s * .25), (cx + s * .13, cy), (cx - s * .12, cy + s * .25)])
    elif name == 'chevl':
        L([(cx + s * .12, cy - s * .25), (cx - s * .13, cy), (cx + s * .12, cy + s * .25)])
    elif name == 'arrow':
        L([(cx - s * .32, cy), (cx + s * .32, cy)]); L([(cx + s * .08, cy - s * .24), (cx + s * .32, cy), (cx + s * .08, cy + s * .24)])
    elif name == 'check':
        L([(cx - s * .3, cy), (cx - s * .08, cy + s * .22), (cx + s * .32, cy - s * .22)])
    elif name == 'plus':
        L([(cx - s * .3, cy), (cx + s * .3, cy)]); L([(cx, cy - s * .3), (cx, cy + s * .3)])
    elif name == 'flame':
        c.arc(cx, cy + s * .1, s * .28, 330, 210, col, w)
        L([(cx - s * .24, cy - s * .04), (cx - s * .1, cy - s * .2), (cx - s * .02, cy - s * .44), (cx + s * .16, cy - s * .2), (cx + s * .24, cy - s * .04)])
    elif name == 'dollar':
        L([(cx, cy - h * .95), (cx, cy + h * .95)])
        c.arc(cx, cy - s * .16, s * .18, 100, 360, col, w)
        c.arc(cx, cy + s * .16, s * .18, 280, 180, col, w)
    elif name == 'clock':
        c.circle(cx, cy, s * .42, None, col, w); L([(cx, cy - s * .24), (cx, cy), (cx + s * .16, cy + s * .1)])
    elif name == 'pin':
        c.arc(cx, cy - s * .12, s * .28, 150, 30, col, w)
        L([(cx - s * .24, cy - s * .0), (cx, cy + s * .44), (cx + s * .24, cy - s * .0)])
        c.circle(cx, cy - s * .12, s * .09, None, col, w)
    elif name == 'lock':
        c.rect(cx - s * .3, cy - s * .04, s * .6, s * .44, None, 3, col, w)
        c.arc(cx, cy - s * .08, s * .2, 180, 360, col, w)
        L([(cx - s * .2, cy - s * .08), (cx - s * .2, cy - s * .04)]); L([(cx + s * .2, cy - s * .08), (cx + s * .2, cy - s * .04)])
    elif name == 'news':
        c.rect(cx - h * .85, cy - h * .7, s * .85, s * .7, None, 3, col, w)
        for k in (-.3, 0, .3): L([(cx - h * .5, cy + h * k), (cx + h * .5, cy + h * k)])
    elif name == 'wallet':
        c.rect(cx - h * .85, cy - h * .6, s * .85, s * .62, None, 4, col, w)
        c.rect(cx + h * .25, cy - h * .2, s * .22, s * .22, None, 3, col, w)
    elif name == 'grid':
        for i in (-1, 1):
            for j in (-1, 1):
                c.rect(cx + i * s * .2 - s * .15, cy + j * s * .2 - s * .15, s * .3, s * .3, None, 2, col, w)
    elif name == 'ring':
        c.rect(cx - h * .8, cy - h * .8, s * .8, s * .8, None, 3, col, w)
        c.rect(cx - h * .5, cy - h * .5, s * .5, s * .5, None, 2, col, w * .8)
    elif name == 'save':
        c.rect(cx - h * .8, cy - h * .8, s * .8, s * .8, None, 3, col, w); c.rect(cx - h * .4, cy - h * .8, s * .4, s * .25, None, 1, col, w)
    elif name == 'gear':
        c.circle(cx, cy, s * .16, None, col, w); c.circle(cx, cy, s * .34, None, col, w)
        for i in range(6):
            a = i * math.pi / 3
            L([(cx + math.cos(a) * s * .34, cy + math.sin(a) * s * .34), (cx + math.cos(a) * s * .46, cy + math.sin(a) * s * .46)])
    elif name == 'medkit':
        c.rect(cx - h * .85, cy - h * .55, s * .85, s * .7, None, 3, col, w)
        L([(cx, cy - h * .3), (cx, cy + h * .5)]); L([(cx - h * .4, cy + h * .1), (cx + h * .4, cy + h * .1)])

def portrait(c, cx, cy, r, ours=True, gym=GYM, tone=0):
    """Silhouette portrait disc: gym-tinted for ours, slate for others."""
    size = int(2 * r * S) + 2
    lay = Image.new('RGBA', (size, size), (0, 0, 0, 0)); dd = ImageDraw.Draw(lay)
    base_top = lighten(gym, .05) if ours else lighten(SLATE, .08)
    base_bot = darken(gym, .5) if ours else darken(SLATE, .35)
    for i in range(size):
        t = i / size
        col = tuple(int(base_top[k] + (base_bot[k] - base_top[k]) * t) for k in range(3)) + (255,)
        dd.line([0, i, size, i], fill=col)
    fig = lighten(base_bot, .28 + .04 * tone) if ours else lighten(base_bot, .3)
    fd = ImageDraw.Draw(lay)
    hr = r * .34 * S
    hc = (size / 2 + (tone - 1) * .02 * r * S, size * .40)
    fd.ellipse([hc[0] - hr, hc[1] - hr * 1.12, hc[0] + hr, hc[1] + hr * 1.12], fill=fig)
    fd.rounded_rectangle([hc[0] - hr * .42, hc[1] + hr * .8, hc[0] + hr * .42, hc[1] + hr * 1.5], int(hr * .2), fill=fig)
    fd.ellipse([size / 2 - r * .78 * S, size * .70, size / 2 + r * .78 * S, size * 1.35], fill=fig)
    m = Image.new('L', (size, size), 0); ImageDraw.Draw(m).ellipse([0, 0, size - 1, size - 1], fill=255)
    lay.putalpha(Image.composite(lay.getchannel('A'), Image.new('L', (size, size), 0), m))
    full = Image.new('RGBA', c.im.size, (0, 0, 0, 0))
    full.paste(lay, (int((cx - r) * S), int((cy - r) * S)), lay)
    c.im.paste(full, (0, 0), full)
    ring = lighten(gym, .35) if ours else hx('#5a6782')
    c.circle(cx, cy, r, None, ring, 2 if r > 30 else 1.5)

def crest(c, x, y, s, gym=GYM, letters='NB'):
    pts = [(x, y), (x + s, y), (x + s, y + s * .62), (x + s / 2, y + s * 1.08), (x, y + s * .62)]
    lay = Image.new('RGBA', c.im.size, (0, 0, 0, 0)); dd = ImageDraw.Draw(lay)
    dd.polygon([(p[0] * S, p[1] * S) for p in pts], fill=gym)
    c.im.paste(lay, (0, 0), lay)
    c.poly([(x + 3, y + 3), (x + s - 3, y + 3), (x + s - 3, y + s * .3), (x + 3, y + s * .3)], fill=alpha(lighten(gym, .2), .6))
    c.line(pts + [pts[0]], lighten(gym, .4), 1.5)
    c.text(x + s / 2, y + s * .5, letters, F('bebas', int(s * .5)), TEXT, 'mm')

# ================================================================ BEFORE (live reconstruction) helpers
def b_caps(c, x, y, s, size=12, col=MUTED, anchor='lm', maxw=None):
    return c.text(x, y, s.upper(), F('plex', size), col, anchor, maxw)
def b_disp(c, x, y, s, size, col=TEXT, anchor='lm', maxw=None):
    return c.text(x, y, s.upper(), F('bebas', size), col, anchor, maxw)
def b_block(c, x, y, w, h, col, r=3, light=.1):
    c.rect(x, y, w, h, col, r)
    c.vgrad(x, y, w, min(h, 18), (255, 255, 255, int(255 * light * .5)), (255, 255, 255, 0), r)
    c.rect(x, y, w, h, None, r, (255, 255, 255, 22), 1)
def b_button(c, x, y, w, h, s, kind='standard', size=17):
    bg, fg, edge = CONTROL, TEXT, EDGE
    if kind == 'primary': bg, fg, edge = GOLD, INK, GOLD_EDGE
    if kind == 'go': bg, fg, edge = GO, TEXT, GO_EDGE
    if kind == 'gym': bg, fg = GYM, TEXT
    c.rect(x, y, w, h, bg, 3, edge, 1)
    c.vgrad(x + 1, y + 1, w - 2, h / 2, (255, 255, 255, 40), (255, 255, 255, 0), 3)
    b_disp(c, x + w / 2, y + h / 2 + 1, s, size, fg, 'mm')
def b_chip(c, x, y, s, kind='standard'):
    bg, fg = CHIP, TEXT
    if kind == 'gold': bg, fg = GOLD, INK
    if kind == 'gym': bg, fg = GYM, TEXT
    w = 20 + len(s) * 7.6
    c.rect(x, y, w, 30, bg, 3, EDGE, 1)
    b_caps(c, x + w / 2, y + 15, s, 12, fg, 'mm')
    return w
def b_disc(c, cx, cy, r, initials, ring=LINE, size=15):
    c.circle(cx, cy, r, AVATAR, ring, 2)
    b_disp(c, cx, cy + 1, initials, size, TEXT_2, 'mm')

# ================================================================ BEFORE: gym creation
def before_creation():
    c = C(name='before_creation')
    W = 1920
    # body first (slot 142..1034)
    bx, by = 100, 142
    b_disp(c, bx, by + 12 + 20, 'NAME THE GYM', 34, TEXT, 'lm')
    b_caps(c, bx, by + 54 + 9, 'THE NAME SEEDS THE FLOOR AND THE ROSTER, SO WHAT IS DRAWN BELOW IS WHAT GETS SAVED.', 13, MUTED, 'lm', 1400)
    b_caps(c, bx, by + 78 + 8, 'GYM NAME', 12, MUTED)
    c.rect(bx, by + 100, 620, 52, PANEL_LO, 3, GYM_HI, 1)
    b_disp(c, bx + 12, by + 126, 'NICOSIA BOXING CLUB', 26, TEXT)
    # take host at (100, 318)
    ty = by + 176
    b_caps(c, bx, ty + 9, 'WHAT OPENS WITH THE DOORS', 12, MUTED)
    figs = [('$ 25,000', 'STARTING CASH'), ('6/12', 'FLOOR SPACE'), ('$ 420 / WEEK', 'UPKEEP')]
    for i, (v, l) in enumerate(figs):
        x = bx + i * 250
        b_block(c, x, ty + 24, 230, 72, PANEL_LO, 3, .05)
        b_disp(c, x + 14, ty + 24 + 24, v, 30, TEXT)
        b_caps(c, x + 14, ty + 24 + 54, l, 12, MUTED)
    b_caps(c, bx, ty + 122 + 9, 'THE STARTER FLOOR  ·  NOT EDITABLE UNTIL THE GYM IS OPEN', 12, DIM, 'lm', 880)
    gx, gy, cell = bx, ty + 146, 96
    items = {(0, 0): ('BOXING RING', 'RING', 2, 2, 100), (2, 0): ('HEAVY BAG', 'BAG', 1, 1, 72), (2, 1): ('WEIGHT BENCH', 'STRENGTH', 1, 1, 100)}
    occ = set()
    for (ix, iy), it in items.items():
        for a in range(it[2]):
            for b in range(it[3]): occ.add((ix + a, iy + b))
    for x in range(4):
        for y in range(3):
            if (x, y) not in occ:
                c.rect(gx + x * cell + 2, gy + y * cell + 2, cell - 4, cell - 4, TRACK, 3)
    for (ix, iy), (nm, cat, w_, h_, cond) in items.items():
        x0, y0 = gx + ix * cell + 2, gy + iy * cell + 2
        ww, hh = w_ * cell - 4, h_ * cell - 4
        b_block(c, x0, y0, ww, hh, PANEL_HI, 3, .14)
        b_disp(c, x0 + 8, y0 + 16, nm, 14, TEXT, 'lm', ww - 12)
        b_caps(c, x0 + 8, y0 + 34, cat, 12, MUTED, 'lm', ww - 12)
        c.rect(x0 + 8, y0 + hh - 14, ww - 16, 6, TRACK, 2)
        c.rect(x0 + 8, y0 + hh - 14, (ww - 16) * cond / 100, 6, GOOD if cond > 80 else AMBER, 2)
    px = bx + 1400 - 500
    b_caps(c, px, ty + 122 + 9, 'THE PEOPLE WHO COME WITH IT  ·  4 ON THE ROSTER', 12, DIM, 'lm', 500)
    ppl = [('KIAN STERLING', 'AGE 22  ·  BOX  ·  6-1-0'), ('JONAS REED', 'AGE 26  ·  BOX  ·  9-4-1'), ('MIA TORRES', 'AGE 24  ·  BOX  ·  4-0-0'), ('ANDREAS LOIZOU', 'AGE 19  ·  BOX  ·  1-1-0')]
    for i, (n, l) in enumerate(ppl):
        y = ty + 146 + i * 56
        b_block(c, px, y, 500, 50, PANEL_LO, 3, .04)
        ini = ''.join(p[0] for p in n.split()[:2])
        b_disc(c, px + 8 + 17, y + 8 + 17, 17, ini, LINE, 15)
        c.circle(px + 25, y + 25, 17, None, LINE, 1)
        b_disp(c, px + 52, y + 16, n, 17, TEXT)
        b_caps(c, px + 52, y + 36, l, 12, MUTED)
    # readout + gold
    ax = 1620
    b_disp(c, ax, by + 92 + 14, 'NICOSIA BOXING CLUB', 22, TEXT, 'lm', 280)
    lines = ['NICOSIA  ·  CYPRUS', '4 FIGHTERS ON THE ROSTER', '6/12 FLOOR SPACE USED']
    for i, l in enumerate(lines):
        b_caps(c, ax, by + 92 + 32 + i * 22 + 9, l, 12, MUTED, 'lm', 280)
    b_button(c, ax, by + 262, 280, 62, 'OPEN GYM', 'primary', 24)
    # chrome on top
    c.rect(0, 0, W, 96, GROUND_2)
    c.vgrad(0, 0, W, 30, (255, 255, 255, 12), (255, 255, 255, 0))
    b_block(c, 28, 21, 54, 54, GYM, 3, .22)
    b_disp(c, 55, 49, 'FC', 26, TEXT, 'mm')
    b_disp(c, 96, 46, 'FIGHTCAMP', 36, TEXT)
    b_caps(c, 330, 48, 'CREATION', 12, DIM)
    b_disp(c, W - 28, 18 + 19, 'THE GYM', 30, TEXT, 'rm')
    b_caps(c, W - 28, 18 + 46, 'STEP 3 OF 3  ·  NAME IT AND OPEN IT', 12, MUTED, 'rm')
    b_button(c, max(W - 900, 470), 29, 126, 38, 'BACK', 'standard', 16)
    c.rect(0, 94, W, 2, LINE_SOFT)
    c.rect(0, 96, W, 46, GROUND)
    labels = ['THE COUNTRY', 'THE CITY', 'THE GYM']
    sw = 620 / 3
    for i, l in enumerate(labels):
        x = 28 + i * sw
        here = i == 2; done = i < 2
        b_block(c, x, 106, 26, 26, GYM if here else SLATE, 3, .2)
        if done: c.text(x + 13, 119, '✓', ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 16 * S), TEXT_2, 'mm')
        else: b_disp(c, x + 13, 120, '3', 16, TEXT, 'mm')
        b_caps(c, x + 34, 119, l, 12, TEXT if here else MUTED)
    # trail right aligned (label caps 7.6/char, value 9.6/char)
    pills = [('MARKET', 'CYPRUS'), ('CITY', 'NICOSIA')]
    widths = [32 + len(a) * 7.6 + len(b) * 9.6 for a, b in pills]
    span = sum(widths) + 20 * (len(pills) - 1)
    x = W - 808 + 780 - span
    for i, ((a, b), wdt) in enumerate(zip(pills, widths)):
        if i: b_caps(c, x - 10, 119, '›', 16, DIM, 'mm')
        b_block(c, x, 104, wdt, 30, CHIP, 3, .16)
        b_caps(c, x + 12, 119, a, 12, MUTED)
        b_disp(c, x + 20 + len(a) * 7.6, 120, b, 17, TEXT)
        x += wdt + 20
    c.rect(0, 1034, W, 46, GROUND_2)
    b_caps(c, W - 24, 1034 + 23, 'GOLD OPENS THE GYM  ·  THE SHELL LOCKS ON THE OTHER SIDE  ·  780 MS', 12, DIM, 'rm', 900)
    return c

# ================================================================ BEFORE: THE DAY
def b_shell(c, active='THE DAY'):
    # rail
    b_block(c, 16, 122, 370, 900, PANEL, 3, .08)
    rx, ry = 16, 122
    b_disc(c, rx + 12 + 21, ry + 12 + 21, 21, 'NB', GYM_HI, 16)
    b_disp(c, rx + 12 + 52, ry + 12 + 12, 'NICOSIA BOXING CLUB', 21, TEXT)
    b_caps(c, rx + 12 + 52, ry + 12 + 33, 'NICOSIA  ·  TIER 1', 12, MUTED)
    b_caps(c, rx + 20, ry + 72 + 9, 'MENU', 12, MUTED)
    nav = ['THE DAY', 'GYM', 'STAFF', 'TRAINING', 'SCHEDULE', 'SCOUTING', 'RANKINGS', 'OFFICE']
    badges = {'GYM': 1, 'SCHEDULE': 2}
    for i, n in enumerate(nav):
        y = ry + 96 + i * 42
        if n == active:
            c.rect(rx + 8, y, 354, 40, GYM, 3)
            c.rect(rx + 12, y + 8, 4, 24, GOLD, 2)
        b_disp(c, rx + 8 + 16, y + 21, n, 18, TEXT if n == active else TEXT_2)
        if n in badges:
            c.circle(rx + 8 + 354 - 40 + 11, y + 20, 11, BAD)
            c.text(rx + 8 + 354 - 40 + 11, y + 20, str(badges[n]), F('plex', 12), TEXT, 'mm')
    # top bar
    tx, ty = 402, 16
    b_block(c, tx, ty, 1494, 92, PANEL, 3, .12)
    b_caps(c, tx + 14, ty + 10 + 9, 'NICOSIA BOXING CLUB  /  THE DAY', 12, MUTED)
    x = tx + 14
    for s, k in [('$ 24,180', 'gold'), ('ROSTER  4', 'standard'), ('UPKEEP  $ 1,820 / MO', 'standard')]:
        x += b_chip(c, x, ty + 36, s, k) + 8
    bellx = tx + 1494 - 14 - 150 - 212 - 14 - 40 - 320 - 14
    b_block(c, bellx, ty + 26, 40, 40, CONTROL, 3, .1)
    icon(c, 'bell', bellx + 20, ty + 46, 20, GOLD, 1.8)
    c.circle(bellx + 26 + 11, ty + 26 - 8 + 11, 11, BAD); c.text(bellx + 37, ty + 29, '3', F('plex', 12), TEXT, 'mm')
    sx = tx + 1494 - 14 - 150 - 212 - 14 - 320
    days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']; nums = [26, 27, 28, 29, 30, 31, 1]
    pips = {0: [LINK], 3: [LINK], 5: [BAD]}
    for i in range(7):
        x = sx + i * 55; today = i == 0
        c.rect(x, ty + 22, 50, 46, DAY_TODAY if today else DAY, 3, GOLD if today else EDGE, 1)
        b_caps(c, x + 25, ty + 22 + 10, days[i], 12, GOLD if today else MUTED, 'mm')
        b_disp(c, x + 25, ty + 22 + 26, str(nums[i]), 16, GOLD if today else TEXT, 'mm')
        for p, col in enumerate(pips.get(i, [])):
            c.rect(x + 22 + p * 7, ty + 22 + 38, 4, 4, col)
    ux = tx + 1494 - 14 - 150 - 212
    b_block(c, ux, ty + 14, 150, 64, GYM, 0, .18)
    b_caps(c, ux + 134, ty + 14 + 21, 'WEEK 4  ·  MON', 12, TEXT, 'rm')
    b_disp(c, ux + 134, ty + 14 + 43, '26 JAN 2026', 22, TEXT, 'rm')
    c.rect(ux + 150, ty + 14, 212, 64, GO, 0, GO_EDGE, 1)
    c.vgrad(ux + 151, ty + 15, 210, 30, (255, 255, 255, 40), (255, 255, 255, 0))
    cw_ = b_disp(c, ux + 150 + 16, ty + 14 + 24, 'CONTINUE', 26, TEXT)
    c.text(ux + 150 + 16 + cw_ + 6, ty + 14 + 23, '→', ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 20 * S), TEXT, 'lm')  # Bebas has no arrow glyph; Godot falls back
    b_caps(c, ux + 150 + 16, ty + 14 + 64 - 13, '1 MUST ANSWER FIRST', 12, (255, 255, 255, 216))

def b_frame(c, x, y, w, h, title, kind='gym'):
    c.rect(x, y, w, h, PANEL_GLASS, 4)
    c.rect(x, y, w, h, None, 4, (255, 255, 255, 16), 1)
    bg = GYM if kind == 'gym' else SLATE
    c.rect(x, y, w, 34, bg, 0)
    c.vgrad(x, y, w, 16, (255, 255, 255, 30), (255, 255, 255, 0))
    b_disp(c, x + 12, y + 18, title, 18, TEXT, 'lm', w - 24)

def before_day():
    c = C(name='before_day')
    b_shell(c)
    X, Y, W = 402, 210, 1494
    # attention strip (1 item): h = 34 + 46 + 4 = 84
    b_block(c, X, Y, W, 84, PANEL, 3, .14)
    c.rect(X, Y, 4, 84, AMBER)
    b_caps(c, X + 18, Y + 9 + 9, 'ATTENTION  ·  1 NEED YOU', 12, MUTED)
    ry = Y + 30
    c.rect(X + 18, ry + 12, 8, 8, AMBER, 4)
    b_disp(c, X + 36, ry + 15, 'LEON MARR', 20, TEXT, 'lm', 250)
    b_caps(c, X + 296, ry + 15, 'RIVALRY HEATING', 13, AMBER, 'lm', 360)
    b_caps(c, X + 668, ry + 16, 'HEAT 64  ·  +12 THIS WEEK  ·  NICOSIA FIGHT FACTORY', 12, MUTED, 'lm', W - 668 - 216)
    b_button(c, X + W - 18 - 186, ry + 6, 186, 30, 'VIEW RIVAL', 'primary', 15)
    top = Y + 84 + 14
    # hero 1010x88
    b_block(c, X, top, 1010, 88, PANEL, 3, .16)
    b_block(c, X + 12, top + 20, 48, 48, GOLD, 3, .2)
    icon(c, 'dumbbell', X + 36, top + 44, 26, INK, 2.2)
    b_caps(c, X + 72, top + 14 + 8, 'LIVE BRIEFING  ·  FIGHT', 12, MUTED)
    b_disp(c, X + 72, top + 32 + 20, 'KIAN STERLING DRAWING INTEREST FROM REGIONAL CARD', 30, TEXT, 'lm', 1010 - 88)
    c.rect(X + 72, top + 74, 48, 4, GOLD)
    y = top + 88 + 14
    tick = [('GYM', 'Morning pads booked · floor clear for Sterling', 'WEEK 4'), ('FIGHT', 'LW ladder quiet · no movement on our #8', 'WEEK 4'), ('RIVALS', 'Marr signs a second heavyweight', 'WEEK 3')]
    for k, h, d in tick:
        b_block(c, X, y, 1010, 52, PANEL, 3, .12)
        w = b_chip(c, X + 10, y + 11, k, 'gym')
        b_disp(c, X + w + 18, y + 6 + 11, h, 18, TEXT, 'lm', 1010 - w - 48)
        b_caps(c, X + w + 18, y + 28 + 8, d, 12, MUTED)
        c.rect(X + 1010 - 18, y + 16, 6, 20, GOLD)
        y += 60
    y += 6
    th = (Y + 846) - y
    b_frame(c, X, y, 1010, th, 'TODAY  ·  WHAT IS DATED')
    rows = [('TRAINING', 'SPARRING DAY', 'ON THE DAY', 'OPEN'), ('MEDICAL', 'PHYSIO CHECK · ANDREAS LOIZOU', 'ON THE DAY', 'OPEN')]
    for i, (k, t, d, a) in enumerate(rows):
        rx, ry2 = X + 12, y + 34 + 8 + i * 60
        b_block(c, rx, ry2, 1010 - 24, 54, PANEL_LO, 3, .1)
        w = b_chip(c, rx + 12, ry2 + 12, k)
        b_disp(c, rx + w + 24, ry2 + 4 + 13, t, 20, TEXT, 'lm', 1010 - 24 - w - 190)
        b_caps(c, rx + w + 24, ry2 + 30 + 9, d, 12, MUTED)
        b_button(c, rx + 1010 - 24 - 12 - 120, ry2 + 12, 120, 30, a, 'standard', 15)
    # right: asks
    ax = X + W - 470
    ah = (Y + 846) - top
    b_frame(c, ax, top, 470, ah, 'MUST ANSWER  ·  1')
    rx, ry2 = ax + 12, top + 34 + 8
    b_block(c, rx, ry2, 446, 54, PANEL_LO, 3, .1)
    w = b_chip(c, rx + 12, ry2 + 12, 'ASK')
    b_disp(c, rx + w + 24, ry2 + 17, 'JONAS REED', 20, TEXT, 'lm', 446 - w - 190)
    b_caps(c, rx + w + 24, ry2 + 39, 'RAISE', 12, MUTED)
    b_button(c, rx + 446 - 12 - 120, ry2 + 12, 120, 30, 'ANSWER', 'standard', 15)
    return c

# ================================================================ AFTER helpers (M32 guide)
LBL = lambda: F('inter', 15, 600)     # uppercase label/eyebrow, tracked
META = lambda: F('inter', 15, 450)
BODY = lambda: F('inter', 18, 400)
ROW = lambda w=600: F('inter', 18, w)
GRP = lambda: F('inter', 22, 600)
TITLE = lambda: F('inter', 30, 650)
HERO = lambda: F('inter', 44, 650)
TNUM = ['tnum']

def eyebrow(c, x, y, s, col=MUTED_32, anchor='lm', maxw=None):
    if len(s) > 24: WARN.append('%s: eyebrow over 24 chars "%s"' % (c.name, s))
    return c.text(x, y, s.upper(), LBL(), col, anchor, maxw, track=1.1)

def a_button(c, x, y, w, h, s, kind='standard', ic=None, size=18):
    if kind == 'primary':
        c.shadow(x, y, w, h, 8, 14, .4, 4)
        c.vgrad(x, y, w, h, GOLD_HI, GOLD, 8); c.rect(x, y, w, h, None, 8, alpha(GOLD_EDGE, .8), 1); fg = INK
    elif kind == 'go':
        c.vgrad(x, y, w, h, lighten(GO, .1), GO, 8); c.rect(x, y, w, h, None, 8, alpha(GO_EDGE, .9), 1); fg = INK
    elif kind == 'ghost':
        c.rect(x, y, w, h, None, 8, (255, 255, 255, 40), 1); fg = TEXT_2
    else:
        c.vgrad(x, y, w, h, lighten(CONTROL, .06), CONTROL, 8); c.rect(x, y, w, h, None, 8, (255, 255, 255, 26), 1); fg = TEXT
    f = F('inter', size, 600)
    tw = c.tw(s, f) + (26 if ic else 0)
    tx = x + (w - tw) / 2
    c.text(tx, y + h / 2, s, f, fg, 'lm', w - 16)
    if ic: icon(c, ic, tx + tw - 9, y + h / 2, 18, fg, 2.2)

def group_head(c, x, y, w, title, meta=None, ic=None):
    tx = x
    if ic:
        icon(c, ic, x + 10, y, 20, MUTED_32, 2); tx = x + 30
    c.text(tx, y, title, GRP(), TEXT, 'lm')
    if meta: c.text(x + w, y, meta, META(), MUTED_32, 'rm', feat=TNUM)

def pill(c, x, y, s, fg, bg, ic=None, h=26):
    f = F('inter', 15, 600)
    w = c.tw(s, f) + 20 + (20 if ic else 0)
    c.rect(x, y, w, h, bg, h / 2)
    tx = x + 10
    if ic: icon(c, ic, x + 17, y + h / 2, 14, fg, 1.8); tx += 20
    c.text(tx, y + h / 2, s, f, fg, 'lm')
    return w

def keycap(c, x, y, k, label):
    f = F('inter', 15, 600)
    w = c.tw(k, f) + 16
    c.rect(x, y - 13, w, 26, (255, 255, 255, 10), 5, (255, 255, 255, 40), 1)
    c.text(x + w / 2, y, k, f, TEXT_2, 'mm')
    lw = c.text(x + w + 8, y, label, META(), MUTED_32, 'lm')
    return w + 8 + lw

def ground_after(c):
    c.vgrad(0, 0, c.w, c.h, hx('#1f2636'), hx('#181d29'))
    # soft vignette light behind content
    lay = Image.new('RGBA', c.im.size, (0, 0, 0, 0))
    ImageDraw.Draw(lay).ellipse([700 * S, -300 * S, 2000 * S, 700 * S], fill=(60, 110, 170, 26))
    lay = lay.filter(ImageFilter.GaussianBlur(160 * S / 2))
    c.im.paste(lay, (0, 0), lay)

# ================================================================ AFTER: gym creation
def after_creation():
    c = C(name='after_creation'); ground_after(c)
    W = 1920
    # brand bar (0..96)
    c.vgrad(0, 0, W, 96, hx('#262f42'), hx('#222a3b'))
    c.rect(0, 95, W, 1, (255, 255, 255, 16))
    c.vgrad(28, 21, 54, 54, lighten(GYM, .12), darken(GYM, .25), 10)
    c.rect(28, 21, 54, 54, None, 10, alpha(lighten(GYM, .4), .5), 1)
    c.text(55, 49, 'FC', F('bebas', 28), TEXT, 'mm')
    c.text(96, 49, 'FIGHTCAMP', F('bebas', 34), TEXT, 'lm')
    c.text(262, 50, 'New career', META(), MUTED_32, 'lm')
    # step progress centred
    steps = [('Country', 'done'), ('City', 'done'), ('Gym', 'here')]
    sx0 = 960 - 250
    for i, (nm, st) in enumerate(steps):
        x = sx0 + i * 250
        if i:
            c.rect(x - 250 + 130, 47, 100, 2, alpha(GYM_HI, .9) if True else DIVIDER)
        if st == 'done':
            c.circle(x + 16, 48, 14, alpha(GYM, .35), GYM_HI, 1.5); icon(c, 'check', x + 16, 48, 16, TEXT, 2.2)
            c.text(x + 38, 48, nm, F('inter', 17, 500), TEXT_2, 'lm')
        else:
            c.circle(x + 16, 48, 14, GYM, lighten(GYM, .4), 1.5); c.text(x + 16, 48, '3', F('inter', 15, 700), TEXT, 'mm')
            c.text(x + 38, 48, nm, F('inter', 17, 650), TEXT, 'lm')
    a_button(c, W - 28 - 120, 29, 120, 38, 'Back', 'ghost', None, 16)
    icon(c, 'chevl', W - 28 - 120 + 26, 48, 16, TEXT_2, 2)
    # committed trail band (96..142)
    icon(c, 'pin', 110, 119, 18, MUTED_32, 1.8)
    x = 128
    x += c.text(x, 119, 'Cyprus', F('inter', 16, 500), TEXT_2, 'lm') + 10
    icon(c, 'chev', x + 4, 119, 14, DIM, 1.8); x += 18
    x += c.text(x, 119, 'Nicosia', F('inter', 16, 500), TEXT_2, 'lm') + 10
    icon(c, 'chev', x + 4, 119, 14, DIM, 1.8); x += 18
    c.text(x, 119, 'Your gym', F('inter', 16, 600), TEXT, 'lm')
    c.text(1820, 119, 'Step 3 of 3', META(), MUTED_32, 'rm')
    c.rect(100, 141, 1720, 1, (255, 255, 255, 12))

    # ---- HERO: name card (100,174 1080x300)
    hx0, hy0, hw, hh = 100, 174, 1080, 300
    c.surface(hx0, hy0, hw, hh, 3, 12)
    # faint ring-rope illustration at right of hero
    for k in range(3):
        c.line([(hx0 + 640, hy0 + 30 + k * 20), (hx0 + hw - 32, hy0 + 30 + k * 20)], (255, 255, 255, 8 + k * 3), 3)
    eyebrow(c, hx0 + 32, hy0 + 40, 'Step 3 · The gym', GYM_HI if False else lighten(GYM, .45))
    c.text(hx0 + 32, hy0 + 80, 'Name your gym', TITLE(), TEXT, 'lm')
    c.text(hx0 + 32, hy0 + 118, 'The name goes on every fight poster. Everything below opens with it.', BODY(), MUTED_32, 'lm', 1000)
    fx, fy, fw, fh = hx0 + 32, hy0 + 148, 1016, 72
    c.rect(fx, fy, fw, fh, TRACK, 10)
    c.rect(fx, fy, fw, fh, None, 10, lighten(GYM, .3), 2)
    nw = c.text(fx + 24, fy + fh / 2, 'Nicosia Boxing Club', F('inter', 30, 600), TEXT, 'lm')
    c.rect(fx + 24 + nw + 4, fy + 20, 2, 32, lighten(GYM, .5))
    c.text(fx + fw - 20, fy + fh / 2, '19 / 40', META(), MUTED_32, 'rm', feat=TNUM)
    y = fy + fh + 30
    xx = fx
    xx += c.text(xx, y, 'Or try', META(), MUTED_32, 'lm') + 14
    for s in ['Old Town Boxing', 'Ledra Street Gym', 'Kyrenia Gate BC']:
        f = F('inter', 15, 500); w = c.tw(s, f) + 28
        c.rect(xx, y - 15, w, 30, alpha(PANEL_HI, .9), 15, (255, 255, 255, 26), 1)
        c.text(xx + 14, y, s, f, TEXT_2, 'lm'); xx += w + 10

    # ---- What opens with the doors
    gy = 506
    group_head(c, 100, gy + 12, 1080, 'What opens with the doors')
    tiles = [
        ('wallet', '$25,000', '', 'Starting cash', '≈ 13 months of upkeep'),
        ('grid', '6', 'of 12', 'Floor spaces used', '6 free to build on'),
        ('dollar', '$420', '/ week', 'Upkeep', 'Rent $300 · coach $120'),
    ]
    tw_ = (1080 - 2 * 24) / 3
    for i, (ic, v, unit, lab, ctx) in enumerate(tiles):
        x = 100 + i * (tw_ + 24); y = gy + 40
        c.surface(x, y, tw_, 132, 1, 10)
        c.rect(x + 20, y + 20, 36, 36, alpha(GYM, .22), 8)
        icon(c, ic, x + 38, y + 38, 20, lighten(GYM, .5), 2)
        c.text(x + 70, y + 38, lab, F('inter', 16, 500), TEXT_2, 'lm')
        vw = c.text(x + 20, y + 88, v, F('inter', 36, 650), TEXT, 'lm', feat=TNUM)
        if unit: c.text(x + 20 + vw + 8, y + 92, unit, F('inter', 18, 500), MUTED_32, 'lm')
        if ic == 'grid':
            bx0 = x + tw_ - 20 - 12 * 13
            for k in range(12):
                c.rect(bx0 + k * 13, y + 80, 10, 18, lighten(GYM, .2) if k < 6 else None, 2, None if k < 6 else (255, 255, 255, 60), 1)
        c.text(x + 20, y + 116, ctx, META(), MUTED_32, 'lm', tw_ - 40)

    # ---- Starter floor (100,698 1080x264)
    fy0 = 698
    c.surface(100, fy0, 1080, 264, 1, 12)
    group_head(c, 132, fy0 + 36, 1016, 'Starter floor', 'Move and build after opening')
    cell = 80; gx0, gy0 = 132, fy0 + 70
    # floor board
    c.rect(gx0 - 8, gy0 - 8, 6 * cell + 16, 2 * cell + 16, alpha(TRACK, .85), 10)
    for k in range(7): c.line([(gx0 + k * cell, gy0), (gx0 + k * cell, gy0 + 2 * cell)], (255, 255, 255, 12), 1)
    c.line([(gx0, gy0 + cell), (gx0 + 6 * cell, gy0 + cell)], (255, 255, 255, 12), 1)
    # ring 2x2
    rx, ry = gx0 + 6, gy0 + 6; rs = 2 * cell - 12
    c.rect(rx, ry, rs, rs, hx('#3a4d6e'), 6)
    for k, col in enumerate([hx('#d9d4c4'), hx('#c0392b'), hx('#d9d4c4')]):
        m = 8 + k * 9
        c.rect(rx + m, ry + m, rs - 2 * m, rs - 2 * m, None, 4, col, 2)
    for px_, py_ in [(rx + 6, ry + 6), (rx + rs - 6, ry + 6), (rx + 6, ry + rs - 6), (rx + rs - 6, ry + rs - 6)]:
        c.circle(px_, py_, 5, hx('#111621'), hx('#8a94a8'), 1.5)
    # heavy bag (2,0)
    bxc, byc = gx0 + 2 * cell + cell / 2, gy0 + cell / 2
    c.rect(gx0 + 2 * cell + 6, gy0 + 6, cell - 12, cell - 12, alpha(PANEL_HI, .8), 6)
    c.circle(bxc, byc, 20, hx('#8b3a2e'), hx('#b8574a'), 2); c.circle(bxc, byc, 6, hx('#5c241c'))
    # weight bench (2,1)
    wx, wy = gx0 + 2 * cell + 6, gy0 + cell + 6
    c.rect(wx, wy, cell - 12, cell - 12, alpha(PANEL_HI, .8), 6)
    c.rect(wx + 26, wy + 12, 16, cell - 36, hx('#4a5a78'), 4)
    c.line([(wx + 8, wy + 22), (wx + cell - 20, wy + 22)], hx('#aab4c6'), 3)
    c.rect(wx + 6, wy + 14, 8, 16, hx('#1e2430'), 2, hx('#aab4c6'), 1); c.rect(wx + cell - 26, wy + 14, 8, 16, hx('#1e2430'), 2, hx('#aab4c6'), 1)
    # free region (3..5 x 0..1)
    frx, fry = gx0 + 3 * cell + 6, gy0 + 6
    c.rect(frx, fry, 3 * cell - 12, 2 * cell - 12, alpha(GYM, .08), 8)
    c.dashed(frx, fry, 3 * cell - 12, 2 * cell - 12, alpha(lighten(GYM, .45), .6), 8)
    c.circle(frx + (3 * cell - 12) / 2, fry + 50, 16, alpha(GYM, .35)); icon(c, 'plus', frx + (3 * cell - 12) / 2, fry + 50, 16, TEXT, 2.2)
    c.text(frx + (3 * cell - 12) / 2, fry + 88, '6 free spaces', F('inter', 17, 600), TEXT, 'mm')
    c.text(frx + (3 * cell - 12) / 2, fry + 112, 'Build after opening', META(), MUTED_32, 'mm')
    # item list right
    lx = gx0 + 6 * cell + 48; ly = gy0 + 10
    items = [('ring', 'Boxing ring', '2 × 2 spaces', 'Good as new', GOOD, 'check'),
             ('activity', 'Heavy bag', '1 space', 'Worn · 72%', AMBER, 'alert'),
             ('dumbbell', 'Weight bench', '1 space', 'Good as new', GOOD, 'check')]
    for i, (ic, nm, sp, st, col, glyph) in enumerate(items):
        y = ly + i * 56
        c.rect(lx, y, 40, 40, alpha(PANEL_HI, .9), 8)
        icon(c, ic, lx + 20, y + 20, 20, TEXT_2, 2)
        c.text(lx + 56, y + 11, nm, F('inter', 18, 600), TEXT, 'lm')
        c.text(lx + 56, y + 31, sp, META(), MUTED_32, 'lm')
        # state = glyph + text (never hue only)
        rx2 = 1148
        wst = c.tw(st, F('inter', 15, 600))
        if glyph == 'check':
            c.text(rx2, y + 20, st, F('inter', 15, 600), TEXT_2, 'rm')
            icon(c, 'check', rx2 - wst - 14, y + 20, 14, col, 2.2)
        else:
            c.text(rx2, y + 20, st, F('inter', 15, 600), AMBER, 'rm', feat=TNUM)
            c.poly([(rx2 - wst - 22, y + 27), (rx2 - wst - 14, y + 12), (rx2 - wst - 6, y + 27)], outline=None, fill=None)
            c.line([(rx2 - wst - 22, y + 27), (rx2 - wst - 14, y + 12), (rx2 - wst - 6, y + 27), (rx2 - wst - 22, y + 27)], AMBER, 1.8)
            c.line([(rx2 - wst - 14, y + 17), (rx2 - wst - 14, y + 22)], AMBER, 1.8)

    # ---- right column: fighters (1212,174 608x400)
    rx0, rw = 1212, 608
    c.surface(rx0, 174, rw, 400, 1, 12)
    group_head(c, rx0 + 32, 174 + 38, rw - 64, 'Your first fighters', '4 come with the gym', None)
    ppl = [('Kian Sterling', 'Lightweight · 22', '6–1', 0), ('Jonas Reed', 'Welterweight · 26', '9–4–1', 1),
           ('Mia Torres', 'Featherweight · 24', '4–0', 2), ('Andreas Loizou', 'Middleweight · 19', '1–1', 1)]
    for i, (n, l, rec, tone) in enumerate(ppl):
        y = 174 + 76 + i * 76
        if i: c.rect(rx0 + 32, y - 8, rw - 64, 1, (255, 255, 255, 14))
        portrait(c, rx0 + 32 + 26, y + 28, 26, True, GYM, tone)
        c.text(rx0 + 100, y + 18, n, F('inter', 19, 600), TEXT, 'lm')
        c.text(rx0 + 100, y + 42, l, META(), MUTED_32, 'lm')
        c.text(rx0 + rw - 32, y + 18, rec, F('inter', 19, 600), TEXT, 'rm', feat=TNUM)
        c.text(rx0 + rw - 32, y + 42, 'Record', META(), MUTED_32, 'rm')

    # ---- commit card (1212,598 608x364)
    cy0 = 598
    c.surface(rx0, cy0, rw, 364, 2, 12)
    eyebrow(c, rx0 + 32, cy0 + 40, 'Ready to open')
    c.text(rx0 + 32, cy0 + 82, 'Nicosia Boxing Club', F('inter', 30, 650), TEXT, 'lm', rw - 64)
    icon(c, 'pin', rx0 + 40, cy0 + 122, 18, MUTED_32, 1.8)
    c.text(rx0 + 58, cy0 + 122, 'Nicosia, Cyprus', BODY(), TEXT_2, 'lm')
    icon(c, 'calendar', rx0 + 40, cy0 + 156, 18, MUTED_32, 1.8)
    c.text(rx0 + 58, cy0 + 156, 'First day: Monday 5 January 2026', BODY(), TEXT_2, 'lm')
    c.rect(rx0 + 32, cy0 + 190, rw - 64, 1, (255, 255, 255, 18))
    a_button(c, rx0 + 32, cy0 + 216, rw - 64, 64, 'Open gym', 'primary', 'arrow', 20)
    c.text(rx0 + rw / 2, cy0 + 314, 'Saves to slot 1. The name is permanent.', META(), MUTED_32, 'mm')

    # foot (1034..1080)
    c.rect(0, 1034, W, 46, hx('#1a202c'))
    c.rect(0, 1034, W, 1, (255, 255, 255, 12))
    x = 1820 - 300
    x2 = 1820
    wA = c.tw('Open gym', META()) + c.tw('Enter', F('inter', 15, 600)) + 24
    keycap(c, x2 - wA, 1057, 'Enter', 'Open gym')
    wB = c.tw('Back', META()) + c.tw('Esc', F('inter', 15, 600)) + 24
    keycap(c, x2 - wA - 32 - wB, 1057, 'Esc', 'Back')
    return c

# ================================================================ AFTER: THE DAY
def a_shell(c):
    # brand in the free corner above the rail
    c.vgrad(36, 36, 44, 44, lighten(GYM, .12), darken(GYM, .25), 9)
    c.text(58, 59, 'FC', F('bebas', 24), TEXT, 'mm')
    c.text(94, 59, 'FIGHTCAMP', F('bebas', 30), TEXT, 'lm')
    # rail
    c.surface(16, 122, 370, 900, 1, 12)
    crest(c, 40, 146, 40, GYM, 'NB')
    c.text(96, 158, 'Nicosia Boxing Club', F('inter', 18, 650), TEXT, 'lm', 280)
    c.text(96, 181, 'Nicosia · Tier 1', META(), MUTED_32, 'lm')
    c.rect(36, 214, 330, 1, (255, 255, 255, 16))
    nav = [('sun', 'The day'), ('dumbbell', 'Gym'), ('users', 'Staff'), ('activity', 'Training'), ('calendar', 'Schedule'), ('search', 'Scouting'), ('trophy', 'Rankings'), ('briefcase', 'Office')]
    badges = {'Gym': 1, 'Schedule': 2}
    for i, (ic, n) in enumerate(nav):
        y = 230 + i * 52
        act = n == 'The day'
        if act:
            c.rect(28, y, 346, 44, alpha(GYM, .30), 8)
            c.rect(28, y + 10, 3, 24, lighten(GYM, .5), 2)
        icon(c, ic, 60, y + 22, 20, lighten(GYM, .55) if act else MUTED_32, 2)
        c.text(86, y + 22, n, F('inter', 17, 600 if act else 500), TEXT if act else TEXT_2, 'lm')
        if n in badges:
            s = str(badges[n])
            c.rect(374 - 16 - 28, y + 10, 28, 24, AMBER, 12)
            c.text(374 - 16 - 14, y + 22, s, F('inter', 15, 700), INK, 'mm', feat=TNUM)
    c.rect(36, 952, 330, 1, (255, 255, 255, 16))
    icon(c, 'gear', 60, 986, 20, MUTED_32, 2); c.text(86, 986, 'Settings', F('inter', 17, 500), TEXT_2, 'lm')
    icon(c, 'save', 220, 986, 18, MUTED_32, 2); c.text(242, 986, 'Save', F('inter', 17, 500), TEXT_2, 'lm')
    # top bar
    tx, ty, tw, th = 402, 16, 1494, 92
    c.surface(tx, ty, tw, th, 1, 12)
    # cash
    x = tx + 24
    c.rect(x, ty + 26, 40, 40, alpha(GOLD, .16), 10); icon(c, 'wallet', x + 20, ty + 46, 20, GOLD, 2)
    c.text(x + 54, ty + 36, '$24,180', F('inter', 22, 650), TEXT, 'lm', feat=TNUM)
    c.text(x + 54, ty + 62, 'Cash · −$1,820 / month', META(), MUTED_32, 'lm', feat=TNUM)
    x += 54 + 200
    c.rect(x - 16, ty + 22, 1, 48, (255, 255, 255, 18))
    c.rect(x + 8, ty + 26, 40, 40, alpha(GYM, .22), 10); icon(c, 'users', x + 28, ty + 46, 20, lighten(GYM, .5), 2)
    c.text(x + 62, ty + 36, '4 fighters', F('inter', 22, 650), TEXT, 'lm', feat=TNUM)
    c.text(x + 62, ty + 62, '1 booked · 3 in camp', META(), MUTED_32, 'lm', feat=TNUM)
    # continue unit from the right
    gw, gh = 204, 64
    gx = tx + tw - 14 - gw; gy = ty + 14
    a_button(c, gx, gy, gw, gh, '', 'go')
    cwid = c.text(gx + 22, gy + 25, 'Continue', F('inter', 20, 700), INK, 'lm')
    icon(c, 'arrow', gx + 22 + cwid + 18, gy + 26, 18, INK, 2.4)
    c.text(gx + 22, gy + 48, '1 answer needed first', F('inter', 15, 600), alpha(INK, .85), 'lm')
    dx = gx - 16 - 150
    c.text(dx + 150, ty + 36, 'Mon 26 Jan', F('inter', 20, 650), TEXT, 'rm', feat=TNUM)
    c.text(dx + 150, ty + 62, 'Week 4 · 2026', META(), MUTED_32, 'rm', feat=TNUM)
    # week strip
    cw, gap = 44, 6
    sx = dx - 24 - (7 * cw + 6 * gap)
    days = ['M', 'T', 'W', 'T', 'F', 'S', 'S']; nums = [26, 27, 28, 29, 30, 31, 1]
    marks = {3: 'dot', 5: 'fight'}
    for i in range(7):
        xx = sx + i * (cw + gap); today = i == 0
        if today:
            c.rect(xx, ty + 16, cw, 60, GYM, 8, lighten(GYM, .4), 1)
        else:
            c.rect(xx, ty + 16, cw, 60, alpha(TRACK, .6), 8)
        c.text(xx + cw / 2, ty + 30, days[i], F('inter', 15, 600), TEXT if today else MUTED_32, 'mm')
        c.text(xx + cw / 2, ty + 52, str(nums[i]), F('inter', 18, 650), TEXT, 'mm', feat=TNUM)
        m = marks.get(i)
        if m == 'dot': c.circle(xx + cw / 2, ty + 68, 3, LINK)
        if m == 'fight':
            c.poly([(xx + cw / 2, ty + 64), (xx + cw / 2 + 5, ty + 69), (xx + cw / 2, ty + 74), (xx + cw / 2 - 5, ty + 69)], fill=BAD)
    bx = sx - 24 - 44
    c.rect(bx, ty + 24, 44, 44, alpha(PANEL_HI, .9), 10, (255, 255, 255, 24), 1)
    icon(c, 'bell', bx + 22, ty + 45, 22, TEXT_2, 2)
    c.rect(bx + 26, ty + 16, 24, 20, lighten(GYM, .1), 10); c.text(bx + 38, ty + 26, '3', F('inter', 15, 700), TEXT, 'mm', feat=TNUM)

def after_day():
    c = C(name='after_day'); ground_after(c)
    a_shell(c)
    # page header
    c.text(402, 164, 'The day', TITLE(), TEXT, 'lm')
    c.text(402 + c.tw('The day', TITLE()) + 20, 167, 'Monday 26 January · week 4 of the season', BODY(), MUTED_32, 'lm')
    L0, LW, R0, RW = 402, 972, 1398, 498
    # ---- HERO (402,210 972x420)
    hy, hh = 210, 420
    c.surface(L0, hy, LW, hh, 3, 14)
    # faint ropes
    for k in range(3):
        c.line([(L0 + 560, hy + 30 + k * 20), (L0 + LW - 32, hy + 30 + k * 20)], (255, 255, 255, 8 + 3 * k), 3)
    icon(c, 'trophy', L0 + 44, hy + 44, 18, lighten(GYM, .55), 2)
    eyebrow(c, L0 + 62, hy + 44, "Today's lead · Fight", lighten(GYM, .55))
    portrait(c, L0 + 36 + 60, hy + 150, 60, True, GYM, 0)
    tx = L0 + 188
    c.wrap(tx, hy + 108, 'Kian Sterling is drawing interest from a regional card', TITLE(), TEXT, LW - 188 - 40, 40, 2)
    c.wrap(tx, hy + 190, 'Kouris Promotions wants a lightweight on 14 February. Sterling fits the weight and the record.', BODY(), MUTED_32, LW - 188 - 48, 27, 2)
    # facts with labels
    fx = tx; fy = hy + 272
    facts = [('6–1', 'Record'), ('#8', 'Lightweight, Cyprus'), ('$1,200', 'Purse offered'), ('19 days', 'Until fight night')]
    for v, l in facts:
        vw = c.tw(v, F('inter', 26, 650), TNUM); lw = c.tw(l, META())
        c.text(fx, fy, v, F('inter', 26, 650), TEXT, 'lm', feat=TNUM)
        c.text(fx, fy + 28, l, META(), MUTED_32, 'lm')
        fx += max(vw, lw) + 40
    a_button(c, tx, hy + hh - 84, 220, 52, 'Review offer', 'primary', 'arrow', 18)
    a_button(c, tx + 236, hy + hh - 84, 120, 52, 'Later', 'ghost', None, 18)
    # ---- TODAY (402,654 972x296)
    ty0 = hy + hh + 24; th = 296
    c.surface(L0, ty0, LW, th, 1, 12)
    group_head(c, L0 + 28, ty0 + 36, LW - 56, 'Today', '2 things dated', 'clock')
    rows = [('activity', 'Sparring day', 'Sterling and Torres · 10:00 · counts toward fight prep', 'Open'),
            ('medkit', 'Physio check: Andreas Loizou', 'Right hand · day 3 of 10 · cleared for pad work', 'Open')]
    for i, (ic, t, d, a) in enumerate(rows):
        y = ty0 + 72 + i * 72
        if i: c.rect(L0 + 28, y - 6, LW - 56, 1, (255, 255, 255, 14))
        c.rect(L0 + 28, y + 6, 44, 44, alpha(GYM, .2), 10); icon(c, ic, L0 + 50, y + 28, 22, lighten(GYM, .5), 2)
        c.text(L0 + 88, y + 18, t, F('inter', 19, 600), TEXT, 'lm', LW - 300)
        c.text(L0 + 88, y + 42, d, META(), MUTED_32, 'lm', LW - 300, feat=TNUM)
        a_button(c, L0 + LW - 28 - 104, y + 8, 104, 40, a, 'standard', None, 16)
    y = ty0 + 72 + 2 * 72
    c.rect(L0 + 28, y - 6, LW - 56, 1, (255, 255, 255, 14))
    c.text(L0 + 88, y + 24, 'Nothing else is dated today.', BODY(), MUTED_32, 'lm')
    c.text(L0 + LW - 28 - 22, y + 24, 'Open schedule', F('inter', 16, 600), LINK, 'rm')
    icon(c, 'chev', L0 + LW - 28 - 8, y + 24, 14, LINK, 2)
    # ---- NEEDS YOU (1398,210 498x376)
    ny, nh = 210, 376
    c.surface(R0, ny, RW, nh, 1, 12)
    group_head(c, R0 + 28, ny + 36, RW - 56, 'Needs you', None, None)
    c.rect(R0 + 28 + c.tw('Needs you', GRP()) + 12, ny + 24, 28, 24, AMBER, 12)
    c.text(R0 + 28 + c.tw('Needs you', GRP()) + 26, ny + 36, '2', F('inter', 15, 700), INK, 'mm')
    asks = [(True, 1, 'Jonas Reed', 'Asks for a raise', '$600 → $750 a week', ('lock', 'Blocks Continue', AMBER), 'Answer'),
            (False, 0, 'Leon Marr', 'Rivalry is heating up', 'Heat 64 of 100 · up 12 this week', ('flame', 'Heating', BAD_TEXT), 'View rival')]
    for i, (ours, tone, n, h1, h2, st, a) in enumerate(asks):
        y = ny + 72 + i * 146
        if i: c.rect(R0 + 28, y - 10, RW - 56, 1, (255, 255, 255, 14))
        portrait(c, R0 + 28 + 26, y + 26, 26, ours, GYM, tone)
        c.text(R0 + 94, y + 14, n, F('inter', 19, 600), TEXT, 'lm')
        c.text(R0 + 94, y + 38, h1, F('inter', 17, 500), TEXT_2, 'lm')
        c.text(R0 + 94, y + 62, h2, META(), MUTED_32, 'lm', feat=TNUM)
        icn, stl, col = st
        pill(c, R0 + 94, y + 84, stl, col, alpha(col, .14), icn)
        a_button(c, R0 + RW - 28 - 120, y + 80, 120, 36, a, 'standard', None, 16)
        if not ours:
            c.text(R0 + RW - 28, y + 14, 'Other gym', META(), MUTED_32, 'rm')
    # ---- ON THE WIRE (1398,610 498x340)
    wy = ny + nh + 24; wh = (ty0 + th) - wy
    c.surface(R0, wy, RW, wh, 1, 12)
    group_head(c, R0 + 28, wy + 36, RW - 56, 'On the wire', None, 'news')
    wire = [('dumbbell', 'Morning pads booked for Sterling', 'Gym · week 4'),
            ('trophy', 'Lightweight ladder quiet this week', 'Rankings · week 4'),
            ('flame', "Marr's gym signs a second heavyweight", 'Rivals · week 3')]
    for i, (ic, h1, m) in enumerate(wire):
        y = wy + 70 + i * 64
        if i: c.rect(R0 + 28, y - 8, RW - 56, 1, (255, 255, 255, 14))
        icon(c, ic, R0 + 40, y + 16, 18, MUTED_32, 1.8)
        c.text(R0 + 64, y + 14, h1, F('inter', 17, 500), TEXT, 'lm', RW - 92)
        c.text(R0 + 64, y + 38, m, META(), MUTED_32, 'lm', feat=TNUM)
    c.text(R0 + RW - 28 - 22, wy + wh - 30, 'All news', F('inter', 16, 600), LINK, 'rm')
    icon(c, 'chev', R0 + RW - 28 - 8, wy + wh - 30, 14, LINK, 2)
    return c

# ================================================================ annotation + boards
def annotate(img, notes, title):
    W, H = img.size
    side = 600
    out = Image.new('RGB', (W + side, H), (17, 21, 31))
    out.paste(img, (0, 0))
    c = C(W + side, H, (17, 21, 31, 255), 'annot')
    c.im.paste(out.resize(((W + side) * S, H * S)), (0, 0))
    for i, (x, y, head, body) in enumerate(notes):
        n = str(i + 1)
        c.circle(x, y, 20, GOLD, INK, 2)
        c.text(x, y + 1, n, F('inter', 18, 800), INK, 'mm')
    X = W + 40
    c.text(X, 60, title, F('inter', 24, 700), TEXT, 'lm')
    c.text(X, 92, 'M32 AFTER · annotated', META(), MUTED_32, 'lm')
    y = 140
    for i, (x, yy, head, body) in enumerate(notes):
        c.circle(X + 16, y + 12, 16, GOLD); c.text(X + 16, y + 13, str(i + 1), F('inter', 16, 800), INK, 'mm')
        c.text(X + 46, y + 12, head, F('inter', 18, 650), TEXT, 'lm', side - 90)
        n = c.wrap(X + 46, y + 40, body, F('inter', 16, 400), MUTED_32, side - 96, 23, 5)
        y += 40 + n * 23 + 26
    c.text(X, H - 40, "Copy = EXAMPLE, words are Kalli's", F('inter', 15, 600), MUTED_32, 'lm')
    return c

def board(before, after, title, before_label, path):
    W, H = 3840, 1080 + 72 + 56
    c = C(W, H, (13, 16, 24, 255), 'board')
    c.im.paste(before.resize((1920 * S, 1080 * S)), (0, 72 * S))
    c.im.paste(after.resize((1920 * S, 1080 * S)), (1920 * S, 72 * S))
    c.rect(1918, 72, 4, 1080, (13, 16, 24, 255))
    c.text(32, 36, 'BEFORE', F('inter', 24, 800), BAD_TEXT, 'lm')
    c.text(150, 36, before_label, F('inter', 17, 500), TEXT_2, 'lm')
    c.text(1920 + 32, 36, 'AFTER', F('inter', 24, 800), GOOD, 'lm')
    c.text(1920 + 138, 36, 'M32 proposal: ' + title + ' (same shell geometry, M32 style guide)', F('inter', 17, 500), TEXT_2, 'lm')
    c.text(32, H - 28, "M32 · Maria (art direction) · 2026-09-25 · 1920×1080 per side · Copy = EXAMPLE, words are Kalli's · strings in BEFORE come from live code where the code has them", F('inter', 15, 500), MUTED_32, 'lm')
    c.save(path)

if __name__ == '__main__':
    bc = before_creation().save(os.path.join(OUT, 'M32_mock_gym_creation_before.png'))
    ac = after_creation().save(os.path.join(OUT, 'M32_mock_gym_creation_after.png'))
    bd = before_day().save(os.path.join(OUT, 'M32_mock_the_day_before.png'))
    ad = after_day().save(os.path.join(OUT, 'M32_mock_the_day_after.png'))
    board(bc, ac, 'gym creation', 'reconstruction from live code (CreationFlowPanel/CreationChrome/UIKit @2662c01), not a screenshot',
          os.path.join(OUT, 'M32_mock_gym_creation_before_after.png'))
    board(bd, ad, 'THE DAY', 'reconstruction from live code (ShellChrome/DayFeedPanel/UIKitShell @2662c01), not a screenshot',
          os.path.join(OUT, 'M32_mock_the_day_before_after.png'))
    nc = [(1180, 176, 'One focal element, one gold', 'The name field lives in the only hero surface; Open gym is the single gold action on the board.'),
          (1540, 1057, 'Developer captions removed', 'Foot cue ("…780 MS", "GOLD IS ILLEGAL UNTIL…") becomes key hints only. Uppercase survives only in short eyebrows.'),
          (102, 548, 'Every number has context', '$25,000 ≈ 13 months of upkeep; 6 of 12 with a fill bar; $420 / week with its split.'),
          (606, 770, 'No empty dark slots', 'Six black EMPTY cells become one dashed region: "6 free spaces · Build after opening".'),
          (1214, 290, 'Portraits, not initials', 'Silhouette discs in the gym tint; record as tabular figures with a label.'),
          (1818, 600, 'Three surfaces + hero', 'Sunk input, resting cards, one lifted commit card, one hero. No coloured header bars; radius 8–12.')]
    annotate(ac, nc, 'Gym creation').save(os.path.join(OUT, 'M32_mock_gym_creation_after_annotated.png'))
    nd = [(1372, 212, 'One hero, one gold', 'The lead story owns the only gold (Review offer). Everything else is standard or a link.'),
          (1894, 212, 'Needs you = one list', 'Attention strip + Must answer merged. Row = portrait, one sentence, state pill with glyph, one action.'),
          (1352, 470, 'Sentence case, Inter', 'Body and titles in sentence case; uppercase only for eyebrows of 24 characters or fewer. Mono retired from text.'),
          (404, 18, 'Numbers carry context', '$24,180 cash · −$1,820 / month; Heat 64 of 100, up 12; #8 lightweight, Cyprus; 19 days until fight night.'),
          (404, 894, 'No empty frames', 'Panels size to content. A quiet slot is one line plus a route ("Open schedule").'),
          (18, 252, 'Shell: icons + tint', 'Rail icons + sentence-case labels; gym tint marks the active item (gold freed for actions); Continue uses dark ink (8.1:1).')]
    annotate(ad, nd, 'THE DAY').save(os.path.join(OUT, 'M32_mock_the_day_after_annotated.png'))
    print('\n'.join(WARN) if WARN else 'no text warnings')
