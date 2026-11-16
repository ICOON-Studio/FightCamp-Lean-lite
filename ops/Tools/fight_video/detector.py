"""A person detector whose weights may be sold: RF-DETR (Roboflow) from an ONNX file we export ourselves.  (Claude, S495)

Why: the default detector (YOLOX-m "humanart") was trained on Human-Art, which is offered for non-commercial use only.
Roboflow's licence text (github.com/roboflow/rf-detr, docs/snippets/license-rfdetr.md, read 2026-11-16): "The `rfdetr`
package, RF-DETR Nano, Small, Medium and Large detection ... are released under the Apache 2.0 license, so they're
commercially usable out of the box". The larger and smaller sizes (XL, 2XL, Atto, Femto, Pico) are under another licence.

Export once, in its own environment (PyTorch is needed only for this step):
    python -m venv E:\\FightCamp\\fight_video_data\\venv_rfdetr
    venv_rfdetr\\Scripts\\python -m pip install --no-cache-dir rfdetr onnx onnxruntime
    venv_rfdetr\\Scripts\\python ops\\Tools\\fight_video\\detector.py export small E:\\FightCamp\\fight_video_data\\models\\rfdetr_small.onnx
Use:  pose.py <video> <out.npz> --detector <that .onnx>      analyze.py <video> --out <dir> --detector <that .onnx>

This wrapper is ours (rtmlib also has an RFDETR class, but its file says it was adapted from a repository whose licence
is non-commercial, so it is not used). The ONNX has one input (1,3,H,W, RGB, ImageNet-normalised) and two outputs:
`dets` (1,Q,4) boxes as centre-x, centre-y, width, height in 0..1 and `labels` (1,Q,C) class scores before the sigmoid.
The person class is found once from the model's own class list at export (PERSON below; COCO id 1)."""
import os
import sys

import numpy as np

PERSON = 1
MEAN = np.array([0.485, 0.456, 0.406], np.float32)
STD = np.array([0.229, 0.224, 0.225], np.float32)


class RFDetrPerson:
    """det(img_bgr) -> (N,4) float32 person boxes x1,y1,x2,y2 in the picture's pixels, best first."""

    def __init__(self, onnx_path, use_gpu=True, score=0.4, person=PERSON):
        import onnxruntime as ort
        providers = ["CPUExecutionProvider"]
        if use_gpu and "DmlExecutionProvider" in ort.get_available_providers():
            providers = [("DmlExecutionProvider", {"performance_preference": "high_performance"}), "CPUExecutionProvider"]
        opts = ort.SessionOptions()
        opts.intra_op_num_threads = 4
        opts.log_severity_level = 3
        self.session = ort.InferenceSession(onnx_path, sess_options=opts, providers=providers)
        inp = self.session.get_inputs()[0]
        self.name, self.h, self.w = inp.name, int(inp.shape[2]), int(inp.shape[3])
        self.outs = [o.name for o in self.session.get_outputs()]
        self.score, self.person = score, person

    def __call__(self, img):
        import cv2
        H, W = img.shape[:2]
        x = cv2.cvtColor(cv2.resize(img, (self.w, self.h), interpolation=cv2.INTER_LINEAR), cv2.COLOR_BGR2RGB).astype(np.float32) / 255.0
        x = ((x - MEAN) / STD).transpose(2, 0, 1)[None]
        got = dict(zip(self.outs, self.session.run(self.outs, {self.name: x})))
        boxes = got.get("dets", got[self.outs[0]])[0]
        logits = got.get("labels", got[self.outs[1]])[0]
        p = 1.0 / (1.0 + np.exp(-logits[:, self.person]))
        keep = p >= self.score
        b, p = boxes[keep], p[keep]
        out = np.stack([(b[:, 0] - b[:, 2] / 2) * W, (b[:, 1] - b[:, 3] / 2) * H, (b[:, 0] + b[:, 2] / 2) * W, (b[:, 1] + b[:, 3] / 2) * H], axis=1) if len(b) else np.zeros((0, 4))
        return out[np.argsort(-p)].astype(np.float32)


