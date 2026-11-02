# Q33 DIGEST — 815fe06

## Job 1 — read survives real text

`sys.stdout.reconfigure(encoding="utf-8", errors="replace")` at startup,
guarded with `hasattr(sys.stdout, "reconfigure")` for environments without
it. Applied to both stdout and stderr. Every `print` of bot text now
survives em-dashes, en-dashes, arrows and curly quotes on Windows cp1252.

Verified: `read --to "Maria Art Director"` printed "Boards 1–5" and
"Boards 6–10" (en-dashes) without a UnicodeEncodeError.

## Job 2 — newchat

The "New chat" button (aria-label="New chat", a 24x24 BUTTON in the
sidebar) opens a **dropdown picker** with "Create new Bot", "Create group
chat", and the bot list. It is NOT a direct reset — it is a two-step flow:

1. Click the "New chat" button → dropdown appears
2. Click the bot's name in the dropdown → new empty chat opens

`JS_PICK_CHAT_TARGET` was added for step 2. Both `cmd_newchat` and
`send --new` use the two-step flow. Every failure path prints `FAIL:` and
returns exit code 2 — never exits 0 silently on a miss.

## Verification on Maria Art Director (idle since M14)

| Step | Result |
|------|--------|
| `read --to "Maria Art Director"` before | Full transcript, en-dashes survived |
| `newchat --to "Maria Art Director"` | `ok: started a new chat with 'Maria Art Director'` |
| `read --to "Maria Art Director"` after | `No messages yet` |

## send --new

`send --to <bot> --new --message "..."` resets the chat then sends in one
action. This is the form Claude will use for deliveries.

## Safety

Only Maria Art Director was touched. Kalli (K27) and John Research (J16)
were not tested against.
