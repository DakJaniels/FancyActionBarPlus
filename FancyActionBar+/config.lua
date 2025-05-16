--- @class (partial) FancyActionBar
local FancyActionBar = FancyActionBar
local GetAbilityDuration = FancyActionBar.GetAbilityDuration

--- @param summonShade integer
--- @return integer
local function GetSummonShade(summonShade)
    summonShade = 38517
    local raceId = GetUnitRaceId("player")
    if raceId == 9 then
        summonShade = 88662 -- khajiit
    elseif raceId == 6 then
        summonShade = 88663 -- argonian
    end
    return summonShade
end

--- @type integer
local summonShade

--- @param shadowImage integer
--- @return integer
local function GetShadowImage(shadowImage)
    shadowImage = 38528
    local raceId = GetUnitRaceId("player")
    if raceId == 9 then
        shadowImage = 88696 -- khajiit
    elseif raceId == 6 then
        shadowImage = 88697 -- argonian
    end
    return shadowImage
end

--- @type integer
local shadowImage

--- @param darkShade integer
--- @return integer
local function GetDarkShade(darkShade)
    darkShade = 35438
    local raceId = GetUnitRaceId("player")
    if raceId == 9 then
        darkShade = 88677 -- khajiit
    elseif raceId == 6 then
        darkShade = 88678 -- argonian
    end
    return darkShade
end

--- @type integer
local darkShade

