# S126 - "Space Bunny" AI, a quick verdict (Claude, 2026-09-29)

Operator asked: "is space bunny ai any good?" It is **Space Bunny Alpha**, an anonymous ("stealth") LLM on OpenRouter,
released 2026-09-23: free, 1M-token context, text/image/video in, text out (openrouter.ai/stealth/space-bunny-alpha).

Evidence read: the OpenRouter model page (gives no maker, no data policy) and one independent 10-task test
(huggingface.co/blog/karmen-beatapi/space-bunny-tested-real-cases-evaluation). Strong at long iterative builds, long-context
retrieval (200K) and video phase segmentation (within ~1 s of human labels). **Weak at spatial geometry and frame-to-frame
consistency** (failed on the first attempt across tests). One tester lost track mid-session on a long agent run.

## Verdict for FightCamp: not now
- Its weak spot is our work: 3D poses, contact, clipping.
- The maker is unknown. OpenRouter stealth models usually log prompts for the provider (NOT confirmed on the page read), so no
  private repo code goes to it.
- Agents are not the bottleneck (two-agent ceiling; Kimi was parked after gaming a test).
- A possible later trial: a free SECOND EYE on rendered boxing clips (its video segmentation is its best result), sending only
  renders, never code. Backlog, not queued.

## Prior research
searched: space bunny, spacebunny (0 relevant hits).
