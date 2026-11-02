# C95 — Karate technique vocabulary and grading map

## Result

**DOCUMENTED — Japan Karate Association (JKA):** this catalogue uses the JKA *Kyu / Dan Grading Guideline*, effective 1 April 2017, as its grading spine. It maps 10th–7th kyu to tier 1, 6th–4th kyu to tier 2, 3rd–1st kyu to tier 3, and dan material to tier 4 exactly as C95 requires.

**DOCUMENTED — count:** 168 nodes: tier 1 = 25, tier 2 = 46, tier 3 = 61, tier 4 = 36. Ten nodes are real Shotokan combinations whose prerequisites enumerate every component. All 168 nodes carry JKA rank vocabulary in `grade` and a monotonic `grade_rank`.

This is a Shotokan/JKA catalogue, not a claim that every karate style shares one syllabus.

**NEW EFFECT KEYS:** none. Every effect key in the JSON was observed in the existing catalogue.

**ADDED BRANCHES:** `stances`, `tai_sabaki`, `zuki`, `uchi`, `uke`, `geri`, `nage_kansetsu`, `combinations`. These replace the fixed generic frame in this research file so the art is legible by technique family.

## Sources and claim labels

- **DOCUMENTED — JKA:** Japan Karate Association, *Kyu / Dan Grading Guideline* (effective 2017-04-01), https://www.jka.or.jp/wp/wp-content/uploads/2017/06/b98c5e1514acc9fe91bbbc4b2fcb79f2.pdf
- **DOCUMENTED — Funakoshi:** Gichin Funakoshi, *Karate-do Kyohan: The Master Text*, trans. Tsutomu Ohshima, Kodansha International. The nine named throws are also indexed at https://iainabernethy.com/content/9-throws-funakoshi
- **DOCUMENTED — secondary vocabulary check:** “List of Shotokan techniques,” https://en.wikipedia.org/wiki/List_of_shotokan_techniques (used only to corroborate spellings/categories; the page warns that it needs citations, so it never overrides JKA or Funakoshi).
- **INFERENCE:** the name is documented, but its tier is assigned from mechanical difficulty, timing against resistance, hand conditioning, or the JKA grade of the kata in which the secondary list places it.
- **NOT FOUND:** the item was not found in the official JKA grading guideline. This does not mean it is absent from Shotokan; it means JKA does not publish it in that exam list.

## Syllabus mapping

| JKA grade band | Tier | Directly documented examples |
|---|---:|---|
| 10th–7th kyu | 1 Foundation | Choku-zuki, Jun-zuki, Age-uke, Soto-uke, Gedan-barai, Uchi-uke, Shuto-uke, Mae-geri, Yoko-geri-keage |
| 6th–4th kyu | 2 Core | Yoko-geri-kekomi, Gyaku-zuki, Nukite |
| 3rd–1st kyu | 3 Advanced | Ren-geri, Mawashi-geri, Yoko-empi-uchi, Uraken-uchi, Sanbon-renzuki |
| dan | 4 Signature | Kizami-zuki combinations at 1st dan; Ushiro-geri at 4th dan; examiner-selected kihon thereafter |

**DOCUMENTED — divergence:** WKF is primarily a competition federation/rules authority, not the source of a universal kyu syllabus. Kyokushin and Goju-ryu use materially different grading vocabularies and emphases. This file therefore does not blend them into the JKA ladder.

## Exact grade fields

**DOCUMENTED — organisation and vocabulary:** every node uses Japan Karate Association (JKA) Shotokan ranks verbatim: `10th kyu` through `1st kyu`, followed by `1st dan` through `4th dan`. `grade_rank` orders those ranks 1 through 14 respectively. Belt colours are deliberately absent because the JKA rank name, not a country-dependent colour, is the stable vocabulary.

**DOCUMENTED:** where the JKA guideline names an examination grade, the JSON records that exact grade. Examples include Choku-zuki at 10th kyu, Jun-zuki at 9th kyu, Gyaku-zuki at 5th kyu, Nukite at 4th kyu, Sanbon-renzuki at 1st kyu, Kizami-zuki combinations at 1st dan, and Ushiro-geri at 4th dan.

**INFERENCE:** when the technique is documented Shotokan vocabulary but is **NOT FOUND** as a separately graded item in the JKA guideline, its exact grade is placed at the earliest rank of its already researched tier: 10th kyu, 6th kyu, 3rd kyu, or 1st dan. This preserves the contract's tier mapping without silently claiming that JKA examines that item by name. These are JKA rank labels used as inferred teaching positions, not invented belt colours.