FancyActionBar.abilityConfig =
{
    --[[  [slot_id] = config:
    - { effect_id } = timer will start when the effect is fired
    - false = ignore this slot
    ]]
    -- Two Handed
    [38814] = { 131562 }, -- dizzying swing (off-balance)
    [38807] = { 61745 },  -- wrecking blow (major berserk)
    [38788] = { 38791 },  -- stampede
    [38745] = { 38747 },  -- carve bleed
    [28297] = {},         -- momentum
    [38794] = {},         -- forward momentum
    [83216] = { 83217 },  -- berserker strike
    [83229] = { 83230 },  -- onslaught
    [83238] = { 83239 },  -- berserker rage
    [217180] = { 38254 }, -- goading smash (Scribing?) (taunt)
    [219972] = { 38254 }, -- goading smash (scribing) (taunt)

    -- Shield
    [28306] = { 38254 },  -- puncture (taunt)
    [38250] = { 38254 },  -- pierce armor (taunt)
    [38256] = { 38254 },  -- ransack (taunt)
    [222966] = { 38254 }, -- goading throw (scribing) (taunt)
    [28304] = { 61723 },  -- low slash (minor maim)
    [38268] = { 61723 },  -- deep slash (minor maim)
    [38264] = { 61708 },  -- heroic slash (minor heroism)
    [28727] = {},         -- defensive posture
    [38312] = {},         -- defensive stance
    [38317] = {},         -- absorb missile
    [28719] = { 28720 },  -- shield charge (stun)
    [38401] = { 38404 },  -- shielded assault (shield)
    [38405] = { 38407 },  -- invasion (stun)
    [38452] = { 80625 },  -- power slam (resentment)

    -- Dual Wield
    [28607] = { 99806 },  -- flurry (maelstrom buff)
    [38857] = { 99806 },  -- rapid strikes (maelstrom buff)
    [38846] = { 99806 },  -- bloodthirst (maelstrom buff)
    [28379] = { 29293 },  -- twin slashes
    [38839] = { 38841 },  -- rending slashes
    [38845] = { 38848 },  -- blood craze
    [28591] = { 100474 }, -- whirlwind (asylum buff)
    [38891] = { 100474 }, -- whirling blades (asylum buff)
    [38861] = { 100474 }, -- steel tornado (asylum buff)
    [21157] = { 61665 },  -- hidden blade (major brutality)
    [38914] = { 61665 },  -- shrouded daggers (major brutality)
    [38910] = { 126667 }, -- flying blade first cast
    [126659] = false,     -- flying blade jump (ignore major brutality)
    [83600] = { 85156 },  -- lacerate
    [85187] = { 85192 },  -- rend
    [85179] = { 85182 },  -- thrive in chaos

    -- Bow
    [38687] = false,      -- focused aim (minor fracture)
    [38685] = false,      -- lethal arrow
    [28879] = { 113627 }, -- scatter shot (BRP bow)
    [38672] = { 113627 }, -- magnum shot (BRP bow)
    [38669] = { 113627 }, -- draining shot (BRP bow)
    [38705] = { 38707 },  -- bombard (immobilized)
    [38701] = { 38703 },  -- acid spray
    [28869] = { 44540 },  -- poison arrow
    [38645] = { 44545 },  -- venom arrow
    [38660] = { 44549 },  -- poison injection
    [83465] = { 55131 },  -- rapid fire (cc immunity)
    [85257] = { 55131 },  -- toxic barrage (cc immunity)
    [85451] = { 85458 },  -- ballista
    [216674] = { 38254 }, -- goading valult (scribing) (taunt)

    -- Destruction Staff
    [46340] = { 100306 }, -- force shock (vAS destro)
    [46348] = { 100306 }, -- crushing shock (vAS destro)
    [46356] = { 100306 }, -- force pulse (vAS destro)

    [29073] = { 62648 },  -- flame touch
    [29089] = { 62722 },  -- shock touch
    [29078] = { 62692 },  -- frost touch
    [38985] = { 140334 }, -- flame clench (master destro)
    [38993] = { 140334 }, -- shock clench (master destro)
    [38989] = { 38254 },  -- frost clench (taunt)
    [38944] = { 62682 },  -- flame reach
    [38978] = { 62745 },  -- shock reach
    [38970] = { 62712 },  -- frost reach
    [29173] = { 61743 },  -- Weakness to elements
    [28794] = { 115003 }, -- fire impulse (BRP destro)
    [28799] = { 115003 }, -- shock impulse (BRP destro)
    [28798] = { 115003 }, -- frost impulse (BRP destro)
    [39145] = { 115003 }, -- fire ring (BRP destro)
    [39147] = { 115003 }, -- shock ring (BRP destro)
    [39146] = { 115003 }, -- frost ring (BRP destro)
    [39162] = { 115003 }, -- flame pulsar (BRP destro)
    [39167] = { 115003 }, -- shock pulsar (BRP destro)
    [39163] = { 115003 }, -- frost pulsar (BRP destro)

    -- Restoration Staff
    [37243] = { 61693 }, -- blessing of protection (minor resolve)
    [40094] = { 61744 }, -- combat prayer (minor berserk)
    [40103] = { 61693 }, -- blessing of restoration (minor resolve)
    [31531] = { 86304 }, -- force siphon
    [40109] = { 86304 }, -- siphon spirit
    [40116] = { 86304 }, -- quick siphon

    -- Armor
    [29556] = { 61716 }, -- evasion
    [39195] = { 61716 }, -- shuffle
    [39192] = { 61716 }, -- elude
    [29552] = { 61694 }, -- unstoppable (major resolve)
    [39205] = { 61694 }, -- unstoppable brute (major resolve)
    [39197] = { 61694 }, -- immovable (major resolve)

    -- Werewolf
    [32632] = { 137156 }, -- punce (carnage bleed)
    [39105] = { 137184 }, -- brutal pounce (brutal carnage bleed)
    [39104] = { 137164 }, -- feral pounce (brutal carnage bleed)
    [58317] = { 61745 },  -- hircine's rage (major berserk)
    [58325] = { 61704 },  -- hircine's fortitude (minor fortitude)
    [32633] = { 137257 }, -- roar (off-balance)
    [39113] = { 45834 },  -- ferocious roar (off-balance); 137287 is heavy attack speed buff
    [39114] = { 61743 },  -- deafening roar major breach; 137312 is off-balance
    [58855] = { 58856 },  -- infectious claws
    [58864] = { 58865 },  -- claws of anguish
    [58879] = { 58880 },  -- claws of life
    [39075] = { 32455 },  -- pack leader
    [39076] = { 32455 },  -- werewolf berserker

    -- Vampire
    [32986] = { 106208 },  -- mist form
    [38963] = { 106209 },  -- elusive mist
    [38965] = { 49268 },   -- blood mist
    [132141] = { 172418 }, -- blood frenzy
    [134160] = { 134166 }, -- simmering frenzy
    [135841] = { 172648 }, -- sated fury
    [128709] = { 128712 }, -- Mesmerize
    [137861] = { 137865 }, -- Hypnosis
    [138097] = { 138098 }, -- Stupefy (Stun)

    -- Soul Magic
    [26768] = { 126890 }, -- soul trap
    [40328] = { 126895 }, -- soul splitting trap
    [40317] = { 126897 }, -- consuming trap

    -- Fighters Guild
    [40336] = { 38254 },  -- silver leash (taunt)
    [35750] = {},         -- trap beast dot
    [40372] = {},         -- lightweight beast trap dot
    [40382] = {},         -- barbed trap dot
    [40195] = { 61744 },  -- camouflaged hunter (minor berserk)
    [35713] = { 62305 },  -- dawnbreaker
    [40158] = { 62314 },  -- dawnbreaker of smiting
    [40161] = { 126312 }, -- flawless dawnbreaker

    -- Mages Guild
    [28567] = { 126370 }, -- entropy
    [40452] = { 126371 }, -- structured entropy
    [40457] = { 126374 }, -- degeneration
    [31632] = {},         -- fire rune
    [40470] = {},         -- volcanic rune
    [40465] = {},         -- {  40468 }; -- scalding rune (dot)
    [31642] = { 48131 },  -- equilibrium (healing debuff)
    [40445] = { 48136 },  -- spell symmetry (healing debuff)
    [40441] = { 61694 },  -- balance (major resolve)
    [16536] = { 63430 },  -- meteor
    [40489] = { 63456 },  -- ice comet
    [40493] = { 63473 },  -- shooting star

    -- Psijic Order
    [103488] = { 104050 }, -- time stop
    [104059] = { 104078 }, -- borrowed time
    [103483] = { 103879 }, -- imbue weapon
    [103571] = { 103879 }, -- elemental weapon
    [103623] = { 103879 }, -- crushing weapon
    [103503] = { 61746 },  -- accelerate (minor force)
    [103706] = { 61746 },  -- channeled acceleration
    [103710] = { 61746 },  -- race against time

    -- Undaunted
    [39475] = { 38254 }, -- inner fire (taunt)
    [42056] = { 38254 }, -- inner rage (taunt)
    [42060] = { 38254 }, -- inner beast (taunt)

    -- Alliance War
    -- Assault
    [61503] = { 61504 }, -- vigor
    [61505] = { 61506 }, -- echoing vigor
    -- [61507] = { 61693 }; -- resolving vigor
    [38566] = { 61736 }, -- rapid maneuver
    [40211] = { 61736 }, -- retreating maneuver
    [40215] = { 61736 }, -- charging maneuver
    [33376] = { 38549 }, -- caltrops
    [40242] = { 40251 }, -- razor caltrops
    [40255] = { 40265 }, -- anti-cavalry caltrops
    [38563] = { 38564 }, -- war horn
    [40220] = { 40221 }, -- sturdy war horn
    [40223] = { 40224 }, -- aggressive warhorn (30 sec); 61747: 10 sec major force

    -- Support
    [61511] = { 78338 }, -- guard  -- [80923] = { 61511 }; -- guard
    [61529] = { 81415 }, -- stalwart guard  -- [80983] = { 81420 }; -- stalwart guard gain
    [61536] = { 81415 }, -- mystic guard -- [80947] = { 61536 }; -- mystic guard

    [81420] = { 61529 }, -- guard slot id while link is acitve
    [61489] = { 61498 }, -- revealing flare
    [61519] = { 61522 }, -- lingering flare
    [61524] = { 61526 }, -- blinding flare

    -- Dragonknight
    [20805] = { 122658 }, -- show seething fury on the molten whip icon
    [20657] = { 44363 },  -- searing strike
    [20668] = { 44369 },  -- venomous claw
    [20660] = { 44373 },  -- burning embers
    [20917] = { 31102 },  -- fiery breath
    [20930] = { 31104 },  -- engulfing flames
    [20944] = { 31103 },  -- noxious breath
    [20492] = { 61736 },  -- fiery grip (major expedition)
    [20496] = { 61736 },  -- unrelenting grip (major expedition)
    [20499] = { 61737 },  -- empowering chains (empower)
    [20245] = { 20527 },  -- dark talons
    [20251] = { 61723 },  -- choking talons (minor maim)
    [20252] = { 31898 },  -- burning talons
    [29004] = { 61698 },  -- dragon blood (major fortitude)
    [32722] = { 61698 },  -- coagulating blood (major fortitude)
    [32744] = { 61549 },  -- green dragon blood (minor vitality)
    [31837] = { 31841 },  -- inhale
    [32785] = { 32788 },  -- draw essence
    [32792] = { 32796 },  -- deep breath
    [32715] = { 61814 },  -- ferocious leap
    [133027] = { 31816 }, -- track stone giant
    [32673] = { 61711 },  -- fragmented shield
    [29043] = { 61665 },  -- molten weapons
    [31874] = { 61665 },  -- igneous weapons
    [31888] = { 61665 },  -- molten armaments
    [29037] = {},         -- petrify
    [32678] = {},         -- shattering rocks
    [32685] = {},         -- fossilize

    -- Sorcerer
    [43714] = false,       -- crystal shard
    [46324] = { 46327 },   -- crystal fragment proc
    [114716] = { 46327 },  -- crystal fragment proc
    [46331] = {},          -- crystal weapon
    [24371] = { 24559 },   -- rune prison
    [24578] = { 24581 },   -- shattering prison
    [24584] = { 114903 },  -- Dark Exchange
    [24589] = { 114909 },  -- dark conversion
    [24595] = { 114908 },  -- dark deal
    [24842] = { 24844 },   -- daedric tomb (first mine) 24846; 24847
    [77182] = { 77187 },   -- volatile pulse
    [23316] = { 77187 },   -- summon volatile familiar
    [77140] = { 77354 },   -- twilight tormentor enrage
    [24636] = { 77354 },   -- summon twilight tormentor
    [108840] = { 108842 }, -- summon unstable familiar
    [23304] = { 108844 },  -- unstable pulse
    [24165] = { 203447 },  -- bound armaments
    [23634] = { 80459 },   -- Summon Storm Atronach
    [23492] = { 80463 },   -- greater storm atronarch
    [23495] = { 23668 },   -- Summon Charged Atronach
    [18718] = { 18746 },   -- mages' fury
    [19109] = { 19118 },   -- endless fury
    [19123] = { 19125 },   -- mages' wrath
    [23182] = { 157462 },  -- lightning splash
    [23205] = { 157537 },  -- lightning flood
    [23200] = { 157535 },  -- liquid lightning
    [23234] = { 51392 },   -- bolt escape fatigue
    [23236] = { 51392 },   -- streak fatigue
    [23277] = { 51392 },   -- ball of lightning fatigue

    -- Templar
    [26188] = { 95933 }, -- spear shards
    [26858] = { 95957 }, -- luminous shards
    [26869] = { 26880 }, -- blazing spear
    [22178] = { 22179 }, -- sun shield
    [22180] = { 49091 }, -- blazing shield
    [22182] = { 22183 }, -- radiant ward
    [22138] = { 62593 }, -- radial sweep
    [22139] = { 62607 }, -- crescent sweep
    [22144] = { 62599 }, -- empowering sweep
    [21726] = { 21728 }, -- sun fire
    [21732] = { 21734 }, -- reflective light
    [21729] = { 21731 }, -- vampire's bane
    [22057] = { 61737 }, -- solar flare (empower)
    [22110] = { 61737 }, -- dark flare (empower)
    [63029] = false,     -- radiant destruction
    [63044] = false,     -- radiant glory
    [63046] = false,     -- radiant oppression
    [21752] = { 21576 }, -- nova
    [21755] = { 22003 }, -- solar prison
    [21758] = { 22001 }, -- solar disturbance
    [22253] = { 35632 }, -- honor the dead
    [22314] = { 61735 }, -- hasty prayer (minor expedition)
    [26209] = { 61704 }, -- radiant aura minor endurance
    [26807] = { 61704 }, -- radiant aura minor endurance

    -- Warden
    [85995] = { 130129 }, -- dive (off-balance)
    [85999] = { 130140 }, -- cutting dive (bleed)
    [86003] = { 178330 }, -- screaming cliff racer (off-balance wd)
    [86009] = {},         -- scorch
    [86015] = {},         -- deep fissure
    [86019] = {},         -- subterranean assault
    [86023] = { 101703 }, -- swarm
    [86027] = { 101904 }, -- fetcher infection
    [86031] = { 101944 }, -- growing swarm
    [86037] = { 177288 }, -- falcon's swiftness
    [86041] = { 177289 }, -- deceptive predator
    [86045] = { 177290 }, -- bird of prey
    [85862] = { 61704 },  -- enchanted growth (minor endurance)
    [85564] = { 90266 },  -- nature's grasp healing
    [85858] = { 88726 },  -- nature's embrace healing
    [86122] = { 61694 },  -- frost cloak
    [86126] = { 61694 },  -- expansive frost cloak
    [86130] = { 61694 },  -- ice fortress
    [86148] = { 90833 },  -- arctic wind
    [86156] = { 90834 },  -- arctic blast
    [86152] = { 90835 },  -- polar wind
    [86135] = {},         -- crystallized shield
    [86139] = {},         -- crystallized slab
    [86143] = {},         -- shimmering shield
    [86175] = {},         -- frozen gate
    [86179] = {},         -- frozen device
    [86183] = {},         -- frozen retreat
    [86113] = { 132429 }, -- northern storm

    -- Nightblade
    [33386] = false,                           -- assassin's blade
    [34843] = false,                           -- killer's blade
    [34851] = false,                           -- impale
    [25484] = { 79717 },                       -- ambush (minor vulnerability)
    [18342] = { 79717 },                       -- teleport strike (minor vulnerability)
    [25493] = { 79717 },                       -- lotus fan (minor vulnerability)
    [33375] = { 61716 },                       -- blur (major evasion)
    [35414] = { 61716 },                       -- mirage (major evasion)
    [35419] = { 61716 },                       -- phantasmal escape (125314 = 2.5 sec snare immune)
    [61902] = {},                              -- grim focus (ingame timer is bugged)
    [61907] = { 61902 },                       --  false  ; -- grim focus proc
    [61919] = {},                              -- merciless resolve (ingame timer is bugged)
    [61930] = { 61919 },                       -- false  ; -- merciless resolve proc
    [61927] = {},                              -- relentless focus (ingame timer is bugged)
    [61932] = { 61927 },                       -- false  ; -- relentless focus proc
    [33398] = { 61389 },                       -- death stroke
    [36508] = { 61393 },                       -- incap (70 ult)
    [113105] = { 113107 },                     -- incap (120 ult)
    [36514] = { 61400 },                       -- soul harvest
    [25255] = { 25256 },                       -- veiled strike (off-balance)
    [25267] = { 34739 },                       -- concealed weapon
    [25260] = { 34733 },                       -- surprise attack (off-balance)
    [25375] = { 234617 },                      -- shadow cloak (born from shadow)
    [25380] = { 234617 },                      -- shadowy disguise (born from shadow)
    [25352] = { 147643 },                      -- aspect of terror
    [37470] = { 147643 },                      -- mass hysteria
    [37475] = {},                              -- manifestation of terror
    [33211] = { GetSummonShade(summonShade) }, -- summon shade
    [35434] = { GetDarkShade(darkShade) },     -- dark shade
    [35441] = { GetShadowImage(shadowImage) }, -- shadow image
    [35445] = false,                           -- shadow image proc
    [33291] = { 33292 },                       -- strife heal
    [34838] = { 34841 },                       -- funnel health heal
    [34835] = { 34836 },                       -- swallow soul heal
    [33308] = { 108925 },                      -- melevolent offering
    [34721] = { 108927 },                      -- shrewd offering
    [34727] = { 108932 },                      -- healthy offering
    [33326] = { 33333 },                       -- cripple
    [36943] = { 36947 },                       -- debilitate
    [36957] = { 36960 },                       -- crippling grasp
    [36908] = { 215672 },                      -- leeching strikes
    [33316] = { 61665 },                       -- drain power
    [36901] = { 61665 },                       -- power extraction
    [36891] = { 61665 },                       -- sap essence
    [25091] = { 25093 },                       -- soul shred
    [35460] = { 35462 },                       -- soul tether

    -- Necromancer
    [117637] = { 117638 }, -- ricochet skull: base (0 stacks)
    [123718] = { 117638 }, -- 1 stack
    [123719] = { 117638 }, -- 2 stacks
    [117624] = { 117625 }, -- venom skull: base (0 stacks)
    [123699] = { 117625 }, -- 1 stack
    [123704] = { 117625 }, -- 2 stacks
    [114860] = { 114863 }, -- blastbones
    [117330] = { 114863 }, -- blastbones
    [117690] = { 117691 }, -- blighted blastbones
    [117693] = { 117691 }, -- blighted blastbones
    [117749] = {},         -- grave lord's sacrifice
    [115924] = { 116445 }, -- shocking siphon
    [118763] = { 118764 }, -- detonating siphon
    [118008] = { 118009 }, -- mystic siphon
    [122174] = { 106754 }, -- frozen colossus (major vuln)
    [122388] = { 106754 }, -- glacial colossus (major vuln)
    [122391] = { 106754 }, -- pestilent colossus (major vuln)
    [118223] = { 122625 }, -- hungry scythe (healing over time)
    [118226] = { 125750 }, -- ruinous scythe (off-balance)
    [115177] = { 61723 },  -- grave grasp (minor maim)
    [118308] = { 61723 },  -- ghostly embrace (minor maim)
    [118352] = { 61737 },  -- empowering grasp (empower)
    [114196] = { 61726 },  -- render flesh (minor defile)
    [117883] = { 117886 }, -- resistant flesh
    [117888] = false,      -- blood sacrifice
    [115307] = false,      -- expunge
    [117940] = false,      -- expunge and modify
    [117919] = false,      -- hexproof
    [115315] = { 115326 }, -- life amid death
    [118017] = { 118022 }, -- renewing undeath
    [118809] = { 118814 }, -- enduring undeath
    [115926] = { 116450 }, -- restoring tether
    [118070] = { 118071 }, -- braided teher
    [118122] = { 118123 }, -- mortal coil
    [115410] = false,      -- reanimate
    [118367] = false,      -- renewing animation
    [118379] = false,      -- animate blastbones

    -- Arcanist
    [185794] = { 184220 }, -- runeblades
    [188658] = { 184220 }, -- runeblades
    [185803] = { 184220 }, -- writhing runeblades
    [188787] = { 184220 }, -- writhing runeblades
    [182977] = { 184220 }, -- escalating runeblades
    [188780] = { 184220 }, -- escalating runeblades
    [185817] = { 185818 }, -- abyssal impact
    [183006] = { 183008 }, -- cephaliarch's flail
    [185823] = { 185825 }, -- tentacular dread
    [185836] = { 185838 }, -- the imperfect ring
    [185839] = { 185840 }, -- rune of displacement
    [182988] = { 182989 }, -- fulminating rune (Stam)
    [201296] = { 182989 }, -- fulminating rune (Mag)
    [189791] = { 189792 }, -- the unblinking eye
    [189837] = { 191367 }, -- the tide king's gaze
    [183165] = { 38254 },  -- runic jolt (taunt)
    [183430] = { 187742 }, -- runic sunder (armor steal)
    [186531] = { 38254 },  -- runic embrace (taunt)
    [183241] = { 184362 }, -- impervious runeward
    [185912] = { 194637 }, -- runic defense
    [183401] = { 194646 }, -- runeguard of still waters
    [186489] = { 61721 },  -- runeguard of freedom
    [185918] = { 79717 },  -- rune of eldritch horror
    [185921] = { 79717 },  -- rune of uncanny adoration
    [183267] = { 145975 }, -- rune of the colorless pool
    [183261] = { 184220 }, -- runemend
    [198282] = { 184220 }, -- runemend
    [186189] = { 184220 }, -- evolving runemend
    [198288] = { 184220 }, -- evolving runemend
    [186191] = { 184220 }, -- audacious runemend
    [198292] = { 184220 }, -- audacious runemend
    [183447] = { 184220 }, -- chakram shields
    [198563] = { 184220 }, -- chakram shields
    [186207] = { 184220 }, -- chakram of destiny
    [198564] = { 184220 }, -- chakram of destiny
    [186209] = { 184220 }, -- tidal chakram
    [198567] = { 184220 }, -- tidal chakram
    [183542] = { 195167 }, -- apocryphal gate
    [186211] = { 195190 }, -- fleet-footed gate
    [186220] = { 195204 }, -- passage between worlds
    [183709] = { 183712 }, -- vitalizing glyphic
    [193794] = { 193797 }, -- glyphic of the tides
    [193558] = { 193559 }, -- resonating glyphic
    [183648] = {61694},    -- fatewoven armor
    [185908] = {61694},    -- cruxweaver armor
    [186477] = {61694},    -- unbreakable fate
    [238256] = {61694},    -- vengeance fatewoven armor

    -- Volendrung
    [116095] = { 61665 }, -- Major Brutality

    -- Lucent Citadel
    [199287] = { 199288 }, -- Ghost Light Speed
    [199290] = { 218361 }, -- Ghost Light Shield
}

