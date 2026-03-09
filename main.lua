SMODS.Atlas({
    key = "modicon", 
    path = "ModIcon.png", 
    px = 34,
    py = 34,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "balatro", 
    path = "balatro.png", 
    px = 333,
    py = 216,
    prefix_config = { key = false },
    atlas_table = "ASSET_ATLAS"
})


SMODS.Atlas({
    key = "CustomJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomConsumables", 
    path = "CustomConsumables.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomEnhancements", 
    path = "CustomEnhancements.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomSeals", 
    path = "CustomSeals.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomDecks", 
    path = "Cardback.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "Crash_Atlas",
    path = "Fake_Crash.png",
    px = 1920,
    py = 1080,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "chips",
    path = "chips.png",
    px = 29,
    py = 29,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key= "Sticker",
    path = "Sticker.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "SecretBoss",
    path = "SecretBoss.png",
    px = 34,
    py = 34,
    atlas_table = "ANIMATION_ATLAS",
    frames = 21
})

SMODS.Atlas({
    key = "BG_TEST",
    path = "Boss_Test_Image.png",
    px = 1071,
    py = 596,
    atlas_table = "ANIMATION_ATLAS",
    frames = 1
})

SMODS.Atlas({
    key = "CustomCardTheme",
    path = "AshersCard.png",
    px = 71,
    py = 95,
    table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomVouchers",
    path = "CustomVouchers.png",
    px = 71,
    py = 95,
    table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "CustomStickers",
    path = "stickers.png",
    px = 71,
    py = 95,
    table = "ASSET_ATLAS"
})

SMODS.Atlas({
    key = "Boss",
    path = "NewBossBlinds.png",
    px = 34,
    py = 34,
    atlas_table = "ANIMATION_ATLAS",
    frames = 21
})

SMODS.Atlas({
    key = "GrayCurse",
    path = "GrayCurse.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS",
})

SMODS.Atlas({
    key = "MintCurse",
    path = "MintCurse.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
})

local NFS = require("nativefs")
to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end

local function load_jokers_folder()
    local mod_path = SMODS.current_mod.path
    local jokers_path = mod_path .. "/jokers"
    local files = NFS.getDirectoryItemsInfo(jokers_path)
    table.sort(files, function(a, b) return a.name < b.name end)
    for i = 1, #files do
        local file_name = files[i].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("jokers/" .. file_name))()
        end
    end
end


local consumableIndexList = {2,1,8,3,4,5,6,7}

local function load_consumables_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/consumables"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    local set_file_number = #files + 1
    for i = 1, #files do
        if files[i].name == "sets.lua" then
            assert(SMODS.load_file("consumables/sets.lua"))()
            set_file_number = i
        end
    end    
    for i = 1, #consumableIndexList do
        local j = consumableIndexList[i]
        if j >= set_file_number then 
            j = j + 1
        end
        local file_name = files[j].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("consumables/" .. file_name))()
        end
    end
end


local function load_enhancements_folder()
    local mod_path = SMODS.current_mod.path
    local enhancements_path = mod_path .. "/enhancements"
    local files = NFS.getDirectoryItemsInfo(enhancements_path)
    table.sort(files, function(a, b) return a.name < b.name end)
    for i = 1, #files do
        local file_name = files[i].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("enhancements/" .. file_name))()
        end
    end
end

local voucherIndexList = {4,1,2,3}

local function load_vouchers_folder()
    local mod_path = SMODS.current_mod.path
    local vouchers_path = mod_path .. "/vouchers"
    local files = NFS.getDirectoryItemsInfo(vouchers_path)
    for i = 1, #voucherIndexList do
        local file_name = files[voucherIndexList[i]].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("vouchers/" .. file_name))()
        end
    end
end


local sealIndexList = {1,2}

local function load_seals_folder()
    local mod_path = SMODS.current_mod.path
    local seals_path = mod_path .. "/seals"
    local files = NFS.getDirectoryItemsInfo(seals_path)
    for i = 1, #sealIndexList do
        local file_name = files[sealIndexList[i]].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("seals/" .. file_name))()
        end
    end
end


local editionIndexList = {1}

local function load_editions_folder()
    local mod_path = SMODS.current_mod.path
    local editions_path = mod_path .. "/editions"
    local files = NFS.getDirectoryItemsInfo(editions_path)
    for i = 1, #editionIndexList do
        local file_name = files[editionIndexList[i]].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("editions/" .. file_name))()
        end
    end
end


local deckIndexList = {1,2,3,4,6,5}

local function load_decks_folder()
    local mod_path = SMODS.current_mod.path
    local decks_path = mod_path .. "/decks"
    local files = NFS.getDirectoryItemsInfo(decks_path)
    for i = 1, #deckIndexList do
        local file_name = files[deckIndexList[i]].name
        if string.lower(file_name:sub(-4)) == ".lua" then
            assert(SMODS.load_file("decks/" .. file_name))()
        end
    end
end

local function load_rarities_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("rarities.lua"))()
end

local function load_mainmenu_file()
        local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("mainmenu.lua"))()
end

local function load_boss_file()
    local modpath = SMODS.current_mod.path
    assert(SMODS.load_file("boss.lua"))()
end

local function load_stakes_file()
    local modpath = SMODS.current_mod.path
    assert(SMODS.load_file("stakes.lua"))()
end

local function load_custombossblind_file()
    local modpath = SMODS.current_mod.path
    assert(SMODS.load_file("CustomBossBlinds.lua"))()