## Combination tree

**DOCUMENTED — JKA grading guideline:** Sanbon-renzuki, Kizami-zuki–Gyaku-zuki, Age-uke–Gyaku-zuki, Soto-uke–Yoko-empi-uchi–Uraken-uchi–Gyaku-zuki, Shuto-uke–Nukite, Mae-geri–Jun-zuki, Mawashi-geri–Gyaku-zuki, Yoko-geri-kekomi–Gyaku-zuki, and Ashi-barai–Gyaku-zuki are Shotokan kihon chains represented as combination nodes.

**DOCUMENTED — operator worked example in contract section 10:** Kizami-zuki–Gyaku-zuki–Mawashi-geri unlocks the Blitz combination.

| Combination node | Components (all prerequisites) | Grade |
|---|---|---|
| `karate_sanbon_chain` | `karate_chokuzuki`, `karate_junzuki`, `karate_gyakuzuki` | 1st kyu |
| `karate_kizami_gyaku` | `karate_kizamizuki`, `karate_gyakuzuki` | 1st dan |
| `karate_blitz_combo` | `karate_kizamizuki`, `karate_gyakuzuki`, `karate_mawashigeri` | 1st dan |
| `karate_ageuke_gyakuzuki_combo` | `karate_ageuke`, `karate_gyakuzuki` | 5th kyu |
| `karate_sotouke_empi_uraken_gyaku_combo` | `karate_sotouke`, `karate_yokoempiuchi`, `karate_urakenuchi`, `karate_gyakuzuki` | 3rd kyu |
| `karate_shutouke_nukite_combo` | `karate_shutouke`, `karate_nukite` | 4th kyu |
| `karate_maegeri_junzuki_combo` | `karate_maegeri`, `karate_junzuki` | 9th kyu |
| `karate_mawashi_gyaku_combo` | `karate_mawashigeri`, `karate_gyakuzuki` | 3rd kyu |
| `karate_yokogeri_gyaku_combo` | `karate_yokogerikekomi`, `karate_gyakuzuki` | 5th kyu |
| `karate_ashibarai_gyaku_combo` | `karate_ashibarai`, `karate_gyakuzuki` | 3rd kyu |

Each combination is graded at its hardest component or later. No combination introduces a component that is absent as a standalone node.

## Existing 18 audit

**DOCUMENTED:** 13 existing IDs are retained where the node maps to the same technique or principle: `karate_kamae`, `karate_kizamizuki`, `karate_gyakuzuki`, `karate_maegeri`, `karate_mawashigeri`, `karate_ashibarai`, `karate_yokogeri`, `karate_uramawashi`, `karate_nidan_geri`, `karate_kizami_gyaku`, `karate_ushiro_geri`, `karate_maai_control`, `karate_sanbon_chain`.

**DOCUMENTED — tier corrections against JKA:** `karate_maegeri` moves 2→1 (10th kyu); `karate_gyakuzuki` moves 1→2 (5th kyu); `karate_mawashigeri` moves 2→3 (3rd kyu); `karate_kizamizuki` moves 1→4 (first appears in the dan combinations); `karate_ushiro_geri` moves 3→4 (4th dan).

**NOT FOUND — omitted as standalone techniques:** `karate_counter_gyaku`, `karate_sweep_finish`, `karate_deai_counter`, `karate_uke_counter`, and `karate_kizami_maegeri` are descriptive game combinations/counters, not published standalone Japanese technique names in the sources reviewed. They should be authored later as sequences that reference documented base techniques, not represented as base vocabulary.

**INFERENCE — retained composites:** `karate_kizami_gyaku` maps to the documented dan combination Kizami-zuki, Gyaku-zuki; `karate_sanbon_chain` maps to JKA’s Sanbon-renzuki; both now live in `combinations` and enumerate all components. `karate_maai_control` maps to the documented principle Maai. The IDs are retained to preserve seeded compatibility.

## Throws and locks

**DOCUMENTED — Funakoshi:** the nine throws are Byobu-daoshi, Katawa-guruma, Koma-nage, Kubi-wa, Saka-zuchi, Tani-otoshi, Tsubame-gaeshi, Ude-wa, and Yari-dama. Koma-nage and Ude-wa integrate arm control/joint leverage and therefore cover the catalogue’s missing lock/control seam without importing judo IDs.

