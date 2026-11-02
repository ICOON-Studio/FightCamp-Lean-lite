---
name: feedback_ludo_huge_questions
description: "S193 operator - one Ludo question costs 1 credit, so make each question HUGE (many roadmap areas) and fold all Ludo's suggested follow-ups into one prompt"
metadata:
  node_type: memory
  type: feedback
  originSessionId: cd33dfe9-32ff-43e1-aa6c-8a7486af1c9f
  modified: 2026-10-10T03:48:39.068Z
---

Operator S193 (verbatim): "ludo can contribute huge amount of code and design to the project 1 question consumes 1 token make the questions huge to cover extensive areas of the roadmap. ask the follow ups suggested prompts fromludo inone prompt".

**Why:** a Ludo ask is billed per question, not per length; small questions waste credits and turns.
**How to apply:** batch every pending Ludo follow-up offer plus any open design/code area into ONE numbered prompt; say "TEXT ONLY" (a mixed ask with a mockup item got an image-only answer in round 13); tell Ludo to stop at a section boundary and write "CONTINUE FROM SECTION n" because its replies cut at ~22-28k chars, then send "continue". Built-in browser pane is signed in to Ludo too (no Chrome needed); send via `button.send-message` click in JS after execCommand insertText into `.input-box`; read the reply from the chat container's innerText. SAVE WITHOUT RETYPING: run `python -I Tools/arena_rx.py <scratch dir>` (127.0.0.1:8799) in the background, then in the Ludo tab `location.href='http://127.0.0.1:8799/?name=rN.txt&d='+encodeURIComponent(text)` (fetch and img are CSP-blocked; a top-level navigation works); navigate back to the project, click the "Ask Ludo" button, history is intact. Never navigate away while Ludo is still streaming. Append to research/LUDO_*.md with python.

Related: [[feedback_ludo_is_lead_designer]], [[reference_ludo_ai]].

S197 operator (verbatim): "include all his next reccomendations prompts always" - EVERY Ask Ludo message (incl. CONTINUE) carries all of Ludo's suggested follow-up prompts shown under his last answer, copied verbatim. Use Ask Ludo (app.ludo.ai/assistant, the full page), NOT the side 'Ludo AI Chat Assistant' panel (operator S197: "use ask ludo instead of the assistant"); the side panel ask dropped the counter 342 -> 141.

SAVE A LUDO ANSWER FAST (S197): in the Chrome tab JS `await navigator.clipboard.writeText(text)` (works; execCommand copy does not), then PowerShell `Get-Clipboard -Raw | Out-File -Encoding utf8 <file>` - one step for 30k chars. The 8799 link-save is blocked in Chrome and JS returns truncate at ~1k chars. It overwrites the operator's clipboard - say so.

S198 operator (verbatim): "when prompting ludo always try to get the max contextt out of it it can generate more than 32k characters , ,test its limits , write that to your rules". Every Ask Ludo prompt asks for the LONGEST, most complete answer (no summarising, full specs/code), never caps the length, and does NOT pre-emptively cut at ~22k; let Ludo run until its own cutoff, record the char count of each reply (LUDO_LIMITS log in research/LUDO_*.md) so the true ceiling is measured, then "continue" from where it stopped. The old "~22-28k" figure above is a floor seen so far, not the limit.
MEASURED S198 (round 33): one reply tops out at ~27-30k chars (27.4k / 29.6k / 27.5k), stops mid-sentence with NO continue marker even when asked; send "continue from <exact last heading>" + his follow-ups each time. 3 replies = ~84k for one question. Attach input takes ONE image per upload ("Too many files" on 2). The continue send via JS click sometimes does not fire - screenshot and click the arrow button.