FancyActionBar.contingency =
{
    221185, -- Arcanist's Contingency
    217611, -- Binding Contingency
    221354, -- Binding Contingency
    221392, -- Contingency
    221155, -- Dragonknight's Contingency
    221156, -- Dragonknight's Contingency
    221157, -- Dragonknight's Contingency
    221158, -- Dragonknight's Contingency
    217655, -- Growing Contingency
    217613, -- Healing Contingency
    217621, -- Lingering Contingency
    217605, -- Magical Contingency
    221179, -- Necromancer's Contingency
    221180, -- Necromancer's Contingency
    221181, -- Necromancer's Contingency
    221182, -- Necromancer's Contingency
    221183, -- Necromancer's Contingency
    221184, -- Necromancer's Contingency
    221169, -- Nightblade's Contingency
    221170, -- Nightblade's Contingency
    221171, -- Nightblade's Contingency
    221172, -- Nightblade's Contingency
    217656, -- Opportunistic Contingency
    217652, -- Remedying Contingency
    217609, -- Repelling Contingency
    217610, -- Repelling Contingency
    221356, -- Repelling Contingency
    218340, -- Snaring Contingency
    221166, -- Sorcerer's Contingency
    221167, -- Sorcerer's Contingency
    221168, -- Sorcerer's Contingency
    221159, -- Templar's Contingency
    221160, -- Templar's Contingency
    221161, -- Templar's Contingency
    217654, -- Tenacious Contingency
    217528, -- Ulfsild's Contingency
    217604, -- Ulfsild's Contingency
    217616, -- Ulfsild's Contingency
    217618, -- Ulfsild's Contingency
    217653, -- Ulfsild's Contingency
    217657, -- Ulfsild's Contingency
    217659, -- Ulfsild's Contingency
    218341, -- Ulfsild's Contingency
    219662, -- Ulfsild's Contingency
    221189, -- Ulfsild's Contingency
    221352, -- Ulfsild's Contingency
    221353, -- Ulfsild's Contingency
    221355, -- Ulfsild's Contingency
    221734, -- Ulfsild's Contingency
    222285, -- Ulfsild's Contingency
    222364, -- Ulfsild's Contingency
    222678, -- Ulfsild's Contingency
    221173, -- Warden's Contingency
    221174, -- Warden's Contingency
    221175, -- Warden's Contingency
    221176, -- Warden's Contingency
    221177, -- Warden's Contingency
    217608, -- Warding Contingency
}

FancyActionBar.stackMap =
{
    -- [stackId] = {stackId, abilityId_1, abilityId_2, ...}

    -- carve bleed
    [38747] =
    {
        38747, -- carve bleed
        38745, -- Carve (2H)
    },

    [38802] = { 38802 }, -- rally

    -- Spell Orb
    [103879] =
    {
        103879, -- spell orb
        103483, -- imbue weapon
        103571, -- elemental weapon
        103623, -- crushing weapon
        103503, -- accelerate
        103706, -- channeled acceleration
        103710, -- race against time
    },

    -- mist form fatigue
    [106208] =
    {
        106208, -- mist form fatigue
        32986,  -- mist form
    },

    -- elusive mist fatigue
    [106209] =
    {
        106209, -- elusive mist fatigue
        38963,  -- elusive mist
    },

    -- blood mist fatigue
    [49247] =
    {
        49247, -- blood mist fatigue
        38965, -- blood mist
    },

    -- blood frenzy stacks
    [172418] =
    {
        172418, -- blood frenzy stacks
        132141  -- blood frenzy
    },

    -- simmering frenzy stacks
    [134166] =
    {
        134166, -- simmering frenzy stacks
        134160, -- simmering frenzy
    },

    -- sated fury stacks
    [172648] =
    {
        172648, -- sated fury stacks
        135841, -- sated fury
    },

    -- force pulse (vAS destro)
    [100306] =
    {
        100306, -- force pulse (vAS destro)
        46340,  -- force shock
        46348,  -- crushing shock
        46356,  -- force pulse
    },

    -- chaotic whirlwind (vAS dw)
    [100474] =
    {
        100474, -- chaotic whirlwind (vAS dw)
        28591,  -- whirlwind
        38891,  -- whirling blades
        38861,  -- steel tornado
    },

    [122585] = { 61902 }, -- Grim Focus
    [122586] = { 61919 }, -- Merciless Resolve
    [122587] = { 61927 }, -- Relentless Focus

    -- Bound Armaments
    [203447] =
    {
        203447, -- Bound Armaments Stacks
        24165,  -- Bound Armaments
    },

    -- Streak Fatigue
    [51392] =
    {
        51392, -- Streak Fatigue
        23234, -- Bolt Escape
        23236, -- Streak
        23277, -- Ball of Lightning
    },

    [29032] = { 29032, 133037 }, -- Stone Fist (stacks on self)
    [31816] = { 31816, 133027 }, -- Stone Giant (stacks on self)

    -- Seething Fury
    [122658] =
    {
        122658, -- show seething fury on the molten whip icon
        20805,  -- molten whip
    },

    [117638] = { 117638, 117637, 123718, 123719 }, -- Ricochet Skull
    [117625] = { 117625, 117624, 123699, 123704 }, -- venom skull
    [125749] = { 125750 },                         -- ruinous scythe

    -- Crux
    [184220] =
    {
        184220, -- crux
        185794, -- runeblades
        188658, -- runeblades
        185803, -- writhing runeblades
        188787, -- writhing runeblades
        182977, -- escalating runeblades
        188780, -- escalating runeblades
        185805, -- fatecarver
        193331, -- fatecarver
        183122, -- exhausting fatecarver
        193397, -- exhausting fatecarver
        186366, -- pragmatic fatecarver
        193398, -- pragmatic fatecarver
        183261, -- runemend
        198282, -- runemend
        186189, -- evolving runemend
        198288, -- evolving runemend
        186191, -- audacious runemend
        198292, -- audacious runemend
        183537, -- remedy cascade
        198309, -- remedy cascade
        186193, -- cascading fortune
        198330, -- cascading fortune
        186200, -- curative surge
        198537, -- curative surge
        183447, -- chakram shields
        198563, -- chakram shields
        186207, -- chakram of destiny
        198564, -- chakram of destiny
        186209, -- tidal chakram
        198567, -- tidal chakram
        183241, -- impervious runeward
        184362, -- impervious runeward
        185901, -- spiteward
        238174, -- vengeance fatecarver
        238249, -- vengeance runespite ward
        238482, -- vengeance remedy cascade
    },

    -- Leeching Strikes
    [215672] =
    {
        215672, -- Leeching Strikes Cost Reduction
        36908,  -- Leeching Strikes
    },

    -- Healing Springs Mag Recovey
    [40062] =
    {
        40062, -- Healing Springs
        40060, -- Healing Springs
        99781, -- Grand Rejuviantion
    },

    -- Echoing Vigor
    [61506] =
    {
        61506, -- Echoing Vigor
        -- 61503, -- Echoing Vigor
        -- 61504, -- Echoing Vigor
        -- 61505, -- Echoing Vigor
    },

    -- Ulfsild's Contingency
    [217528] = FancyActionBar.contingency,
    [222285] = FancyActionBar.contingency,
    [222678] = FancyActionBar.contingency,

    [63430] = { 63430, 16536 }, -- meteor
    [63456] = { 63456, 40489 }, -- ice comet
    [63473] = { 63473, 40493 }, -- shooting star

    -- [222370] = { 222370 } -- Anchorite's Potency, to show Soul Gems

    [134336] =
    {
        134336,
    },

    -- Fetcher Infection
    [91416] =
    {
        86027,
        101904,
    },

    -- Brutal Pounce (Carnage Bleed)
    [137189] = {
        137189,
        137184,
        39105
    },
}

FancyActionBar.fixedStacks =
{
    [217528] = "¤",
    [222285] = "¤",
    [222678] = "¤",
    -- [222370] = select(3, GetSoulGemInfo(1, 50, false));

    [91416] = "+"
}

FancyActionBar.debuffStackMap =
{
    -- Taunt Counter
    [52790] =
    {
        52790,  -- taunt counter
        38254,  -- taunt
        39475,  -- inner fire
        42056,  -- inner rage
        42060,  -- inner beast
        38989,  -- frost clench
        28306,  -- puncture (taunt)
        38250,  -- pierce armor (taunt)
        38256,  -- ransack (taunt)
        183165, -- runic jolt
        183430, -- runic sunder
        187742, -- runic sunder (armor steal)
        186531, -- runic embrace
        222966, -- goading throw (scribing) (taunt)
        216674, -- goading valult (scribing) (taunt)
        217180, -- goading smash (Scribing?) (taunt)
        219972, -- goading smash (scribing) (taunt)
    },

    -- Stone Giant Stagger
    [134336] =
    {
        134336,
    },

    -- [134336] = 134336;  -- Stone Giant (stacks on target)

}

FancyActionBar.allowExternalStacks =
{
    [52790] = true, -- taunt counter
}