**NOT FOUND — JKA lock ladder:** the official JKA grading guideline does not name a separate kansetsu-waza progression. I found no defensible JKA grade at which named wrist/elbow locks are examined. I therefore did not fabricate a list of Japanese lock names or pretend that judo’s kansetsu-waza syllabus is JKA karate.

## Syllabus/difficulty conflicts

- **DOCUMENTED + INFERENCE:** Kizami-zuki is mechanically a basic lead-hand straight, but the official JKA guideline first names it in a 1st-dan combination. Tier remains 4 because tier answers “when examined”; its prerequisite remains basic Kamae.
- **DOCUMENTED + INFERENCE:** several advanced kata hand forms are not named in the JKA kihon column. Their tiers are inferred from the cited Shotokan list’s kata placement and physical difficulty, not falsely attributed to a JKA grade.
- **DOCUMENTED + INFERENCE:** Funakoshi’s throws belong to the art but are absent from the modern JKA grading sheet. They are tier 4 because live balance breaking, joint control, and safe falling require resistant-partner timing.

## Cross-over candidates

- **DOCUMENTED + INFERENCE:** `karate_taniotoshi` and `karate_tsubamegaeshi` share names and likely mechanics with judo techniques; Claude should reconcile shared IDs only after comparing exact mechanics.
- **DOCUMENTED + INFERENCE:** `karate_ashibarai` overlaps judo foot sweeps as a family noun, but should not be collapsed without a specific reap/sweep comparison.
- **DOCUMENTED + INFERENCE:** `karate_kizamizuki` stays separate from a boxing jab; Shotokan stance, hip action, and retraction differ.
- **DOCUMENTED + INFERENCE:** `karate_mawashigeri` stays separate from a Muay Thai round kick; snapping/retraction mechanics differ.
- **DOCUMENTED + INFERENCE:** `karate_yokogeri` should remain separate from taekwondo side-kick nodes until chamber and hip mechanics are compared.

## Complete node inventory

Every row labels both the name source and, where necessary, the tier inference.