end

local function load_custom_card_theme_file()
    local modpath = SMODS.current_mod.path
    assert(SMODS.load_file("CustomCardTheme.lua"))()
end

local function load_custom_stickers_file()
    local modpath = SMODS.current_mod.path
    assert(SMODS.load_file("CustomStickers.lua"))()
end

local function load_custom_poker_handtype_file()
    local modpath = SMODS.current_mod.path
    assert(SMODS.load_file("CustomPokerHand.lua"))()
end

load_custombossblind_file()
load_custom_card_theme_file()
load_boss_file()
load_mainmenu_file()
load_rarities_file()
load_custom_stickers_file()
assert(SMODS.load_file("sounds.lua"))()
load_jokers_folder()
load_consumables_folder()
load_enhancements_folder()
load_vouchers_folder()
load_seals_folder()
load_editions_folder()
load_decks_folder()
load_stakes_file()
load_custom_poker_handtype_file()
SMODS.ObjectType({
    key = "ashersba_food",
    cards = {
        ["j_gros_michel"] = true,
        ["j_egg"] = true,
        ["j_ice_cream"] = true,
        ["j_cavendish"] = true,
        ["j_turtle_bean"] = true,
        ["j_diet_cola"] = true,
        ["j_popcorn"] = true,
        ["j_ramen"] = true,
        ["j_selzer"] = true
    },
})

SMODS.ObjectType({
    key = "ashersba_Boss_Jokers",
    cards = {
        ["j_ashersba_abundantflint"] = true,
        ["j_ashersba_amethistwall"] = true,
        ["j_ashersba_bindingmarble"] = true,
        ["j_ashersba_defectedarm"] = true,
        ["j_ashersba_fish"] = true,
        ["j_ashersba_freedommark"] = true,
        ["j_ashersba_hooksinker"] = true,
        ["j_ashersba_lopillar"] = true,
        ["j_ashersba_mysticpsychology"] = true,
        ["j_ashersba_oxenpeak"] = true,
        ["j_ashersba_powerplantation"] = true,
        ["j_ashersba_rainbowsuit"] = true,
        ["j_ashersba_reptilefriends"] = true,
        ["j_ashersba_sneko"] = true,
        ["j_ashersba_toothsomeana"] = true,
        ["j_ashersba_tetostounge"] = true,
        ["j_ashersba_usedneedle"] = true,
        ["j_ashersba_waterstone"] = true,
        ["j_ashersba_winnerwheel"] = true
    },
})

SMODS.ObjectType({
    key = "ashersba_ashersba_jokers",
    cards = {
        ["j_ashersba_anyglutenfree"] = true,
        ["j_ashersba_asherball"] = true,
        ["j_ashersba_ashoker"] = true,
        ["j_ashersba_babydolleyes"] = true,
        ["j_ashersba_cantconnect"] = true,
        ["j_ashersba_cursedskull"] = true,
        ["j_ashersba_eldritchtogopi"] = true,
        ["j_ashersba_fanmadefun"] = true,
        ["j_ashersba_jokerbell"] = true,
        ["j_ashersba_leshysphoto"] = true,
        ["j_ashersba_loweffortmarblejoker"] = true,
        ["j_ashersba_necronomicon"] = true,
        ["j_ashersba_outofbounds"] = true,
        ["j_ashersba_staceysmom"] = true,
        ["j_ashersba_savescum"] = true,
        ["j_ashersba_teamcomedians"] = true,
        ["j_ashersba_technicaldifficulties"] = true,
        ["j_ashersba_thearsonist"] = true,
        ["j_ashersba_theferry"] = true,
        ["j_ashersba_themechanic"] = true,
        ["j_ashersba_thenoisemaker"] = true,
        ["j_ashersba_youcantreadthis"] = true,
        ["j_ashersba_airhockey"] = true,
        ["j_ashersba_phonecall"] = true,
        ["j_ashersba_mosquitoball"] = true,
        ["j_ashersba_audiencehack"] = true,
        ["j_ashersba_melatonindeprived"] = true,
        ["j_ashersba_faultyachivement"] = true,
        ["j_ashersba_clubberpit"] = true,
        ["j_ashersba_dode"] = true,
        ["j_ashersba_triviavictims"] = true,
        ["j_ashersba_deceiver"] = true
    },
})

SMODS.ObjectType({
    key = "ashersba_steamkey_jokers",
    cards = {
        ["j_ashersba_clownmeat"] = true,
        ["j_ashersba_heavierthanfeathers"] = true,
        ["j_ashersba_jokeronigiri"] = true,
        ["j_ashersba_lovelyvandel"] = true,
        ["j_ashersba_shapeshifter"] = true
    },
})


SMODS.current_mod.optional_features = function()
    return {
        cardareas = {} 
    }
end

SMODS.Joker:take_ownership('j_wee', {
    atlas = "CustomJokers",
    pos = {x=0, y=6} 
})
SMODS.Joker:take_ownership('j_blueprint', {
    atlas = "CustomJokers",
    pos = {x=1, y=6}
})
SMODS.Joker:take_ownership('j_brainstorm',{
    atlas = "CustomJokers",
    pos = {x=2, y=6}
})
SMODS.Joker:take_ownership('j_ancient',{
    atlas = "CustomJokers",
    pos = {x=3, y=6}
})
SMODS.Joker:take_ownership('j_todo_list',{
    atlas = "CustomJokers",
    pos = {x=4,y=6}
})