FancyActionBar.debuffIds =
{
    -- Two Handed
    [38814] = { 131562 }, -- dizzying swing (off-balance)
    [38745] = { 38747 },  -- carve bleed
    [83216] = { 83217 },  -- berserker strike
    [83229] = { 83230 },  -- onslaught
    [83238] = { 83239 },  -- berserker rage
    [83223] = { 83224 },  -- reverse slash
    [217180] = { 38254 }, -- goading smash (Scribing?) (taunt)
    [219972] = { 38254 }, -- goading smash (scribing) (taunt)

    -- Shield
    [28306] = { 38254 },  -- puncture (taunt)
    [38250] = { 38254 },  -- pierce armor (taunt)
    [38256] = { 38254 },  -- ransack (taunt)
    [222966] = { 38254 }, -- goading throw (scribing) (taunt)
    [28304] = { 61723 },  -- low slash (minor maim)
    [38268] = { 61723 },  -- deep slash (minor maim)
    [28719] = { 28720 },  -- shield charge (stun)
    [38405] = { 38407 },  -- invasion (stun)

    -- Dual Wield
    [28379] = { 29293 }, -- twin slashes
    [38839] = { 38841 }, -- rending slashes
    [38845] = { 38848 }, -- blood craze
    [83600] = { 85156 }, -- lacerate
    [85187] = { 85192 }, -- rend
    [85179] = { 85182 }, -- thrive in chaos

    -- Bow
    [216674] = { 38254 }, -- goading vault (scribing) (taunt)
    [28879] = { 113627 }, -- scatter shot (BRP bow)
    [38672] = { 113627 }, -- magnum shot (BRP bow)
    [38669] = { 113627 }, -- draining shot (BRP bow)
    [38705] = { 38707 },  -- bombard (immobilized)
    [38701] = { 38703 },  -- acid spray
    [28869] = { 44540 },  -- poison arrow
    [38645] = { 44545 },  -- venom arrow
    [38660] = { 44549 },  -- poison injection

    -- Destruction Staff
    [29073] = { 62648 },  -- flame touch
    [29089] = { 62722 },  -- shock touch
    [29078] = { 62692 },  -- frost touch
    [38985] = { 140334 }, -- flame clench (master destro)
    [38993] = { 140334 }, -- shock clench (master destro)
    [38989] = { 38254 },  -- frost clench (taunt)
    [38944] = { 62682 },  -- flame reach
    [38978] = { 62745 },  -- shock reach
    [38970] = { 62712 },  -- frost reach
    [29173] = { 61743 },  -- Weakness to elements
    [28794] = { 115003 }, -- fire impulse (BRP destro)
    [28799] = { 115003 }, -- shock impulse (BRP destro)
    [28798] = { 115003 }, -- frost impulse (BRP destro)
    [39145] = { 115003 }, -- fire ring (BRP destro)
    [39147] = { 115003 }, -- shock ring (BRP destro)
    [39146] = { 115003 }, -- frost ring (BRP destro)
    [39162] = { 115003 }, -- flame pulsar (BRP destro)
    [39167] = { 115003 }, -- shock pulsar (BRP destro)
    [39163] = { 115003 }, -- frost pulsar (BRP destro)

    -- Restoration Staff
    [31531] = { 86304 }, -- force siphon
    [40109] = { 86304 }, -- siphon spirit
    [40116] = { 86304 }, -- quick siphon

    -- Werewolf
    [32632] = { 137156 },  -- punce (carnage bleed)
    [137156] = { 137156 }, -- carnage (bleed)
    [39105] = { 137184 },  -- brutal pounce (brutal carnage bleed)
    [137184] = { 137184 }, -- brutal carnage (bleed)
    [39104] = { 137164 },  -- feral pounce (brutal carnage bleed)
    [137164] = { 137164 }, -- feral carnage (bleed)
    [32633] = { 137257 },  -- roar (off-balance)
    [39113] = { 45834 },   -- ferocious roar (off-balance); 137287 is heavy attack speed buff
    [39114] = { 61743 },   -- deafening roar major breach; 137312 is off-balance
    [58855] = { 58856 },   -- infectious claws
    [58864] = { 58865 },   -- claws of anguish
    [58879] = { 58880 },   -- claws of life

    -- Soul Magic
    [26768] = { 126890 }, -- soul trap
    [40328] = { 126895 }, -- soul splitting trap
    [40317] = { 126898 }, -- consuming trap

    -- Fighters Guild
    [40336] = { 38254 }, -- silver leash (taunt)
    [35750] = { 35756 }, -- trap beast dot
    [40372] = { 40375 }, -- lightweight beast trap dot
    [40382] = { 40385 }, -- barbed trap dot
    [35713] = { 62305 }, -- dawnbreaker
    [40158] = { 62314 }, -- dawnbreaker of smiting

    -- Mages Guild
    [28567] = { 126370 }, -- entropy
    [40452] = { 126371 }, -- structured entropy
    [40457] = { 126374 }, -- degeneration
    [40465] = {},         -- scalding rune (dot)

    -- Psijic Order
    [104059] = { 104078 }, -- borrowed time shield absorb

    -- Undaunted
    [42060] = { 38254 }, -- inner beast (taunt)
    [39475] = { 38254 }, -- inner fire (taunt)
    [42056] = { 38254 }, -- inner rage (taunt)

    -- Alliance War
    -- Assault
    [61487] = { 61487 }, -- magicka detonation
    [61491] = { 61491 }, -- inevitable detonation

    -- Dragonknight
    [20657] = { 44363 },  -- searing strike
    [20668] = { 44369 },  -- venomous claw
    [20660] = { 44373 },  -- burning embers
    [20917] = { 31102 },  -- fiery breath
    [20930] = { 31104 },  -- engulfing flames
    [20944] = { 31103 },  -- noxious breath
    [20245] = { 20527 },  -- dark talons
    [20251] = { 61723 },  -- choking talons (minor maim)
    [20252] = { 31898 },  -- burning talons
    [133027] = { 31816 }, -- track stone giant
    -- [31816] = { 133027 }; -- track stagger
    [29032] = { 29032 },  -- stonefist
    -- [31816] = { 134336 };  -- track stagger instead
    -- [133027] = { 134336 }; -- track stagger
    [29037] = {}, -- pretrify
    [32678] = {}, -- shattering rocks
    [32685] = {}, -- fossilize

    -- Sorcerer
    [28025] = {},        -- encase
    [28308] = {},        -- shattering prison
    [28311] = {},        -- restraining prison
    [24326] = { 24326 }, -- Daedric Curse
    [24330] = { 24330 }, -- haunting curse
    [24328] = { 24328 }, -- Daedric Prey

    -- Templar
    [21726] = { 21728 }, -- sun fire
    [21732] = { 21734 }, -- reflective light
    [21729] = { 21731 }, -- vampire's bane
    [21761] = { 21761 }, -- backlash
    [21765] = { 21765 }, -- purifying light
    [21763] = { 21763 }, -- PotL / 61742 (minor breach)
    [21776] = { 21776 }, -- eclipse
    [22004] = { 22004 }, -- unstable core

    -- Warden
    [85999] = { 130140 }, -- cutting dive bleed
    [86023] = { 101703 }, -- swarm
    [86027] = { 101904 }, -- fetcher infection
    [86031] = { 101944 }, -- growing swarm

    -- Nightblade
    [25484] = { 79717 },   -- ambush (minor vulnerability)
    [18342] = { 79717 },   -- teleport strike
    [25493] = { 79717 },   -- lotus fan
    [33357] = { 33357 },   -- mark target
    [36967] = { 36967 },   -- reapers mark
    [36968] = { 36968 },   -- piercing mark
    [33398] = { 61389 },   -- death stroke
    [36508] = { 61393 },   -- incap (70 ult)
    [113105] = { 113107 }, -- incap (120 ult)
    [36514] = { 61400 },   -- soul harvest
    [25255] = { 25256 },   -- veiled strike (off-balance)
    [25260] = { 34733 },   -- surprise attack (off-balance)
    [25352] = { 147643 },  -- aspect of terror
    [37470] = { 147643 },  -- mass hysteria
    [37475] = {},          -- manifestation of terror
    [33326] = { 33333 },   -- cripple
    [36943] = { 36947 },   -- debilitate
    [36957] = { 36960 },   -- crippling grasp
    [25091] = { 25093 },   -- soul shred
    [35460] = { 35462 },   -- soul tether

    -- Necromancer
    [122174] = { 106754 }, -- frozen colossus (major vuln)
    [122388] = { 106754 }, -- glacial colossus (major vuln)
    [122391] = { 106754 }, -- pestilent colossus (major vuln)
    [118226] = { 125750 }, -- ruinous scythe (off-balance)
    [115177] = { 61723 },  -- grave grasp (minor maim)
    [118308] = { 61723 },  -- ghostly embrace (minor maim)

    -- Arcanist
    [185817] = { 185818 }, -- abyssal impact (abyssal ink)
    [183006] = { 183008 }, -- cephaliarch's flail (abyssal ink)
    [185823] = { 185825 }, -- tentacular dread (abyssal ink)
    [185836] = { 185838 }, -- the imperfect ring (the imperfect ring)
    [185839] = { 185840 }, -- rune of displacement (rune of displacement)
    [182988] = { 182989 }, -- fulminating rune (Stam)
    [201296] = { 182989 }, -- fulminating rune (Mag)
    [183165] = { 38254 },  -- runic jolt (taunt)
    [183430] = { 187742 }, -- runic sunder (armor steal)
    [186531] = { 38254 },  -- runic embrace (taunt)
    [185918] = { 79717 },  -- rune of eldritch horror (minor vuln)
    [185921] = { 79717 },  -- rune of uncanny adoration (minor vuln)
    [183267] = { 145975 }, -- rune of the colorless pool (minor brittle)
}

-- skill list based on this GetSlotBoundId(hotbarSlot; HOTBAR_CATEGORY_PRIMARY)
FancyActionBar.tauntSkills =
{
    [38989] = "Frost Clench",     -- Frost Clench Ice Staff
    [20496] = "Unrelenting Grip", -- Unrelenting Dragonknight

    [28306] = "Puncture",         -- Puncture S&B
    [38256] = "Ransack",          -- Ransack S&B
    [38250] = "Pierce Armor",     -- Pierce Armor S&B

    [39475] = "Inner Fire",       -- Inner Fire Undaunted
    [42056] = "Inner Rage",       -- Inner Rage Undaunted
    [42060] = "Inner Beast",      -- Inner Fire Undaunted

    [183430] = "Runic Sunder",    -- Runic Sunder Arcanist
    [186531] = "Runic Embrace",   -- Runic Embrace Arcanist
    [183165] = "Runic Jolt",      -- Runic Jolt Arcanist

    [40336] = "Silver Leash",     -- Silver Leash Fighters Guild

    [222966] = "Goading Throw",   -- Shield Throw Grimoire; Taunt focus (Scribing)
    [217180] = "Goading Smash",   -- Smash Grimoire; Taunt focus (Scribing)?
    [219972] = "Goading Smash",   -- Smash Grimoire; Taunt focus (Scribing)
    [216674] = "Goading Vault",   -- Vault Grimoire; Taunt focus (Scribing)

}

function FancyActionBar.IsAbilityTaunt(abilityId)
    return FancyActionBar.tauntSkills[abilityId] ~= nil
end

FancyActionBar.fakeClassEffects =
{
    --[[
  scuffed way of updating certain abilities; but updates as intended without much work.
  abilities that can't be tracked in EVENT_EFFECT_CHANGED alone.
  filter so only abilities from the current class is being tracked.
  when the game registers that you press the button for the ability;
  it allows EVENT_COMBAT_EVENT to update the timer on the first encounter or the id.
  needs to be given specific duration to update correctly.
]]
    -- Dragonknight
    -- [35] = {}, -- Ardent Flame
    [36] =
    { -- Draconic Power
        [31841] = { duration = 2.5, id = 31841 }, -- inhale
        [32788] = { duration = 2.5, id = 32788 }, -- draw essence
        [32796] = { duration = 2.5, id = 32796 }, -- deep breath
    },
    -- [37] = {}, -- Earthen Heart

    -- Sorcerer
    -- [41] = {}, -- Dark Magic
    -- [42] = {}, -- Daedric Summoning
    -- [43] = {}, -- Storm Calling

    -- Nightblade
    -- [38] = {}, -- Assassination
    -- [39] = { -- Shadow
    -- [33211] = { duration = GetAbilityDuration(33211) / 1000, id = 33211 }, -- Summon Shade
    -- [35434] = { duration = GetAbilityDuration(35438) / 1000, id = 35438 }, -- Dark Shade
    -- [35441] = { duration = GetAbilityDuration(35441) / 1000, id = 35441 },  -- Shadow Image
    -- },
    -- [40] = {}, -- Siphoning

    -- Warden
    -- [127] = {}, -- Animal Companions
    -- [128] = {}, -- Green Balance
    -- [129] = {}, -- Winter's Embrace

    -- Necromancer
    [131] =
    { -- Grave Lord
        [115924] = { duration = 20, id = 116445 }, -- Shocking Siphon
        [118008] = { duration = 20, id = 118009 }, -- Mystic Siphon
        [118763] = { duration = 20, id = 118764 }, -- Detonating Siphon
    },
    -- [132] = {}, -- Bone Tyrant
    [133] =
     { -- Living Death
        [115926] = { duration = 12, id = 116450 }, -- Restoring Tether
        [118122] = { duration = 12, id = 118123 }, -- Mortal Coil
        [118070] = { duration = 12, id = 118071 }, -- Braided Tether
    },

    -- Templar
    -- [22] = {}, --Aedric Spear
    -- [27] = {}, -- Dawn's Wrath
    -- [28] = {}, -- Restoring Light

    -- Arcanist
    -- [218] = {}, -- Herald of the Tome
    -- [219] = {}, -- Soldier of Apocrypha
    -- [220] = {}, -- Curative Runeforms
}