| ID | Technique | Branch | Tier | Evidence |
|---|---|---|---:|---|
| `karate_kamae` | Kamae and Maai | stances | 1 | DOCUMENTED — JKA guideline uses free kamae; maai is standard Shotokan vocabulary |
| `karate_shizentai` | Shizen-tai | stances | 1 | DOCUMENTED — JKA 10th kyu |
| `karate_heisokudachi` | Heisoku-dachi | stances | 1 | DOCUMENTED — JKA 10th/8th kyu |
| `karate_musubidachi` | Musubi-dachi | stances | 1 | DOCUMENTED — Shotokan technique list |
| `karate_heikodachi` | Heiko-dachi | stances | 1 | DOCUMENTED — Shotokan technique list |
| `karate_hachijidachi` | Hachiji-dachi | stances | 1 | DOCUMENTED — Shotokan technique list |
| `karate_uchihachijidachi` | Uchi-hachiji-dachi | stances | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core by balance demand |
| `karate_zenkutsudachi` | Zenkutsu-dachi | stances | 1 | DOCUMENTED — JKA 9th kyu |
| `karate_kokutsudachi` | Kokutsu-dachi | stances | 1 | DOCUMENTED — JKA 8th kyu |
| `karate_kibadachi` | Kiba-dachi | stances | 1 | DOCUMENTED — JKA 7th/6th kyu |
| `karate_fudodachi` | Fudo-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced kata stance |
| `karate_sochindachi` | Sochin-dachi | stances | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — dan kata stance |
| `karate_sanchindachi` | Sanchin-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — advanced tension stance |
| `karate_hangetsudachi` | Hangetsu-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — advanced kata stance |
| `karate_kosadachi` | Kosa-dachi | stances | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Yondan mechanics |
| `karate_nekoashidachi` | Neko-ashi-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — advanced kata stance |
| `karate_renojidachi` | Renoji-dachi | stances | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core posture |
| `karate_teijidachi` | Teiji-dachi | stances | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core posture |
| `karate_tsuruashidachi` | Tsuru-ashi-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — one-leg balance |
| `karate_sagiashidachi` | Sagi-ashi-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — one-leg balance |
| `karate_gankakudachi` | Gankaku-dachi | stances | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — dan kata stance |
| `karate_iaigoshidachi` | Iaigoshi-dachi | stances | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — advanced kneeling stance |
| `karate_ayumiashi` | Ayumi-ashi | tai_sabaki | 1 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_suriashi` | Suri-ashi | tai_sabaki | 1 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_tsugiashi` | Tsugi-ashi | tai_sabaki | 2 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_yoriashi` | Yori-ashi | tai_sabaki | 2 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_okuriashi` | Okuri-ashi | tai_sabaki | 2 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_hikiashi` | Hiki-ashi | tai_sabaki | 1 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_mawariashi` | Mawari-ashi | tai_sabaki | 2 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_taisabaki` | Tai-sabaki | tai_sabaki | 2 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_tenshin` | Tenshin | tai_sabaki | 3 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_maai_control` | Maai | tai_sabaki | 3 | DOCUMENTED — standard Shotokan movement term; INFERENCE — tier by mechanical/timing demand |
| `karate_chokuzuki` | Choku-zuki | zuki | 1 | DOCUMENTED — JKA 10th kyu |
| `karate_junzuki` | Jun-zuki (Oi-zuki) | zuki | 1 | DOCUMENTED — JKA 9th kyu |
| `karate_gyakuzuki` | Gyaku-zuki | zuki | 2 | DOCUMENTED — JKA 5th kyu |
| `karate_kizamizuki` | Kizami-zuki | zuki | 4 | DOCUMENTED — JKA 1st dan combination |
| `karate_tatezuki` | Tate-zuki | zuki | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_urazuki` | Ura-zuki | zuki | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core close punch |
| `karate_kagizuki` | Kagi-zuki | zuki | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core hook mechanics |
| `karate_agezuki` | Age-zuki | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced angle |
| `karate_gyakuagezuki` | Gyaku-age-zuki | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced reverse angle |
| `karate_heikozuki` | Heiko-zuki | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — double-hand coordination |
| `karate_awasezuki` | Awase-zuki | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — double-hand coordination |
| `karate_yamazuki` | Yama-zuki | zuki | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — dan kata method |
| `karate_hasamizuki` | Hasami-zuki | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — bilateral timing |
| `karate_morotezuki` | Morote-zuki | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — bilateral timing |
| `karate_sanbon_chain` | Sanbon-renzuki | combinations | 3 | DOCUMENTED — JKA 1st kyu |
| `karate_renzuki` | Ren-zuki | zuki | 2 | DOCUMENTED — standard Shotokan combination term; INFERENCE — Core |
| `karate_nukite` | Nukite | zuki | 2 | DOCUMENTED — JKA 4th kyu |
| `karate_ipponnukite` | Ippon-nukite | zuki | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — dan kata specialty |
| `karate_nihonnukite` | Nihon-nukite | zuki | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — specialist hand form |
| `karate_shihonnukite` | Shihon-nukite | zuki | 3 | DOCUMENTED — standard Shotokan hand form; INFERENCE — Advanced |
| `karate_ipponken` | Ippon-ken | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — conditioned hand form |
| `karate_nakadakaken` | Nakadaka-ken | zuki | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — specialist hand form |
| `karate_hiraken` | Hiraken | zuki | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — conditioned hand form |
| `karate_kizami_gyaku` | Kizami-zuki, Gyaku-zuki | combinations | 4 | DOCUMENTED — JKA dan combinations |
| `karate_urakenuchi` | Uraken-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_tettsuiuchi` | Tettsui-uchi | uchi | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_shutouchi` | Shuto-uchi | uchi | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_haitouchi` | Haito-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_haishuuchi` | Haishu-uchi | uchi | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_teishouchi` | Teisho-uchi | uchi | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_seiryutouchi` | Seiryuto-uchi | uchi | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_keitouchi` | Keito-uchi | uchi | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_kokutouchi` | Kokuto-uchi | uchi | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_washideuchi` | Washide-uchi | uchi | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_kumadeuchi` | Kumade-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_empiuchi` | Empi-uchi | uchi | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_ageempiuchi` | Age-empi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_yokoempiuchi` | Yoko-empi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_ushiroempiuchi` | Ushiro-empi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_otoshiempiuchi` | Otoshi-empi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_mawashiempiuchi` | Mawashi-empi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_maemawashiempiuchi` | Mae-mawashi-empi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_shutosakotsuuchi` | Shuto-sakotsu-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_shutosakotsuuchikomi` | Shuto-sakotsu-uchikomi | uchi | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_shutohizouchi` | Shuto-hizo-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_shutojodanuchi` | Shuto-jodan-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_shutoyokoganmenuchi` | Shuto-yoko-ganmen-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_yokourakenuchi` | Yoko-uraken-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_otoshiurakenuchi` | Otoshi-uraken-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_urakenmawashiuchi` | Uraken-mawashi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_teishofuriuchi` | Teisho-furi-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_tateteishouchi` | Tate-teisho-uchi | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_tsukiage` | Tsuki-age | uchi | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_tettsuihasamiuchi` | Tettsui-hasami-uchi | uchi | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — tier by coordination, conditioning, and kata placement |
| `karate_ageuke` | Age-uke | uke | 1 | DOCUMENTED — JKA 10th kyu |
| `karate_gedanbarai` | Gedan-barai | uke | 1 | DOCUMENTED — JKA 10th kyu |
| `karate_sotouke` | Soto-uke | uke | 1 | DOCUMENTED — JKA 10th kyu |
| `karate_uchiuke` | Uchi-uke | uke | 1 | DOCUMENTED — JKA 7th kyu |
| `karate_shutouke` | Shuto-uke | uke | 1 | DOCUMENTED — JKA 8th kyu |
| `karate_empiuke` | Empi-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_gedanmorotebarai` | Gedan-morote-barai | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_haiwanuke` | Haiwan-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Nidan |
| `karate_gedanjujiuke` | Gedan-juji-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_jodanjujiuke` | Jodan-juji-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_kaishoageuke` | Kaisho-age-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced |
| `karate_kaishohaiwanuke` | Kaisho-haiwan-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Yondan |
| `karate_kaishojujiuke` | Kaisho-juji-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Godan |
| `karate_kakiwakeuke` | Kakiwake-uke | uke | 2 | DOCUMENTED — JKA 10th kyu preparatory form; Shotokan technique list |
| `karate_moroteuke` | Morote-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Sandan |
| `karate_nagashiuke` | Nagashi-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — timing demand |
| `karate_osaeuke` | Osae-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_otoshiuke` | Otoshi-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_shutoageuke` | Shuto-age-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced |
| `karate_shutogedanbarai` | Shuto-gedan-barai | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced |
| `karate_shutomawashiuke` | Shuto-mawashi-uke | uke | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — specialist circular receive |
| `karate_sukuiuke` | Sukui-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — timing demand |
| `karate_tateshutouke` | Tate-shuto-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced |
| `karate_teosaeuke` | Te-osae-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_udebarai` | Ude-barai | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_ushirogedanbarai` | Ushiro-gedan-barai | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — rear-line awareness |
| `karate_teishouke` | Teisho-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced |
| `karate_chudansoeteuke` | Chudan-soete-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Bassai Dai method |
| `karate_tsukiuke` | Tsuki-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — intercept timing |
| `karate_morotetsukamiuke` | Morote-tsukami-uke | uke | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — grab/throw transition |
| `karate_mawashiuke` | Mawashi-uke | uke | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — Unsu method |
| `karate_haishuuke` | Haishu-uke | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Godan |
| `karate_kosauke` | Kosa-uke (Joge-uke) | uke | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Heian Sandan |
| `karate_teishoawaseuke` | Teisho-awase-uke | uke | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — Gankaku method |
| `karate_manjiuke` | Manji-uke | uke | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — Advanced |
| `karate_maegeri` | Mae-geri | geri | 1 | DOCUMENTED — JKA 10th kyu |
| `karate_maegerikeage` | Mae-geri-keage | geri | 1 | DOCUMENTED — standard Shotokan snap variant; INFERENCE — Foundation |
| `karate_maegerikekomi` | Mae-geri-kekomi | geri | 2 | DOCUMENTED — standard Shotokan thrust variant; INFERENCE — Core |
| `karate_maeashigeri` | Mae-ashi-geri | geri | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — lead-leg control |
| `karate_oimaegeri` | Oi-mae-geri | geri | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — lunging coordination |
| `karate_rengeri` | Ren-geri | geri | 3 | DOCUMENTED — JKA 3rd kyu |
| `karate_nidan_geri` | Nidan-geri | geri | 3 | DOCUMENTED — Shotokan technique list; NOT FOUND — JKA grading guideline |
| `karate_mawashigeri` | Mawashi-geri | geri | 3 | DOCUMENTED — JKA 3rd kyu |
| `karate_maeashimawashigeri` | Mae-ashi-mawashi-geri | geri | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — timing demand |
| `karate_ushiro_geri` | Ushiro-geri | geri | 4 | DOCUMENTED — JKA 4th dan |
| `karate_ushiromawashigeri` | Ushiro-mawashi-geri | geri | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — spinning control |
| `karate_uramawashi` | Ura-mawashi-geri | geri | 4 | DOCUMENTED — Shotokan technique list; NOT FOUND — JKA grading guideline |
| `karate_yokogeri` | Yoko-geri | geri | 1 | DOCUMENTED — JKA 8th kyu family |
| `karate_yokogerikeage` | Yoko-geri-keage | geri | 1 | DOCUMENTED — JKA 8th kyu |
| `karate_yokogerikekomi` | Yoko-geri-kekomi | geri | 2 | DOCUMENTED — JKA 6th kyu |
| `karate_fumikomigeri` | Fumikomi-geri | geri | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_hizageri` | Hiza-geri | geri | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core close strike |
| `karate_maehizageri` | Mae-hiza-geri | geri | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_mawashihizageri` | Mawashi-hiza-geri | geri | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — clinch timing |
| `karate_kingeri` | Kin-geri | geri | 1 | DOCUMENTED — Shotokan technique list; INFERENCE — simple front-line kick |
| `karate_mikazukigeri` | Mikazuki-geri | geri | 2 | DOCUMENTED — Shotokan technique list; INFERENCE — Core |
| `karate_gyakumikazukigeri` | Gyaku-mikazuki-geri | geri | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — reverse arc |
| `karate_kakatogeri` | Kakato-geri | geri | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — flexibility/control |
| `karate_otoshikakatogeri` | Otoshi-kakato-geri | geri | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — Signature |
| `karate_urakakatogeri` | Ura-kakato-geri | geri | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — Signature |
| `karate_tobimaegeri` | Tobi-mae-geri | geri | 3 | DOCUMENTED — Shotokan technique list; INFERENCE — jumping control |
| `karate_tobiyokogeri` | Tobi-yoko-geri | geri | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — jumping side control |
| `karate_tobimawashigeri` | Tobi-mawashi-geri | geri | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — jumping rotation |
| `karate_tobiushirogeri` | Tobi-ushiro-geri | geri | 4 | DOCUMENTED — Shotokan technique list; INFERENCE — jumping blind-line control |
| `karate_ashibarai` | Ashi-barai | geri | 3 | DOCUMENTED — Shotokan technique list; NOT FOUND — JKA grading guideline |
| `karate_byobudaoshi` | Byobu-daoshi | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_katawaguruma` | Katawa-guruma | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_komanage` | Koma-nage | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_kubiwa` | Kubi-wa | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_sakazuchi` | Saka-zuchi | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_taniotoshi` | Tani-otoshi | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_tsubamegaeshi` | Tsubame-gaeshi | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_udewa` | Ude-wa | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_yaridama` | Yari-dama | nage_kansetsu | 4 | DOCUMENTED — Gichin Funakoshi, Karate-do Kyohan; NOT FOUND — JKA grading guideline |
| `karate_blitz_combo` | Kizami-zuki - Gyaku-zuki - Mawashi-geri (Blitz) | combinations | 4 | DOCUMENTED — contract section 10 operator example |
| `karate_ageuke_gyakuzuki_combo` | Age-uke - Gyaku-zuki | combinations | 2 | DOCUMENTED — JKA kihon chain |
| `karate_sotouke_empi_uraken_gyaku_combo` | Soto-uke - Yoko-empi-uchi - Uraken-uchi - Gyaku-zuki | combinations | 3 | DOCUMENTED — JKA kihon chain |
| `karate_shutouke_nukite_combo` | Shuto-uke - Nukite | combinations | 2 | DOCUMENTED — JKA kihon chain |
| `karate_maegeri_junzuki_combo` | Mae-geri - Jun-zuki | combinations | 1 | DOCUMENTED — JKA kihon chain |
| `karate_mawashi_gyaku_combo` | Mawashi-geri - Gyaku-zuki | combinations | 3 | DOCUMENTED — JKA kihon chain |
| `karate_yokogeri_gyaku_combo` | Yoko-geri-kekomi - Gyaku-zuki | combinations | 2 | DOCUMENTED — JKA kihon chain |
| `karate_ashibarai_gyaku_combo` | Ashi-barai - Gyaku-zuki | combinations | 3 | DOCUMENTED — JKA kihon chain |

