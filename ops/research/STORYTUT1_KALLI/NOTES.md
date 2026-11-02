# STORYTUT1_KALLI - notes (S218)

Recast of first_hour.json and ludo_cast.json to "The House That Holds" (Mara "Wire" Solano, Calder House Gym). Not installed in assets/data; Claude installs after review.

## Renamed ids and exit_flags (code keys on these)
- first_lap / first_lap_done -> fighter_profile / profile_read (mechanic changed: station lap -> profile read)
- pad_editor / chain_locked (unlocks pad_work_editor) -> technique_tree / one_two_set (unlocks technique_tree)
- mini_camp_setup -> week_plan (exit_flag camp_confirmed kept: still the plan confirm)
- week_review_1 id kept; exit_flag film_studied -> wear_reviewed; film_study and sparring_tell_bank unlocks moved to pre_fight_1
- fight_week_tuesday -> fight_week_thursday (exit_flag lock_sacrifice_done kept; now also unlocks regional_booking)
- weigh_in now unlocks rivalry_heat; Extreme Drain cut (choice is Safe Sweat vs Sauna Push)
- corner_2 / corner_2_done merged into doctor (exit_flag doctor_resolved kept)
- office_trap moved from minute 59 to 41 (id and trap_answered kept)
- chapter_1_end / chapter_1_done is new (unlocks sandbox_full)
- opponent ids: tommy_perez -> elena_perez; ray_miller -> nadia_kerr

## Leo / Anvil Street replacements
- gym_intro decision: "assign Leo's default stance" -> "keep Calder House or rename; Mara is waiting in the locker room"
- gym_intro line: "Welcome to Anvil Street" -> "You have the keys and a lease"
- first_lap decision and line ("Route Leo", "Drag Leo") -> beat replaced by Mara's profile
- pad_editor decision ("Leo's primary drilled sequence") -> "Mara's first drilled technique, the 1-2"
- cast prospect leo_vance -> mara_solano; his traits (Iron Will etc.) -> her original traits
- sparring partner "Sal Barone, The Anvil" -> "Bea Marsh, The Wall" (nickname echoed Anvil Street)
- every other him/his -> her (Perez's tell; corner tones Fire Her Up / Tell Her the Truth); Malik Adebayo, Damian Cross, Ray Miller -> the women prospects and opponents

## NOT COMPUTED
- weight_class changed super_welter (154 lb) -> welter (147 lb); needs a valid enum in code.
- card_names is a new block so Jace Vellin appears only as a name; drop it if the loader rejects unknown keys.
- Cast stat keys stay at the file's 7; mapping them onto the profile's 6 core stats + 2 readouts is the profile code's job, not checked.
- Beat 12 carries two decisions (book the regional card, then Lock One Sacrifice One) to fit 16 slots.