-- Abilities Defined Here will be Processed through the FancyActionBar.HandleSpecial function
-- The Key for each table is the AbilityId you want to modify through HandleSpecial; the id key is the target Ability

--- This is a map of possible entries for the table fields we use.
--- @class FAB_BuffInfo
--- @field id integer The unique identifier of the buff
--- @field stackId table The stack identifier table
--- @field isReflect boolean | nil Whether the buff is reflectable
--- @field isSpecialDebuff boolean | nil Whether this is a special debuff
--- @field stacks integer | nil The number of stacks
--- @field procs integer | nil The number of procs
--- @field hasProced integer | nil Whether the buff has proced
--- @field isDebuff boolean | nil Whether this is a debuff
--- @field keepOnTargetChange boolean | nil Whether to keep the buff when target changes
--- @field forceExpireStacks boolean | nil Whether to force expire stacks
--- @field onAbilityUsed boolean | nil Whether this triggers on ability use
--- @field needCombatEvent boolean | nil Whether this needs combat event tracking
--- @field handler string | nil The handler function name
--- @field isMultiTarget boolean | nil Whether this affects multiple targets
--- @field setTime boolean | nil Whether to track time
--- @field duration integer | nil The duration of the buff in milliseconds

--- @type table<integer, FAB_BuffInfo>
FancyActionBar.specialEffects =
{
    [16536] = { id = 16536, stackId = { 16536 }, procs = 1, hasProced = 0, isMultiTarget = true }, -- meteor
    [63430] = { id = 16536, stackId = { 16536 }, procs = 1, hasProced = 0, isMultiTarget = true }, -- meteor
    [40489] = { id = 40489, stackId = { 40489 }, procs = 1, hasProced = 0, isMultiTarget = true }, -- ice comet
    [63456] = { id = 40489, stackId = { 40489 }, procs = 1, hasProced = 0, isMultiTarget = true }, -- ice comet

    [35750] = { id = 35750, stackId = { 35750 }, stacks = 1, procs = 1, hasProced = 0, isDebuff = false, keepOnTargetChange = true, forceExpireStacks = true, onAbilityUsed = true, needCombatEvent = true }, -- Trap Beast Placed
    [35756] = { id = 35750, stackId = { 35750 }, stacks = 0, procs = 1, hasProced = 1, isDebuff = true, keepOnTargetChange = true, isMultiTarget = true },                                                    -- Trap Beast DOT
    [40372] = { id = 40372, stackId = { 40372 }, stacks = 1, procs = 1, hasProced = 0, isDebuff = false, keepOnTargetChange = true, forceExpireStacks = true, onAbilityUsed = true, needCombatEvent = true }, -- Lightweight Trap Placed
    [40375] = { id = 40372, stackId = { 40372 }, stacks = 0, procs = 1, hasProced = 1, isDebuff = true, keepOnTargetChange = true, isMultiTarget = true },                                                    -- Lightweight Trap DOT
    [40382] = { id = 40382, stackId = { 40382 }, stacks = 1, procs = 1, hasProced = 0, isDebuff = false, keepOnTargetChange = true, forceExpireStacks = true, onAbilityUsed = true, needCombatEvent = true }, -- Barbed Trap Placed
    [40385] = { id = 40382, stackId = { 40382 }, stacks = 0, procs = 1, hasProced = 1, isDebuff = true, keepOnTargetChange = true, isMultiTarget = true },                                                    -- Barbed Trap DOT

    [40465] = { id = 40465, stackId = { 40465 }, stacks = 1, procs = 1, hasProced = 0, isDebuff = false, keepOnTargetChange = true },                      -- Scalding Rune Placed
    [40468] = { id = 40465, stackId = { 40465 }, stacks = 0, procs = 1, hasProced = 1, isDebuff = true, keepOnTargetChange = true, isMultiTarget = true }, -- Scalding Rune DOT

    [28727] = { id = 28727, stackId = { 28727 }, stacks = 1, handler = "reflect", onAbilityUsed = true, }, -- defensive posture
    [126604] = { id = 28727, stackId = { 28727 }, stacks = 1, handler = "reflect", onAbilityUsed = true, }, -- defensive posture

    [38312] = { id = 38312, stackId = { 38312 }, stacks = 1, handler = "reflect", onAbilityUsed = true, }, -- defensive stance
    [126608] = { id = 38312, stackId = { 38312 }, stacks = 1, handler = "reflect", onAbilityUsed = true, }, -- defensive stance

    [38317] = { id = 38317, stackId = { 38317 }, stacks = 1, handler = "reflect", onAbilityUsed = true, }, -- absorb missile
    [38324] = { id = 38317, stackId = { 38317 }, stacks = 1, handler = "reflect", onAbilityUsed = true, }, -- absorb missile
}

-- The values as written to the ability corresponding to the id when the fade event happens, and are keyed based on modifying abiliity id and procs number
FancyActionBar.specialEffectProcs =
{
    [35750] = { [1] = { id = 35750, stacks = 0, procs = 1, hasProced = 0, isDebuff = false, }, }, -- Trap Beast Placed
    [35756] = { [1] = { id = 35750, stacks = 0, procs = 1, hasProced = 0, isDebuff = true, }, },  -- Trap Beast DOT
    [40372] = { [1] = { id = 40372, stacks = 0, procs = 1, hasProced = 0, isDebuff = false, }, }, -- Lightweight Trap Placed
    [40375] = { [1] = { id = 40372, stacks = 0, procs = 1, hasProced = 0, isDebuff = true, }, },  -- Lightweight Trap DOT
    [40382] = { [1] = { id = 40382, stacks = 0, procs = 1, hasProced = 0, isDebuff = false, }, }, -- Barbed Trap Placed
    [40385] = { [1] = { id = 40382, stacks = 0, procs = 1, hasProced = 0, isDebuff = true, }, },  -- Barbed Trap DOT
    [40465] = { [1] = { id = 40465, stacks = 0, procs = 1, hasProced = 0, isDebuff = false, }, }, -- Scalding Rune Placed
    [40468] = { [1] = { id = 40465, stacks = 0, procs = 1, hasProced = 0, isDebuff = true, }, },  -- Scalding Rune DOT
}

-- Class Specific Effects Processed through the FancyActionBar.HandleSpecial function
FancyActionBar.specialClassEffects =
{
    -- Dragonknight
    -- [35] = {}, -- Ardent Flame
    -- [36] = {}, -- Draconic Power
    -- [37] = {}, -- Earthen Heart

    -- Sorcerer
    [41] = { -- Dark Magic
        [46331] = { id = 46331, stackId = { 46331 }, stacks = 2, procs = 1, hasProced = 0 }, -- Crystal Weapon
    },
    [42] = { -- Daedric Summoning
        [24330] = { id = 24330, stackId = { 24330 }, setTime = true, duration = 3.5, stacks = 2, procs = 1, hasProced = 0, isSpecialDebuff = true, keepOnTargetChange = true }, -- Haunting Curse, first proc
        [89491] = { id = 24330, stackId = { 24330 }, setTime = true, duration = 8.5, stacks = 1, procs = 1, hasProced = 1, isSpecialDebuff = true, keepOnTargetChange = true }, -- Haunting Curse, second proc
    },
    -- [43] = {}, -- Storm Calling

    -- Nightblade
    -- [38] = {}, -- Assassination
    [39] = { -- Shadow
        [37475] = { id = 37475, stackId = { 37475 }, stacks = 1, procs = 1, hasProced = 0, isDebuff = false, keepOnTargetChange = true }, -- manifestation of terror
        [76639] = { id = 37475, stackId = { 37475 }, setTime = true, duration = 4, stacks = 0, procs = 1, hasProced = 1, isDebuff = true, keepOnTargetChange = true, isMultiTarget = true }, -- manifestation of terror (fear)
        -- [147643] = { id = 37475; stackId = { 37475 }; stacks = 0; procs = 1; hasProced = 1; isDebuff = true; keepOnTargetChange = true }; -- manifestation of terror (major cowardice)
    },
    -- [40] = {}, -- Siphoning

    -- Warden
    [127] = { -- Animal Companions
        [86009] = { id = 86009, stackId = { 86009 }, setTime = true, duration = 3, stacks = 2, procs = 1, hasProced = 0 },  -- Scorch, first proc
        [178020] = { id = 86009, stackId = { 86009 }, setTime = true, duration = 6, stacks = 1, procs = 1, hasProced = 1 }, -- Scorch, second proc
        [86019] = { id = 86019, stackId = { 86019 }, setTime = true, duration = 3, stacks = 2, procs = 1, hasProced = 0 },  -- Sub Assault, first proc
        [146919] = { id = 86019, stackId = { 86019 }, setTime = true, duration = 3, stacks = 1, procs = 1, hasProced = 1 }, -- Sub Assault, second proc
        [86015] = { id = 86015, stackId = { 86015 }, setTime = true, duration = 3, stacks = 2, procs = 1, hasProced = 0 },  -- Deep Fissure, first proc
        [178028] = { id = 86015, stackId = { 86015 }, setTime = true, duration = 6, stacks = 1, procs = 1, hasProced = 1 }, -- Deep Fissure, second proc
    },
    -- [128] = {}, -- Green Balance
    [129] = { -- Winter's Embrace
        [86135] = { id = 86135, stackId = { 86135 }, stacks = 3, handler = "reflect", onAbilityUsed = true, }, -- crystallized shield
        [86139] = { id = 86139, stackId = { 86139 }, stacks = 3, handler = "reflect", onAbilityUsed = true, }, -- crystallized slab
        [86143] = { id = 86143, stackId = { 86143 }, stacks = 3, handler = "reflect", onAbilityUsed = true, }, -- shimmering shield

        [86175] = { id = 86175, stackId = { 86175 }, handler = "device" }, -- frozen gate
        [86179] = { id = 86179, stackId = { 86179 }, handler = "device" }, -- frozen device
        [86183] = { id = 86183, stackId = { 86183 }, handler = "device" }, -- frozen retreat
    },

    -- Necromancer
    -- [131] = {}, -- Grave Lord
    -- [132] = {}, -- Bone Tyrant
    -- [133] = {}, -- Living Death

    -- Templar
    -- [22] = {}, --Aedric Spear
    -- [27] = {}, -- Dawn's Wrath
    -- [28] = {}, -- Restoring Light

    -- Arcanist
    -- [218] = {}, -- Herald of the Tome
    -- [219] = {}, -- Soldier of Apocrypha
    -- [220] = {}, -- Curative Runeforms
}

FancyActionBar.specialClassEffectProcs =
{
    -- Dragonknight
    -- [35] = {}, -- Ardent Flame
    -- [36] = {}, -- Draconic Power
    -- [37] = {}, -- Earthen Heart

    -- Sorcerer
    [41] = { -- Dark Magic
        [46331] = { [1] = { id = 46331, stacks = 0, procs = 1, hasProced = 0 } },
    },
    [42] = { -- Daedric Summoning
        [24330] = { [1] = { id = 24330, stacks = 0, procs = 1, hasProced = 0, faded = false }, },
        [89491] = { [1] = { id = 24330, stacks = 0, procs = 1, hasProced = 0, faded = false } },
    },
    -- [43] = {}, -- Storm Calling

    -- Nightblade
    -- [38] = {}, -- Assassination
    [39] = { -- Shadow
        [37475] = { [1] = { id = 37475, stacks = 0, procs = 1, hasProced = 0, isDebuff = false, } },
        [76639] = { [1] = { id = 37475, stacks = 0, procs = 1, hasProced = 0, isDebuff = true } },
        -- [147643] = { [1] = { id = 37475; stacks = 0; procs = 1; hasProced = 0; isDebuff = true } };
    },
    -- [40] = {}, -- Siphoning

    -- Warden
    [127] = { -- Animal Companions
        [86009] = { [1] = { id = 86009, stacks = 0, procs = 1, hasProced = 0 }, },
        [178020] = { [1] = { id = 86009, stacks = 0, procs = 1, hasProced = 0 } },
        [86019] = { [1] = { id = 86019, stacks = 0, procs = 1, hasProced = 0 }, },
        [146919] = { [1] = { id = 86019, stacks = 0, procs = 1, hasProced = 0 } },
        [86015] = { [1] = { id = 86015, stacks = 0, procs = 1, hasProced = 0 }, },
        [178028] = { [1] = { id = 86015, stacks = 0, procs = 1, hasProced = 0 } },
    },
    -- [128] = {}, -- Green Balance
    -- [129] = {}, -- Winter's Embrace

    -- Necromancer
    -- [131] = {}, -- Grave Lord
    -- [132] = {}, -- Bone Tyrant
    -- [133] = {}, -- Living Death

    -- Templar
    -- [22] = {}, --Aedric Spear
    -- [27] = {}, -- Dawn's Wrath
    -- [28] = {}, -- Restoring Light

    -- Arcanist
    -- [218] = {}, -- Herald of the Tome
    -- [219] = {}, -- Soldier of Apocrypha
    -- [220] = {}, -- Curative Runeforms
}

