# J60 - John: free image-to-video generators, Oct 2026 terms + commercial licence

Collected S154 2026-10-03 from gbot thread "John Research" (messages t37s334-t37s335, delivered inline; the attached file with quoted clauses was not landed).
STATUS: reference only - the job it served (animating painted 2.5D rooms) was dropped by D33 (operator S151: "i think i like the 3d aspect better"). M = official page read, B = press/blog, U = not found.

| Service | Free image-to-video | Free credits → clips | Free max res / watermark | Commercial in a sold game | Start=end frame | Sign-up |
|---|---|---|---|---|---|---|
| Kling | Yes (B) | No monthly credits (M). Daily login credits ~66 (B) → ~3 clips/day | 720p (B), watermark (M) | **No on free** ("not for commercial use", M). Paid: not restricted (M) | Yes in API (M); same image both ends untested | Email (B) |
| Hailuo / MiniMax | Yes (B) | One-time pack that expires after 3 days, ~200 credits (B) → ~4–6 clips | 768p (B), watermark (M) | **No on free**; paid only (M) | U | Email (B) |
| Vidu | Yes (M) | 40 credits/month (M) → ~8 clips (B) | 720p (B), watermark (B) | **No on free**; paid users extended (M) | **Yes** (M) | Email, no card (B) |
| PixVerse | Yes (M) | 60 once + 30/day (M) → about 1 short low-res clip/day | 540p (M), watermark | **No / unclear**: non-commercial unless licensed (M); no licence row on any plan | Yes (M) | Email, no card (B) |
| Pika | Only with bought credits | 0 free (M) | U | **No on Free** (M); Creator $35/mo | U | Email |
| Luma Dream Machine | **No free tier listed** (M) | 0 | n/a | Paid only (M) | Keyframes and Loop (B) | n/a |
| Runway | Yes, Gen-4 Turbo (B) | 125 credits once, never renews (M) → 5 clips total | U, watermark (M) | Terms don't split by plan (M), but free clips carry Runway's watermark | **No**, first frame only (B) | Email (B) |
| Google Flow (Veo) | Yes, first and first+last frame (M) | **50 credits/day** (M) → ~5 Lite or ~2 Fast clips/day | 720p (M); visible mark is a toggle | **Unclear**: "Google won't claim ownership" (M) | **Yes** (M) | Google account, 18+; Cyprus supported (M). The Flow pages conflict on whether you must subscribe, so test |
| Gemini app | Yes but subscription required (M) | 0 | n/a | n/a | U | n/a |
| Meta AI / Vibes | Yes, "Animate" (B) | Free, quota U | U | **Not granted** (M) | U | Meta account (B) |
| Sora | **Shut down** (M) | n/a | n/a | n/a | n/a | n/a |
| Dola (Seedance) | Yes | ~4 points/day = 2 clips (your account) | U | **No per ToS** (M) | U | works for you |
| Dreamina (CapCut) | Yes, Seedance 2.5 (M) | **120 credits/day** (M) → ~1–2 ten-second clips/day (B) | U, watermark | **Ambiguous**: "not… for any commercial or unauthorized purposes" (M) | U | CapCut/TikTok/Google (B) |
| Doubao / Jimeng (China) | U | U | U | U | U | Likely Chinese phone (B) |
| Open / local | Free image-to-video | Hardware | Licence for a sold game | Start=end frame |
|---|---|---|---|---|
| **Wan 2.2** | Yes (I2V-A14B, TI2V-5B at 720p) | 5B: 24 GB VRAM (M). A14B: 80 GB in the official script; community GGUF runs smaller (B) | **Yes**: Apache 2.0, "We claim no rights over the your generated contents" (M) | Wan 2.1 has an official FLF2V-14B-720P (M); none in 2.2 |
| **LTX-2.x** | Yes | 32 GB+ (M); fp8 and offload can lower it | **Conditional**: free under US$10M revenue with affiliates (M); Attachment A not read | **Yes**, keyframe pipeline (M) |
| HunyuanVideo-1.5 | Yes | 14 GB min (M) | **Not usable in the EU or UK** (M) | U |
| CogVideoX | I2V is the 5B model | n/a | 5B has a separate licence, not read | U |
| Stable Video Diffusion 1.1 | Yes, short clips | n/a | Free under US$1M revenue (M) | No |
| Hugging Face Spaces | Yes (Wan 2.2 5B Space) | Free GPU is 5 min/day (M) → 1–3 clips/day (B) | Follows the model licence | Space-dependent |
| Higgsfield | U | n/a | U; free output is watermarked (M) | U |

**Wan 3.0 (hosted)** has first and last frame, up to 1080p (M, Hugging Face page). Its free tier is B only, and I found no open weights. Don't assume Apache for 3.0.

**My top 3 for animating an exact still with a locked camera, small motion, loopable, in a commercial Steam game:**
1. **Wan 2.2 local.** It's the only grant I could read in one clear sentence, with no watermark and unlimited retries. For a loop, use the 2.1 first+last-frame model with the same image at both ends, or ping-pong it in post. Without a 24 GB GPU, rent one by the hour or use fal.ai.
2. **LTX-2.5 local.** It has the closest thing to a true first=last loop among the open models. It's free for us if the entity and its affiliates are under US$10M. It needs a heavier GPU.
3. **Kling Standard, one paid month.** It's the only hosted option where I read an explicit commercial grant, watermark removal and start/end frame together. It's US$6.99 for ~33 clips, enough for 8 rooms with retries. If you need free only, use **Google Flow** for look-development and previews (50 credits/day, first+last frame, Cyprus supported). Don't ship Flow clips until the Google terms have been read by a lawyer.

**Text-to-video:** it would not suit this job, because it can't lock the exact painted room. At most it could invent reference motion, which you'd then animate from a still.

**Things to check before relying on this:**
- Kling's 66 credits/day, Hailuo's 200 credits, Vidu's 5 credits per clip and Luma's loop feature are B. Re-check them in the live apps.
- Dreamina and Dola are different products with different budgets: 120/day against ~4/day. Dreamina's commercial clause is ambiguous.
- I didn't check what GPU you have. That decides whether Wan or LTX is practical.
- I didn't research Steam's AI-content disclosure.