def export(size, out_path):
    """Run inside the rfdetr environment: download the official checkpoint and write its ONNX to out_path."""
    import shutil
    import tempfile

    import rfdetr
    cls = {"nano": "RFDETRNano", "small": "RFDETRSmall", "medium": "RFDETRMedium", "large": "RFDETRLarge"}[size]
    model = getattr(rfdetr, cls)()
    names = getattr(model, "class_names", None)
    print("classes (first 5):", list(names.items())[:5] if isinstance(names, dict) else names[:5] if names else "?")
    tmp = tempfile.mkdtemp(prefix="rfdetr_export_")
    model.export(output_dir=tmp)
    found = [os.path.join(r, f) for r, _, fs in os.walk(tmp) for f in fs if f.endswith(".onnx")]
    if not found:
        sys.exit("no .onnx written in %s" % tmp)
    os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
    shutil.copyfile(found[0], out_path)
    print("wrote %s (%.0f MB) from %s %s" % (out_path, os.path.getsize(out_path) / 1e6, cls, getattr(rfdetr, "__version__", "")))


def compare(synth_dir, onnx_path, every=10, split=None):
    """Both detectors against the EXACT boxes of our synthetic clips (every `every`-th frame): how often each boxer is
    found (overlap of half the box or more), how tight the box is, how many other boxes come with it, and the speed."""
    import json
    import time

    import cv2
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import pose
    import synth_data as sd
    yolo, _, device = pose.load_models(True)
    dets = {"YOLOX-m humanart (research only)": yolo, "RF-DETR Small (Apache-2.0 weights)": RFDetrPerson(onnx_path)}
    tally = {k: dict(boxers=0, found=0, frames=0, both=0, iou=0.0, extra=0, secs=0.0) for k in dets}
    by_cam = {k: {} for k in dets}

    def iou(a, b):
        x0, y0, x1, y1 = max(a[0], b[0]), max(a[1], b[1]), min(a[2], b[2]), min(a[3], b[3])
        inter = max(0.0, x1 - x0) * max(0.0, y1 - y0)
        return inter / ((a[2] - a[0]) * (a[3] - a[1]) + (b[2] - b[0]) * (b[3] - b[1]) - inter + 1e-6)

    rows = sd.manifest(synth_dir, split)
    for r in rows:
        L = sd.load_labels(synth_dir, r["clip"])
        cap = cv2.VideoCapture(os.path.join(synth_dir, r["clip"] + ".mp4"))
        f = 0
        while True:
            ok, img = cap.read()
            if not ok:
                break
            if f % every == 0:
                gt = [g for g in L["boxes"][f] if (g[2] - g[0]) * (g[3] - g[1]) > 400]
                for name, det in dets.items():
                    t0 = time.time()
                    got = np.asarray(det(img), np.float32).reshape(-1, 4)
                    t = tally[name]
                    t["secs"] += time.time() - t0
                    best = [max([iou(g, b) for b in got] or [0.0]) for g in gt]
                    hits = [v for v in best if v >= 0.5]
                    t["boxers"] += len(gt)
                    t["found"] += len(hits)
                    t["iou"] += sum(hits)
                    t["frames"] += 1
                    t["both"] += len(hits) == len(gt)
                    t["extra"] += max(0, len(got) - len(hits))
                    c = by_cam[name].setdefault(r["camera"], [0, 0])
                    c[0] += len(hits)
                    c[1] += len(gt)
            f += 1
    out = {}
    print("%d clips, every %dth frame, on %s" % (len(rows), every, device))
    for name, t in tally.items():
        out[name] = dict(boxer_found=t["found"] / max(1, t["boxers"]), both_found=t["both"] / max(1, t["frames"]), overlap=t["iou"] / max(1, t["found"]),
                         other_boxes_per_frame=t["extra"] / max(1, t["frames"]), ms_per_frame=1000 * t["secs"] / max(1, t["frames"]), frames=t["frames"],
                         by_camera={k: v[0] / max(1, v[1]) for k, v in by_cam[name].items()})
        o = out[name]
        print("%-36s boxer found %.1f%%, both in a frame %.1f%%, overlap %.2f, other boxes a frame %.2f, %.0f ms a frame | by camera: %s" % (
            name, 100 * o["boxer_found"], 100 * o["both_found"], o["overlap"], o["other_boxes_per_frame"], o["ms_per_frame"],
            ", ".join("%s %.0f%%" % (k, 100 * v) for k, v in sorted(o["by_camera"].items()))))
    return out


if __name__ == "__main__":
    a = sys.argv
    if len(a) == 4 and a[1] == "export":
        export(a[2], a[3])
    elif len(a) >= 4 and a[1] == "compare":
        import json
        res = compare(a[2], a[3])
        if "--json" in a:
            json.dump(res, open(a[a.index("--json") + 1], "w"), indent=1)
    else:
        print(__doc__)