FancyActionBar.needCombatEvent =
{
    [28297] = { duration = GetAbilityDuration(28297) / 1000, result = ACTION_RESULT_EFFECT_GAINED_DURATION, skillLine = false },                                                                              -- momentum
    [38794] = { duration = GetAbilityDuration(38794) / 1000, result = ACTION_RESULT_EFFECT_GAINED_DURATION, skillLine = false },                                                                              -- forward momentum
    -- [38802] = { duration = GetAbilityDuration(38802) / 1000; result = ACTION_RESULT_EFFECT_GAINED_DURATION; skillLine = false  }; -- rally
    [222370] = { duration = GetAbilityDuration(222370) / 1000, result = ACTION_RESULT_EFFECT_GAINED_DURATION, skillLine = false, --[[stackId = {222370}; stacks = select(3,GetSoulGemInfo(1, 50, false))]] }, -- Soul Burst, Anchorite's Potency
    [217512] = { duration = 5, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = false },                                                                                                                    -- Soul Burst (Potent Burst), Anchorite's Potency Alt Id??
    [216940] = { duration = 5, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = false },                                                                                                                    -- Leashing Soul (Potent Soul), Anchorite's Potency

    -- Class Specific UltGen Passives that need Combat Events
    [29474] = { duration = 6, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 37 },    -- Mountain's Blessing I
    [45005] = { duration = 6, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 37 },    -- Mountain's Blessing II
    [36589] = { duration = 4, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 40 },    -- Transfer I
    [45146] = { duration = 4, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 40 },    -- Transfer II
    [88512] = { duration = 8, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 127 },    -- Savage Beast I
    [88513] = { duration = 8, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 127 },    -- Savage Beast II
    [31746] = { duration = 6, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 27 },    -- Prism I
    [45217] = { duration = 6, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 27 },    -- Prism II
    [185051] = { duration = 8, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 219 }, -- Implacable Outcome I
    [185070] = { duration = 8, result = ACTION_RESULT_POWER_ENERGIZE, skillLine = 219 }, -- Implacable Outcome II
}

FancyActionBar.traps =
{
    [35750] = true, -- trap beast
    [40372] = true, -- lightweight beast trap
    [40382] = true, -- barbed trap
    [40465] = true, -- scalding rune
}

--- @type table<integer, boolean>
FancyActionBar.toggled =
{
    -- effects with no duration are discarded for tracking.
    -- add exceptions for toggles here.
    -- Werewolf
    -- [32455] = true; -- Werewolf Transformation
    -- [39075] = true; -- Pack Leader
    -- [39076] = true; -- Werewolf Berserker

    -- Vampire
    [132141] = true, -- Blood Frenzy
    [172418] = true, -- Blood Frenzy (Stacks)
    [134160] = true, -- Simmering Frenzy
    [134166] = true, -- Simmering Frenzy (Stacks)
    [135841] = true, -- Sated Fury
    [172648] = true, -- Sated Fury (Stacks)

    -- Psijic Order
    [103543] = true, -- Mend Wounds
    [103747] = true, -- Mend Spirit
    [103755] = true, -- Symbiosis
    [103492] = true, -- Meditate
    [103652] = true, -- Deep Thoughts
    [103665] = true, -- Introspection

    -- Support
    [61511] = true, -- guard (on target)
    [61536] = true, -- mystic guard (on target)
    [61529] = true, -- stalwart guard (on target)
    [78338] = true, -- active: Guard (Guard)
    [81415] = true, -- active: Mystic Guard (Mystic Guard)

    -- [80923] = true; -- guard (on self)
    -- [80947] = true; -- mystic guard (on self)
    -- [80983] = true; -- stalwart guard (on self) 80984 = minor force on target. 80986 = minor force on self

    -- [78338] = true; -- guard (inactive)
    [81420] = true, -- Link active

    -- Sorcerer
    [24785] = true, -- Overload
    [24806] = true, -- Energy Overload
    [24804] = true, -- Power Overload

    -- Nightblade
    [25375] = true, -- Shadow Cloak
    [25380] = true, -- Shadowy Disguise

    -- Banner Bearer
    [217699] = true, -- Banner Bearer
    [227085] = true, -- Banner Bearer
    [227600] = true, -- Banner Bearer
    [230289] = true, -- Banner Bearer
    [217704] = true, -- Sundering Banner
    [217705] = true, -- Magical Banner
    [217706] = true, -- Shocking Banner
    [227003] = true, -- Fiery Banner
    [227004] = true, -- Shattering Banner
    [227007] = true, -- Restorative Banner
    [227008] = true, -- Fortifying Banner
    [227009] = true, -- Binding Banner
    [227029] = true, -- Binding Banner
    [227030] = true, -- Bannerman
    [227066] = true, -- Remedying Banner
    [227067] = true, -- Resurgent Banner
    [227069] = true, -- Defensive Banner
    [227070] = true, -- Defensive Banner
    [227071] = true, -- Swift Banner
    [227073] = true, -- Defiant Banner
    [227082] = true, -- Charging Banner
    [227086] = true, -- Dragonknight's Banner
    [227087] = true, -- Dragonknight's Banner
    [227088] = true, -- Dragonknight's Banner
    [227089] = true, -- Dragonknight's Banner
    [227091] = true, -- Templar's Banner
    [227092] = true, -- Templar's Banner
    [227093] = true, -- Sorcerer's Banner
    [227094] = true, -- Warden's Banner
    [227095] = true, -- Sorcerer's Banner
    [227096] = true, -- Sorcerer's Banner
    [227101] = true, -- Nightblade's Banner
    [227102] = true, -- Nightblade's Banner
    [227103] = true, -- Nightblade's Banner
    [227104] = true, -- Nightblade's Banner
    [227106] = true, -- Warden's Banner
    [227107] = true, -- Warden's Banner
    [227108] = true, -- Warden's Banner
    [227109] = true, -- Warden's Banner
    [227110] = true, -- Necromancer's Banner
    [227111] = true, -- Necromancer's Banner
    [227112] = true, -- Necromancer's Banner
    [227113] = true, -- Necromancer's Banner
    [227115] = true, -- Necromancer's Banner
    [227116] = true, -- Arcanist's Banner
    [227120] = true, -- Bannerman
    [230293] = true, -- Charging Banner
    [231753] = true, -- Sorcerer's Banner
}

--- @type table<integer, boolean>
FancyActionBar.bannerBearer =
{
    -- Banner Bearer
    [217699] = true, -- Banner Bearer
    [227085] = true, -- Banner Bearer
    [227600] = true, -- Banner Bearer
    [230289] = true, -- Banner Bearer
    [217704] = true, -- Sundering Banner
    [217705] = true, -- Magical Banner
    [217706] = true, -- Shocking Banner
    [227003] = true, -- Fiery Banner
    [227004] = true, -- Shattering Banner
    [227007] = true, -- Restorative Banner
    [227008] = true, -- Fortifying Banner
    [227009] = true, -- Binding Banner
    [227029] = true, -- Binding Banner
    [227030] = true, -- Bannerman
    [227066] = true, -- Remedying Banner
    [227067] = true, -- Resurgent Banner
    [227069] = true, -- Defensive Banner
    [227070] = true, -- Defensive Banner
    [227071] = true, -- Swift Banner
    [227073] = true, -- Defiant Banner
    [227082] = true, -- Charging Banner
    [227086] = true, -- Dragonknight's Banner
    [227087] = true, -- Dragonknight's Banner
    [227088] = true, -- Dragonknight's Banner
    [227089] = true, -- Dragonknight's Banner
    [227091] = true, -- Templar's Banner
    [227092] = true, -- Templar's Banner
    [227093] = true, -- Sorcerer's Banner
    [227094] = true, -- Warden's Banner
    [227095] = true, -- Sorcerer's Banner
    [227096] = true, -- Sorcerer's Banner
    [227101] = true, -- Nightblade's Banner
    [227102] = true, -- Nightblade's Banner
    [227103] = true, -- Nightblade's Banner
    [227104] = true, -- Nightblade's Banner
    [227106] = true, -- Warden's Banner
    [227107] = true, -- Warden's Banner
    [227108] = true, -- Warden's Banner
    [227109] = true, -- Warden's Banner
    [227110] = true, -- Necromancer's Banner
    [227111] = true, -- Necromancer's Banner
    [227112] = true, -- Necromancer's Banner
    [227113] = true, -- Necromancer's Banner
    [227115] = true, -- Necromancer's Banner
    [227116] = true, -- Arcanist's Banner
    [227120] = true, -- Bannerman
    [230293] = true, -- Charging Banner
    [231753] = true, -- Sorcerer's Banner
}

FancyActionBar.toggleTickRate =
{
    [227116] = 5000,
    [172418] = GetAbilityFrequencyMS(132141),
    [134166] = GetAbilityFrequencyMS(134160),
    [172648] = GetAbilityFrequencyMS(135841),
}

FancyActionBar.passive =
{
    -- [186229] = true; -- Zena's Empowering Disc
}

FancyActionBar.graveLordSacrifice =
{
    id = 117749,
    skillLine = 131,
    eventId = 117757,
    duration = 20,
}

FancyActionBar.guard =
{
    -- to help identify and update overlays as the slotted id changes depending on link state.
    link = 81420,
    slot1 = nil,
    slot2 = nil,
    ids =
    {
        [61511] = true, -- guard
        [61529] = true, -- stalwart guard
        [61536] = true, -- mystic guard
    },
}

FancyActionBar.ignore =
{
    -- filter for debugging.
    [63601] = true,  -- ESO Plus
    [160197] = true, -- ward master
    [103966] = true, -- concentrated barrier
    [61744] = true,  -- minor berserk
    [114716] = true, -- crystal frags
}

FancyActionBar.ignoreFallbackTimers =
{
    [39089] = true,  -- ele sus
    [117805] = true, -- boneyard
    [39192] = true,  -- elude
    [183648] = true, -- fatewoven armor
    [185908] = true, -- cruxweaver armor
    [186477] = true, -- unbreakable fate
    [238256] = true, -- vengeance fatewoven armor
    [118680] = true, -- skeletal arcanist
}

