# Puncher's chance test link - inviting a tester through Tailscale (S565)

Address for testers: https://beast.tail6f2f5c.ts.net:8443/  -  the owner's log: https://beast.tail6f2f5c.ts.net:8443/owner/log
Source for every step below: Tailscale's own pages, read 2026-11-26 (kb/1084 sharing, kb/1312 serve).

## What Tailscale's pages say
- A person you share a machine with reaches ONLY that machine, nothing else on your tailnet, and it is visible only to
  that one person.
- A rule written for everyone (`"src": ["*"]`) ALSO applies to invited people. The starting rule file of a tailnet is
  such a rule, so with it an invited guest reaches every port of the shared PC - here also the pages on ports 443, 80
  and 9791, not only the game on 8443.
- Invited people are the group `autogroup:shared`. Tailscale's example of a limit:
  `{ "src": ["autogroup:shared"], "dst": ["*"], "ip": ["80", "443"] }`
- A shared machine can receive connections from the guest but cannot start any to him.
- `tailscale serve` passes the guest's login to our gate ("external users who have accepted a share of your device"),
  so the notice and the log work for him as they do for the owner. Not passed: tagged devices, Funnel traffic.

## STEP 1 IS DONE (S565, 2026-11-26, on his "Signed in to Chrome now": Claude made the edit in his Tailscale admin page)
His file was the plain starting file. In "grants": `{"src": ["*"], "dst": ["*"], "ip": ["*"]}` became
`{"src": ["autogroup:member"], "dst": ["*"], "ip": ["*"]}` and one rule was added below it:
`{"src": ["autogroup:shared"], "dst": ["*"], "ip": ["8443"]}`. Saved. Checked on this PC right after: the rules applied
to beast now list his two devices only (PC and iPhone), all ports - no longer every Tailscale address; the game still
opens through the Tailscale address. The phone did not answer a ping at that moment (asleep or offline): not proven
from the phone. TO UNDO: put `"*"` back in that first rule and delete the second (Access controls -> JSON editor).
The Chrome with his Tailscale sign-in is "Browser 1" (select_browser); "Browser 2" is not signed in.

## Step 1 as it was written before the edit - limit a guest to the game (once; the owner, in his Tailscale admin page, Access controls)
CHECKED S565 on this PC (`tailscale debug netmap`): ONE rule is applied to beast - every Tailscale address may reach
every port. That is the starting "everyone" rule, so a guest would reach all of it. The file itself was not read (Chrome
was not signed in to Tailscale). With the starting file it is two changes:
1. the everyone rule becomes a members-only rule: `"src": ["*"]` -> `"src": ["autogroup:member"]`
   (his own PC and phone keep everything; tagged devices, if he ever makes any, would need their own rule);
2. one new rule for guests - only the game's port:
   `{ "src": ["autogroup:shared"], "dst": ["*"], "ip": ["8443"] }`
   (in the older "acls" spelling: `{ "action": "accept", "src": ["autogroup:shared"], "dst": ["*:8443"] }`).
Save. Check from the guest's side later: the game opens, https://beast.tail6f2f5c.ts.net/ (port 443) does not.

## Step 2 - the invite (the owner; Machines page)
1. Machines -> the row `beast` -> its menu -> Share.
2. "Share by email": his brother's email -> Share. Or "Copy invite link" (single use) and send it to him.
   An unused link expires after 30 days.
3. His brother installs Tailscale, signs in with any account of his own, and accepts the invite.
4. He opens the address above: the notice, "I agree", the game.

## Step 3 - check (the owner)
/owner/log shows his brother's login under "Agreed to the notice" and each page he opened with its version.

## Taking access away
Machines -> beast -> Share -> remove him. The whole address: `tailscale serve --https=8443 off`.
