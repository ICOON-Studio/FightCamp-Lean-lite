- [Older memory index](MEMORY_ARCHIVE.md) — ~165 S27-S177 lessons; grep it by keyword before work in those areas
## Operator and goals
- [CEO and lead developer](user_role_ceo_and_lead_dev.md) — act as CEO of a tiny-budget studio
- [The operator is the playtester](feedback_operator_is_the_playtester.md) — 40 years of games; the gap is a playable .exe
- [Claude is the developer](feedback_claude_is_the_developer.md) — never ask him technical questions; decide, report
- [Demo has NO deadline](project_demo_deadline_2026-10-04.md) — S151 "chill with the demo remove the deadline"
- [Cascadeur ends 10-27](project_cascadeur_deadline_oct27.md) — all Cascadeur jobs done before 2026-10-27
- [S216 rule breaks](feedback_s216_rule_breaks.md) — no early handover, no unverified "passed", queue+questions first
- [Focus cap 14 rows](feedback_focus_cap_s220.md) — S220 scope cut; PARKED rows need his call
- [No defaults without direction](feedback_no_defaults_without_direction.md) — ask Ludo/agents/skills, never average
- [Delegate max every session](feedback_delegate_max_s222.md) — S222 Codex/Arena/Goose/Ludo/Grok; playable build, all mechanics ON
- [New features ship ON](feedback_new_features_ship_on.md) — S221 GAME_ON, no opt-in flags
- [Router off, no remembered numbers](feedback_router_off_and_no_remembered_numbers.md) — he picks model; measure first
## Visual and stills
- [S217 visual + heat](feedback_s217_visual_and_heat.md) — gap/noses/wrists/feet on every still; skill visual-gate
- [No feet-only stills](feedback_no_feet_only_stills.md) — stills only via still_framing.gd save_if_framed
- [MetaHuman only, never MPFB](feedback_metahuman_only_no_mpfb.md) — no MPFB/generator/Tripo body anywhere
- [Cursor cannot see images](feedback_cursor_cannot_see_images.md) — open stills yourself; brief geometric checks
- [Gym floor = training floor](feedback_gym_floor_is_a_training_floor.md) — no bath/board/chairs on the floor
- [GYM4 club design](project_gym4_club_design.md) — S178 paper plan; interviews at reception; 2:00 day
- [Animated meters](feedback_animated_meters.md) — every bar tweens + band-change pulse
- [Benchmark real-world numbers](feedback_benchmark_real_world_before_design.md) — never give an AI our value as baseline
## Ludo (lead designer)
- [Ludo is the lead designer](feedback_ludo_is_lead_designer.md) — design/mechanics/art to Ludo; operator approves
- [Ludo CLI for agents](reference_ludo_cli.md) — Codex calls Ludo 3D animate/rig; Ask Ludo chat not included
- [Upload pictures to Ludo, never describe](feedback_ludo_upload_pictures.md) — S220 operator rule
- [Ludo.ai tool + picture upload](reference_ludo_ai.md) · [wrong chat trap](feedback_ludo_wrong_chat.md) · [facts sheet](feedback_ludo_game_facts_sheet.md)
- Ludo asks: [huge batched](feedback_ludo_huge_questions.md) · [PC deep-sim line](feedback_ludo_not_mobile_deep_manager_sim.md) · [animation too](feedback_ludo_for_animation.md)
- [Ludo gate for visuals + UI](feedback_ludo_gate_visual_ui.md) · [no placeholder screens](feedback_no_placeholder_screens_ask_ludo.md)
## Board and operator questions
- [Ask pending issues at start](feedback_ask_pending_issues_at_start.md) · [questions on the board](feedback_questions_for_operator_go_on_the_board.md)
- [Check board before "waiting"](feedback_check_board_before_waiting.md) — read questions.json answers first; attachments inside the repo
- [Approvals visible on the board](feedback_approvals_visible_on_board.md) · [short board questions](feedback_short_board_questions.md)
- [Ops board at wrap-up](feedback_opsboard_at_wrapup.md) · [plan items are objects](feedback_board_plan_objects.md)
- [Restart board via its task](feedback_restart_board_via_task.md) — Start-ScheduledTask only; no pythonw
- [Review board kept clean](feedback_review_board_clean.md) — S226 cleared; one post per thing, --supersedes for new versions
- [Markup Board loop](feedback_markup_board_review_loop.md) · [send docs as .txt](feedback_send_docs_as_txt.md)
## PC, heat, processes
- [PC limits 84 C](feedback_pc_limits_80c.md) · [watchdog gates launches](feedback_watchdog_gate_before_launch.md)
- [S218 PC crash](project_pc_crash_s218.md) — 3 agents + Godot tests hung the PC; 2 PC agents max; governor autostarts
- [Seed worktree import cache](feedback_seed_worktree_import_cache.md) — seed_godot_cache.ps1 before every launch
- [Retire worktrees on merge](feedback_retire_worktrees_on_merge.md) — ~7.3 GB each on E:
- [Run jobs in background](feedback_run_jobs_in_terminal_background.md) · [leave a waiter](feedback_leave_a_waiter_when_you_wait.md)
- [Cheaper mode](feedback_usage_economy.md) — one stage per session, connectors off
## Agents
- [How to reach each agent](reference_how_to_reach_each_agent.md) — S224 exact launch/collect per seat; Grok bots via xAI API now
- [Agent notes](reference_agent_notes.md) · [roles S178](feedback_agent_roles_s178.md) · [cloud first](feedback_cloud_first.md)
- [Cursor reads the issue body](feedback_cursor_reads_issue_body.md) — S225 rework rounds go in the body, then relabel
- [Arena diff collapsed sections](feedback_arena_diff_collapsed_sections.md) — S225 expand button[aria-expanded] before the copy-out
- [Arena seat](reference_arena_agent.md) — S218: Brave showed a blank skeleton; the built-in pane works
- [Grok bots: Tools/gbot.py](reference_gbot_cli.md) · [gbot 32k limit](feedback_gbot_32k_arg_limit.md) · Grok Dev = coding seat via the app (S218)
- Codex: [gpt-6-astra (S222, was sol)](feedback_codex_use_sol_not_astra.md) · [CODEX_REPO](feedback_codex_launch_needs_codex_repo.md) · [plan quota first](feedback_use_codex_plan_quota_first.md) · [access](feedback_codex_access_everything.md) · [app locks sandbox](feedback_codex_desktop_app_locks_sandbox.md)
- [agy: file tools only](feedback_agy_file_tools_only.md) · [Actions $40 budget](reference_actions_budget.md)
## Git, tests, collecting
- [Audit before more fix rounds](feedback_audit_before_more_fix_rounds.md) — S224: 2 red rounds -> code audit; a digest is not code
- [Collect pure PRs by diff+parse+test](feedback_pure_pr_collect_cheaply.md) · [author layouts](feedback_author_layouts_not_pack.md)
- [No git apply -3 here](feedback_no_apply3_in_shared_checkout.md) · [check master first](feedback_check_master_before_calling_a_branch_uncollected.md)
- [All dependent tests after data change](feedback_run_all_dependent_tests_after_a_data_change.md)
## Browsers and tools
- [Brave + downloads done](feedback_brave_downloads_done_not_described.md) · [Brave when Chrome is off](feedback_brave_when_no_chrome.md)
- [Installed skills S225](reference_installed_skills_s225.md) — Superpowers, grill-me, handoff, frontend-design, webapp-testing at user scope; CLAUDE.md wins
- [Jev router](reference_jev_router.md) (disabled S216) · [usage band mod removed](reference_usage_meter_mod.md)
## Sessions
- [S188](project_session_S188_2026-10-09.md) [S190](project_session_S190_2026-10-10.md) [S193](project_session_S193_2026-10-10.md) [S195](project_session_S195_2026-10-10.md) [S196](project_session_S196_2026-10-11.md) [S197](project_session_S197_2026-10-11.md) [S198](project_session_S198_2026-10-11.md) [S199](project_session_S199_2026-10-11.md) [S200](project_session_S200_2026-10-11.md) [S201](project_session_S201_2026-10-11.md) [S202](project_session_S202_2026-10-11.md) [S203](project_session_S203_2026-10-11.md) [S204](project_session_S204_2026-10-11.md) [S205](project_session_S205_2026-10-11.md) [S206](project_session_S206_2026-10-12.md)
- [S207](project_session_S207_2026-10-12.md) [S208](project_session_S208_2026-10-12.md) [S209](project_session_S209_2026-10-12.md) [S210](project_session_S210_2026-10-12.md) [S211](project_session_S211_2026-10-12.md) [S212](project_session_S212_2026-10-12.md) [S213](project_session_S213_2026-10-12.md) [S214](project_session_S214_2026-10-13.md) [S216](project_session_S216_2026-10-13.md) [S217](project_session_S217_2026-10-13.md) [S218](project_session_S218_2026-10-13.md) [S219](project_session_S219_2026-10-13.md) [S220](project_session_S220_2026-10-13.md) [S221](project_session_S221_2026-10-14.md) [S222](project_session_S222_2026-10-14.md) [S223](project_session_S223_2026-10-14.md) [S224](project_session_S224_2026-10-14.md) [S225](project_session_S225_2026-10-15.md) [S226](project_session_S226_2026-10-15.md)
- [One owner per area (S227)](feedback_one_owner_per_area_s227.md) — rooms/anims/floor/UI each one seat, one item at a time from Ludo; questions never derail
- [Ludo checks EVERY screen (S227)](feedback_ludo_checks_every_screen_s227.md) — menus/modals/tooltips too; one UI bible; census one screen per round
- [No Codex tasks (S228)](feedback_no_codex_tasks_s228.md) — operator: assign Codex nothing; collecting finished runs is fine
- [Ludo writes code, Claude integrates (S228)](feedback_ludo_writes_code_claude_integrates_s228.md) — Codex replaced; Ludo part E code, Claude tests/stills/Cascadeur/merge