FancyActionBar.dontFade =
{
    -- don't reset duration when effect fades until function to update corretly is in place.
    -- buffs
    [61665] = true, -- major brutality
    [76518] = true, -- major brutality
    [61687] = true, -- major sorcery
    [92503] = true, -- major sorcery
    [61694] = true, -- major resolve
    [88758] = true, -- major resolve
    -- [106754] = true; -- major vuln
    -- [61743] = true;  -- major breach
    [61704] = true, -- minor endurance
    [61706] = true, -- minor intellect
    [61697] = true, -- minor fortitude
    -- [61723] = true;  -- minor maim
    -- [61742] = true;  -- minor breach
    [86304] = true,  -- minor lifesteal
    [61693] = true,  -- minor resolve
    [176991] = true, -- minor resolve
    -- [145975] = true; -- minor brittle
    -- [61504] = true;  -- vigor
    -- [61506] = true;  -- echoing vigor
    [61737] = true, -- empower
    -- [34733] = true;  -- off-balance
    -- [25256] = true;  -- off-balance
    -- [45834] = true;  -- off-balance
    -- [125750] = true; -- off-balance
    -- [131562] = true; -- off-balance
    -- [137257] = true; -- off-balance
    -- [137312] = true; -- off-balance
    -- [130129] = true; -- off-balance
    [147417] = true, -- minor courage

    -- Two Handed
    -- [38747] = true; -- carve
    -- [83217] = true; -- berserker strike
    -- [83230] = true; -- onslaught
    -- [83239] = true; -- berserker rage

    -- Dual Wield
    -- [29293] = true; -- twin slashes
    -- [38841] = true; -- rending slashes
    -- [38848] = true; -- blood craze
    -- [85156] = true; -- lacerate
    -- [85192] = true; -- rend
    -- [85182] = true; -- thrive in chaos

    -- Bow
    -- [113627] = true; -- magnum shot (BRP bow)
    -- [38707] = true;  -- bombard
    -- [38703] = true;  -- acid spray
    -- [44540] = true;  -- poison arrow
    -- [44545] = true;  -- venom arrow
    -- [44549] = true;  -- poison injection

    -- Destruction Staff
    -- [62648] = true;  -- flame touch
    -- [62692] = true;  -- frost touch
    -- [62722] = true;  -- shock touch
    -- [62682] = true;  -- flame reach
    -- [62712] = true;  -- frost reach
    -- [62745] = true;  -- shock reach
    -- [115003] = true; -- BRP destro

    -- Soul Magic
    -- [126890] = true; -- soul trap
    -- [126895] = true; -- soul splitting trap
    -- [126898] = true; -- consuming trap

    -- Fighters Guild
    -- [35756] = true; -- trap beast
    -- [40375] = true; -- lightweight trap
    -- [40385] = true; -- barbed trap

    -- Mages Guild
    -- [40468] = true;  -- scalding rune
    -- [126370] = true; -- entropy
    -- [126371] = true; -- structured entropy
    -- [126374] = true; -- degeneration
    -- [16536] = true;  -- meteor

    -- Undaunted
    -- [38254] = true; -- taunt

    -- Dragonknight
    -- [44363] = true; -- searing strike
    -- [44369] = true; -- venomous claw
    -- [44373] = true; -- burning embers
    -- [31102] = true; -- fiery breath
    -- [31103] = true; -- noxious breath
    -- [31104] = true; -- engulfing flames
    -- [31898] = true; -- burning talons
    -- [32685] = true; -- fossilize

    -- Sorcerer
    -- [24844] = true; -- daedric tomb
    -- [24326] = true; -- Daedric Curse
    -- [24330] = true; -- haunting curse
    -- [24328] = true; -- Daedric Prey

    -- Templar
    -- [21728] = true; -- sun fire
    -- [21734] = true; -- reflective light
    -- [21731] = true; -- vampire's bane
    -- [21763] = true; -- PotL
    -- [21765] = true; -- purifying light

    -- Warden
    -- [130140] = true; -- cutting dive bleed
    -- [86019] = true;  -- sub assault
    -- [86023] = true; -- swarm
    -- [86027] = true; -- fetcher infection
    -- [86031] = true; -- growing swarm
    -- [101703] = true; -- swarm
    -- [101904] = true; -- fetcher infection
    -- [101944] = true; -- growing swarm
    -- [85840] = true;  -- growing swarm

    -- Nightblade
    -- [33357] = true;  -- mark target
    -- [36967] = true;  -- reapers mark
    -- [36968] = true;  -- piercing mark
    -- [61389] = true;  -- death stroke
    -- [61393] = true;  -- incap (70 ult)
    -- [113107] = true; -- incap (120 ult)
    -- [61400] = true;  -- soul harvest
    -- [33333] = true;  -- cripple
    -- [36947] = true;  -- debilitate
    -- [36960] = true;  -- crippling grasp
    -- [25093] = true;  -- soul shred
    -- [35462] = true;  -- soul tether

    -- Necromancer
    -- [61726] = true; -- render flesh (minor defile)


    -- Arcanist
    -- [185818] = true; -- abyssal impact (abyssal ink)
    -- [183008] = true; -- cephaliarch's flail (abyssal ink)
    -- [185825] = true; -- tentacular dread (abyssal ink)
    -- [187742] = true; -- runic sunder (armor steal)
    -- [185838] = true; -- the imperfect ring (the imperfect ring)
    -- [185840] = true; -- rune of displacement (rune of displacement)
    -- [182989] = true; -- fulminating rune (fulminating rune)
}

FancyActionBar.removeInstantly =
{
    -- 'proc' effects seem to clutter more when '0.0' is being displayed after use.
    -- few other effects gave same impression. will add options.
    -- [35756] = true; -- trap best
    -- [40375] = true; -- lightweight trap
    [40385] = true, -- barbed trap
    [40468] = true, -- scalding rune
    -- [31632] = true; -- fire rune
    -- [40470] = true; -- volcanic rune
    [24785] = true,  -- overload
    [24806] = true,  -- power overload
    [24804] = true,  -- energy overload
    [61721] = true,  -- minor protection
    [29224] = true,  -- igneous shield (shield)
    [38254] = true,  -- taunt
    [46327] = true,  -- crystal frags
    [86009] = true,  -- scorch
    [86015] = true,  -- deep fissure
    [86019] = true,  -- subterranean assault
    [103879] = true, -- spell orb
    [114863] = true, -- blastbones
    [117691] = true, -- blighted blastbones
    [117750] = true, -- stalking blastbones
    [117638] = true, -- ricochet skull
    [117625] = true, -- venom skull
    [184220] = true, -- crux
    [52790] = true,  -- taunt counter
    [18746] = true,  -- mages' fury debuff
    [19118] = true,  -- endless fury debuff
    [19125] = true,  -- mages' wrath debuff
    [51392] = true,  -- Streak Fatigue
    [61500] = true,  -- proximity detonation
    [122658] = true, -- seething fury (molten whip)
}

FancyActionBar.allowedChanneled =
{
    -- all channeled abilities are set to be untracked; unless added here.
    [103492] = true, -- Meditate
    [103652] = true, -- Deep Thoughts
    [103665] = true, -- Introspection

    [26792] = true,  -- Biting Jabs
    [22223] = true,  -- rite of passage
    [22226] = true,  -- practiced incantation
    [22229] = true,  -- remembrance

    [185805] = true, -- fatecarver
    [193331] = true, -- fatecarver
    [183122] = true, -- exhausting fatecarver
    [193397] = true, -- exhausting fatecarver
    [186366] = true, -- pragmatic fatecarver
    [193398] = true, -- pragmatic fatecarver
    [183537] = true, -- remedy cascade
    [198309] = true, -- remedy cascade
    [186193] = true, -- cascading fortune
    [198330] = true, -- cascading fortune
    [186200] = true, -- curative surge
    [198537] = true, -- curative surge
}

FancyActionBar.soloTarget =
{
    -- abilities that are removed from target when cast before it expires.
    [28025] = true, -- encase
    [28308] = true, -- shattering prison
    [28311] = true, -- restraining prison
    [24326] = true, -- Daedric Curse
    [24330] = true, -- haunting curse
    [24328] = true, -- Daedric Prey
}

FancyActionBar.stackableBuff =
{
    -- Echoing Vigor
    [61503] = 61506,
    [61504] = 61506,
    [61505] = 61506,
    [61506] = 61506,

    -- Radiating Regen
    [40079] = 40079,

    -- -- Grand Rejuvenation
    -- [40080] = 40080; -- This is incompatible with showing stacks for Healing Springs Mag Recovey [40062] in stackMap

}

FancyActionBar.confirmBuffFade =
{

}

local WEAPONTYPE_NONE = WEAPONTYPE_NONE
local WEAPONTYPE_FIRE_STAFF = WEAPONTYPE_FIRE_STAFF
local WEAPONTYPE_LIGHTNING_STAFF = WEAPONTYPE_LIGHTNING_STAFF
local WEAPONTYPE_FROST_STAFF = WEAPONTYPE_FROST_STAFF
FancyActionBar.barHighlightDestroFix =
{
    -- Base Ability
    [28858] = { [WEAPONTYPE_NONE] = 28858, [WEAPONTYPE_FIRE_STAFF] = 28807, [WEAPONTYPE_LIGHTNING_STAFF] = 28854, [WEAPONTYPE_FROST_STAFF] = 28849 }, -- Wall of Elements
    [39052] = { [WEAPONTYPE_NONE] = 39052, [WEAPONTYPE_FIRE_STAFF] = 39053, [WEAPONTYPE_LIGHTNING_STAFF] = 39073, [WEAPONTYPE_FROST_STAFF] = 39067 }, -- Unstable Wall of Elements
    [39011] = { [WEAPONTYPE_NONE] = 39011, [WEAPONTYPE_FIRE_STAFF] = 39012, [WEAPONTYPE_LIGHTNING_STAFF] = 39018, [WEAPONTYPE_FROST_STAFF] = 39028 }, -- Elemental Blockade
    [29091] = { [WEAPONTYPE_NONE] = 29091, [WEAPONTYPE_FIRE_STAFF] = 29073, [WEAPONTYPE_LIGHTNING_STAFF] = 29089, [WEAPONTYPE_FROST_STAFF] = 29078 }, -- Destructive Touch
    [38984] = { [WEAPONTYPE_NONE] = 38984, [WEAPONTYPE_FIRE_STAFF] = 38985, [WEAPONTYPE_LIGHTNING_STAFF] = 38993, [WEAPONTYPE_FROST_STAFF] = 38989 }, -- Destructive Clench
    [38937] = { [WEAPONTYPE_NONE] = 38937, [WEAPONTYPE_FIRE_STAFF] = 38944, [WEAPONTYPE_LIGHTNING_STAFF] = 38978, [WEAPONTYPE_FROST_STAFF] = 38970 }, -- Destructive Reach
    [28800] = { [WEAPONTYPE_NONE] = 28800, [WEAPONTYPE_FIRE_STAFF] = 28794, [WEAPONTYPE_LIGHTNING_STAFF] = 28799, [WEAPONTYPE_FROST_STAFF] = 28798 }, -- Impulse
    [39143] = { [WEAPONTYPE_NONE] = 39143, [WEAPONTYPE_FIRE_STAFF] = 39145, [WEAPONTYPE_LIGHTNING_STAFF] = 39147, [WEAPONTYPE_FROST_STAFF] = 39146 }, -- Elemental Ring
    [39161] = { [WEAPONTYPE_NONE] = 39161, [WEAPONTYPE_FIRE_STAFF] = 39162, [WEAPONTYPE_LIGHTNING_STAFF] = 39167, [WEAPONTYPE_FROST_STAFF] = 39163 }, -- Pulsar

    -- Fire Staff
    [28807] = { [WEAPONTYPE_NONE] = 28858, [WEAPONTYPE_FIRE_STAFF] = 28807, [WEAPONTYPE_LIGHTNING_STAFF] = 28854, [WEAPONTYPE_FROST_STAFF] = 28849 }, -- Wall of Elements
    [39053] = { [WEAPONTYPE_NONE] = 39052, [WEAPONTYPE_FIRE_STAFF] = 39053, [WEAPONTYPE_LIGHTNING_STAFF] = 39073, [WEAPONTYPE_FROST_STAFF] = 39067 }, -- Unstable Wall of Elements
    [39012] = { [WEAPONTYPE_NONE] = 39011, [WEAPONTYPE_FIRE_STAFF] = 39012, [WEAPONTYPE_LIGHTNING_STAFF] = 39018, [WEAPONTYPE_FROST_STAFF] = 39028 }, -- Elemental Blockade
    [29073] = { [WEAPONTYPE_NONE] = 29091, [WEAPONTYPE_FIRE_STAFF] = 29073, [WEAPONTYPE_LIGHTNING_STAFF] = 29089, [WEAPONTYPE_FROST_STAFF] = 29078 }, -- Destructive Touch
    [38985] = { [WEAPONTYPE_NONE] = 38984, [WEAPONTYPE_FIRE_STAFF] = 38985, [WEAPONTYPE_LIGHTNING_STAFF] = 38993, [WEAPONTYPE_FROST_STAFF] = 38989 }, -- Destructive Clench
    [38944] = { [WEAPONTYPE_NONE] = 38937, [WEAPONTYPE_FIRE_STAFF] = 38944, [WEAPONTYPE_LIGHTNING_STAFF] = 38978, [WEAPONTYPE_FROST_STAFF] = 38970 }, -- Destructive Reach
    [28794] = { [WEAPONTYPE_NONE] = 28800, [WEAPONTYPE_FIRE_STAFF] = 28794, [WEAPONTYPE_LIGHTNING_STAFF] = 28799, [WEAPONTYPE_FROST_STAFF] = 28798 }, -- Impulse
    [39145] = { [WEAPONTYPE_NONE] = 39143, [WEAPONTYPE_FIRE_STAFF] = 39145, [WEAPONTYPE_LIGHTNING_STAFF] = 39147, [WEAPONTYPE_FROST_STAFF] = 39146 }, -- Elemental Ring
    [39162] = { [WEAPONTYPE_NONE] = 39161, [WEAPONTYPE_FIRE_STAFF] = 39162, [WEAPONTYPE_LIGHTNING_STAFF] = 39167, [WEAPONTYPE_FROST_STAFF] = 39163 }, -- Pulsar

    -- Lightning Staff
    [28854] = { [WEAPONTYPE_NONE] = 28858, [WEAPONTYPE_FIRE_STAFF] = 28807, [WEAPONTYPE_LIGHTNING_STAFF] = 28854, [WEAPONTYPE_FROST_STAFF] = 28849 }, -- Wall of Elements
    [39073] = { [WEAPONTYPE_NONE] = 39052, [WEAPONTYPE_FIRE_STAFF] = 39053, [WEAPONTYPE_LIGHTNING_STAFF] = 39073, [WEAPONTYPE_FROST_STAFF] = 39067 }, -- Unstable Wall of Elements
    [39018] = { [WEAPONTYPE_NONE] = 39011, [WEAPONTYPE_FIRE_STAFF] = 39012, [WEAPONTYPE_LIGHTNING_STAFF] = 39018, [WEAPONTYPE_FROST_STAFF] = 39028 }, -- Elemental Blockade
    [29089] = { [WEAPONTYPE_NONE] = 29091, [WEAPONTYPE_FIRE_STAFF] = 29073, [WEAPONTYPE_LIGHTNING_STAFF] = 29089, [WEAPONTYPE_FROST_STAFF] = 29078 }, -- Destructive Touch
    [38993] = { [WEAPONTYPE_NONE] = 38984, [WEAPONTYPE_FIRE_STAFF] = 38985, [WEAPONTYPE_LIGHTNING_STAFF] = 38993, [WEAPONTYPE_FROST_STAFF] = 38989 }, -- Destructive Clench
    [38978] = { [WEAPONTYPE_NONE] = 38937, [WEAPONTYPE_FIRE_STAFF] = 38944, [WEAPONTYPE_LIGHTNING_STAFF] = 38978, [WEAPONTYPE_FROST_STAFF] = 38970 }, -- Destructive Reach
    [28799] = { [WEAPONTYPE_NONE] = 28800, [WEAPONTYPE_FIRE_STAFF] = 28794, [WEAPONTYPE_LIGHTNING_STAFF] = 28799, [WEAPONTYPE_FROST_STAFF] = 28798 }, -- Impulse
    [39147] = { [WEAPONTYPE_NONE] = 39143, [WEAPONTYPE_FIRE_STAFF] = 39145, [WEAPONTYPE_LIGHTNING_STAFF] = 39147, [WEAPONTYPE_FROST_STAFF] = 39146 }, -- Elemental Ring
    [39167] = { [WEAPONTYPE_NONE] = 39161, [WEAPONTYPE_FIRE_STAFF] = 39162, [WEAPONTYPE_LIGHTNING_STAFF] = 39167, [WEAPONTYPE_FROST_STAFF] = 39163 }, -- Pulsar

    -- Frost Staff
    [28849] = { [WEAPONTYPE_NONE] = 28858, [WEAPONTYPE_FIRE_STAFF] = 28807, [WEAPONTYPE_LIGHTNING_STAFF] = 28854, [WEAPONTYPE_FROST_STAFF] = 28849 }, -- Wall of Elements
    [39067] = { [WEAPONTYPE_NONE] = 39052, [WEAPONTYPE_FIRE_STAFF] = 39053, [WEAPONTYPE_LIGHTNING_STAFF] = 39073, [WEAPONTYPE_FROST_STAFF] = 39067 }, -- Unstable Wall of Elements
    [39028] = { [WEAPONTYPE_NONE] = 39011, [WEAPONTYPE_FIRE_STAFF] = 39012, [WEAPONTYPE_LIGHTNING_STAFF] = 39018, [WEAPONTYPE_FROST_STAFF] = 39028 }, -- Elemental Blockade
    [29078] = { [WEAPONTYPE_NONE] = 29091, [WEAPONTYPE_FIRE_STAFF] = 29073, [WEAPONTYPE_LIGHTNING_STAFF] = 29089, [WEAPONTYPE_FROST_STAFF] = 29078 }, -- Destructive Touch
    [38990] = { [WEAPONTYPE_NONE] = 38984, [WEAPONTYPE_FIRE_STAFF] = 38985, [WEAPONTYPE_LIGHTNING_STAFF] = 38993, [WEAPONTYPE_FROST_STAFF] = 38989 }, -- Destructive Clench
    [38970] = { [WEAPONTYPE_NONE] = 38937, [WEAPONTYPE_FIRE_STAFF] = 38944, [WEAPONTYPE_LIGHTNING_STAFF] = 38978, [WEAPONTYPE_FROST_STAFF] = 38970 }, -- Destructive Reach
    [28798] = { [WEAPONTYPE_NONE] = 28800, [WEAPONTYPE_FIRE_STAFF] = 28794, [WEAPONTYPE_LIGHTNING_STAFF] = 28799, [WEAPONTYPE_FROST_STAFF] = 28798 }, -- Impulse
    [39146] = { [WEAPONTYPE_NONE] = 39143, [WEAPONTYPE_FIRE_STAFF] = 39145, [WEAPONTYPE_LIGHTNING_STAFF] = 39147, [WEAPONTYPE_FROST_STAFF] = 39146 }, -- Elemental Ring
    [39163] = { [WEAPONTYPE_NONE] = 39161, [WEAPONTYPE_FIRE_STAFF] = 39162, [WEAPONTYPE_LIGHTNING_STAFF] = 39167, [WEAPONTYPE_FROST_STAFF] = 39163 }, -- Pulsar

    -- Ultimates

    -- Elemental Storm
    [83619] = { [WEAPONTYPE_NONE] = 83619, [WEAPONTYPE_FIRE_STAFF] = 83625, [WEAPONTYPE_FROST_STAFF] = 83628, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- elemental storm
    [83625] = { [WEAPONTYPE_NONE] = 83619, [WEAPONTYPE_FIRE_STAFF] = 83625, [WEAPONTYPE_FROST_STAFF] = 83628, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- fire
    [83628] = { [WEAPONTYPE_NONE] = 83619, [WEAPONTYPE_FIRE_STAFF] = 83625, [WEAPONTYPE_FROST_STAFF] = 83628, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- ice
    [83630] = { [WEAPONTYPE_NONE] = 83619, [WEAPONTYPE_FIRE_STAFF] = 83625, [WEAPONTYPE_FROST_STAFF] = 83628, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- shock

    -- Eye of the Storm
    [83642] = { [WEAPONTYPE_NONE] = 83642, [WEAPONTYPE_FIRE_STAFF] = 83682, [WEAPONTYPE_FROST_STAFF] = 83684, [WEAPONTYPE_LIGHTNING_STAFF] = 83686 }, -- eye of the storm
    [83682] = { [WEAPONTYPE_NONE] = 83642, [WEAPONTYPE_FIRE_STAFF] = 83682, [WEAPONTYPE_FROST_STAFF] = 83684, [WEAPONTYPE_LIGHTNING_STAFF] = 83686 }, -- fire
    [83684] = { [WEAPONTYPE_NONE] = 83642, [WEAPONTYPE_FIRE_STAFF] = 83682, [WEAPONTYPE_FROST_STAFF] = 83684, [WEAPONTYPE_LIGHTNING_STAFF] = 83686 }, -- ice
    [83686] = { [WEAPONTYPE_NONE] = 83642, [WEAPONTYPE_FIRE_STAFF] = 83682, [WEAPONTYPE_FROST_STAFF] = 83684, [WEAPONTYPE_LIGHTNING_STAFF] = 83686 }, -- shock

    -- Elemental Rage
    [84434] = { [WEAPONTYPE_NONE] = 84434, [WEAPONTYPE_FIRE_STAFF] = 85126, [WEAPONTYPE_FROST_STAFF] = 85128, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- elemental rage
    [85126] = { [WEAPONTYPE_NONE] = 84434, [WEAPONTYPE_FIRE_STAFF] = 85126, [WEAPONTYPE_FROST_STAFF] = 85128, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- fire
    [85128] = { [WEAPONTYPE_NONE] = 84434, [WEAPONTYPE_FIRE_STAFF] = 85126, [WEAPONTYPE_FROST_STAFF] = 85128, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- ice
    [85130] = { [WEAPONTYPE_NONE] = 84434, [WEAPONTYPE_FIRE_STAFF] = 85126, [WEAPONTYPE_FROST_STAFF] = 85128, [WEAPONTYPE_LIGHTNING_STAFF] = 85130 }, -- shock
}

FancyActionBar.styleFix =
{
    -- Arcanist, Stam Cost Abilities
    [193331] = 185805, -- Fatecarver
    [193398] = 186366, -- Pragmatic Fatecarver
    [193397] = 183122, -- Exhausting Fatecarver
    [198282] = 183261, -- Runemend
    [198288] = 186189, -- Evolving Runemend
    [198292] = 186191, -- Audacious Runemend
    [188658] = 185794, -- Runeblades
    [188780] = 182977, -- Escalating Runeblades
    [188787] = 185803, -- Writhing Runeblades

    -- Arcanist, Mag Cost Abilities
    [185805] = 185805, -- Fatecarver
    [186366] = 186366, -- Pragmatic Fatecarver
    [183122] = 183122, -- Exhausting Fatecarver
    [183261] = 183261, -- Runemend
    [186189] = 186189, -- Rvolving Runemend
    [186191] = 186191, -- audacious runemend
    [185794] = 185794, -- Runeblades
    [182977] = 182977, -- Escalating Runeblades
    [185803] = 185803, -- Writhing Runeblades
}

FancyActionBar.skillLineInfo =
{
    [1] = {  -- Dragonknight
        35, -- Ardent Flame
        36, -- Draconic Power
        37, -- Earthen Heart
    },
    [2] = {  -- Sorcerer
        41, -- Dark Magic
        42, -- Daedric Summoning
        43, -- Storm Calling
    },
    [3] = {  -- Nightblade
        38, -- Assassination
        39, -- Shadow
        40, -- Siphoning
    },
    [4] = { -- Warden
        127, -- Animal Companions
        128, -- Green Balance
        129, -- Winter's Embrace
    },
    [5] = {  -- Necromancer
        131, -- Grave Lord
        132, -- Bone Tyrant
        133, -- Living Death
    },
    [6] = { -- Templar
        22, --Aedric Spear
        27, -- Dawn's Wrath
        28, -- Restoring Light
    },
    [117] = { -- Arcanist
        218, -- Herald of the Tome
        219, -- Soldier of Apocrypha
        220, -- Curative Runeforms
    },
}

-- * GetSkillLineIndicesFromSkillLineId(*integer* _skillLineId_)
-- ** _Returns:_ *[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_

-- * EVENT_SKILL_BUILD_SELECTION_UPDATED
-- * EVENT_SKILL_LINE_ADDED (*[SkillType|#SkillType]* _skillType_, *luaindex* _skillLineIndex_, *bool* _advised_)
