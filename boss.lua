local function give_random_boss_joker(requested_amount)
    local amount = requested_amount or 1
    local amount_given = 0

    while amount_given < amount do
        local pool = {}
        for k, v in pairs(G.P_CENTERS) do
            if v.set == "Joker" and v.pools and v.pools["ashersba_Boss_Jokers"] then
                local has_joker = false
                for _, card in ipairs(G.jokers.cards) do
                    if card.config.center.key == k then
                        has_joker = true
                        break
                    end
                end
                if not has_joker then table.insert(pool, k) end
            end
        end

        if #pool > 0 then
            local chosen = pseudorandom_element(pool, pseudoseed('boss_joker_debuff'))
            local card = create_card('Joker', G.jokers, nil, nil, nil, nil, chosen, 'boss_spawn')
            card:set_edition({ashersba_boss = true}, true, true)
            card:add_to_deck()
            G.jokers:emplace(card)
            card:juice_up(0.3, 0.5)
            amount_given = amount_given + 1
        else
            break
        end
    end
end

local function secret_deck_active()
    return G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_secret_deck
end

local function resolve_blind_config(blind_ref)
    if type(blind_ref) == "table" then return blind_ref end
    if type(blind_ref) == "string" and G and G.P_BLINDS then return G.P_BLINDS[blind_ref] end
    return nil
end

local function find_clopen_blind()
    if not (G and G.P_BLINDS) then return nil end
    if G.P_BLINDS.bl_ashersba_clopen then return G.P_BLINDS.bl_ashersba_clopen end
    if G.P_BLINDS.bl_ashersba_Clopen then return G.P_BLINDS.bl_ashersba_Clopen end
    for k, v in pairs(G.P_BLINDS) do
        local vk = v and v.key and string.lower(v.key) or ""
        local kk = type(k) == "string" and string.lower(k) or ""
        if vk:find("clopen", 1, true) or kk:find("clopen", 1, true) then
            return v
        end
    end
    return nil
end

local function is_secret_boss_blind(blind_ref)
    local cfg = resolve_blind_config(blind_ref)
    if not cfg or not cfg.key then
        return false
    end
    local key = string.lower(cfg.key)
    return key:find('clopen', 1, true) or key:find('jevil', 1, true) or key:find('minty', 1, true)
end

local function add_enhanced_cards_to_deck(center_key, amount, seed_tag)
    if not (G and G.P_CENTERS and G.deck and G.playing_cards and amount and amount > 0) then return end
    local center = G.P_CENTERS[center_key]
    if not center then return end

    for i = 1, amount do
        local card_front = pseudorandom_element(G.P_CARDS, pseudoseed((seed_tag or "ashersba_add_enhance") .. "_" .. tostring(i)))
        local base_card = create_playing_card({
            front = card_front,
            center = center
        }, G.discard, true, false, nil, true)

        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        local new_card = copy_card(base_card, nil, nil, G.playing_card)
        new_card:add_to_deck()
        G.deck.config.card_limit = (G.deck.config.card_limit or #G.playing_cards) + 1
        G.deck:emplace(new_card)
        table.insert(G.playing_cards, new_card)
        base_card:remove()

        G.E_MANAGER:add_event(Event({
            func = function()
                new_card:start_materialize()
                return true
            end
        }))
        SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
    end
end

local function add_joker_once(joker_key)
    if not (joker_key and G and G.jokers and G.jokers.cards) then return end
    for _, card in ipairs(G.jokers.cards) do
        if card and card.config and card.config.center and card.config.center.key == joker_key then
            return
        end
    end
    SMODS.add_card({ set = "Joker", key = joker_key })
end

local function apply_secret_deck_clopen_bundle()
    if not secret_deck_active() then return end
    if not (G and G.GAME) then return end

    G.GAME.ashersba_secret_state = G.GAME.ashersba_secret_state or {}
    local secret_state = G.GAME.ashersba_secret_state
    if secret_state.clopen_bundle_given then return end

    add_enhanced_cards_to_deck("m_ashersba_whitebonesattack", 13, "secret_clopen_white")
    add_enhanced_cards_to_deck("m_ashersba_blueattack", 7, "secret_clopen_blue")
    add_enhanced_cards_to_deck("m_ashersba_orangeattack", 7, "secret_clopen_orange")
    add_joker_once("j_ashersba_gasterblasterboss")

    secret_state.clopen_bundle_given = true
end

-- Hook all blinds to filter showdown blinds on secret deck
local original_in_pool = {}

if G and G.P_BLINDS then
    for blind_key, blind_obj in pairs(G.P_BLINDS) do
        if blind_obj and blind_obj.in_pool then
            original_in_pool[blind_key] = blind_obj.in_pool
        end
    end
end

-- Override in_pool for all showdown blinds
local function wrap_showdown_in_pool()
    if not (G and G.P_BLINDS) then return end
    
    for blind_key, blind_obj in pairs(G.P_BLINDS) do
        if not blind_obj then goto continue end
        
        -- Only wrap showdown blinds
        if not (blind_obj.boss and blind_obj.boss.showdown) then goto continue end
        
        local original_func = original_in_pool[blind_key] or blind_obj.in_pool
        
        blind_obj.in_pool = function(self)
            -- On secret deck: only secret boss showdowns can appear
            if secret_deck_active() then
                return is_secret_boss_blind(self)
            end
            -- On normal decks: use original logic
            if original_func then
                return original_func(self)
            end
            return true
        end
        
        ::continue::
    end
end

-- Call the wrapping function when blinds are loaded
local original_SMODS_load_file = SMODS.load_file
function SMODS.load_file(path, ...)
    local result = original_SMODS_load_file(path, ...)
    
    -- After blinds are loaded, wrap the in_pool functions
    if path and path:find('Blind', 1, true) then
        wrap_showdown_in_pool()
    end
    
    return result
end

-- Also wrap at game start
local set_blind_ref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    wrap_showdown_in_pool()
    
    set_blind_ref(self, blind, reset, silent)

    local applied_cfg = resolve_blind_config(blind) or blind
    local applied_key = applied_cfg and applied_cfg.key and string.lower(applied_cfg.key) or ""
    if secret_deck_active()
        and not reset
        and not silent
        and self
        and self.boss
        and applied_key:find("clopen", 1, true)
    then
        apply_secret_deck_clopen_bundle()
    end

    local original_cfg = resolve_blind_config(blind) or {}
    if original_cfg and original_cfg.boss and self.boss and not reset and not silent and G.GAME.stake then
        local min_boss_stake = G.P_STAKES['boss_stake1'] and G.P_STAKES['boss_stake1'].order or nil
        if not min_boss_stake or G.GAME.stake < min_boss_stake then return end

        if G.P_STAKES['boss_stake8'] and G.GAME.stake >= G.P_STAKES['boss_stake8'].order then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(3) return true end}))
        elseif G.P_STAKES['boss_stake7'] and G.GAME.stake >= G.P_STAKES['boss_stake7'].order and (G.GAME.round_resets.ante == 3 or G.GAME.round_resets.ante == 6 or G.GAME.round_resets.ante == 9) then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(2) return true end}))
        elseif G.P_STAKES['boss_stake6'] and G.GAME.stake >= G.P_STAKES['boss_stake6'].order and (G.GAME.round_resets.ante == 4 or G.GAME.round_resets.ante == 8) then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(1) return true end}))
        elseif G.P_STAKES['boss_stake5'] and G.GAME.stake >= G.P_STAKES['boss_stake5'].order and G.GAME.round_resets.ante == 5 then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(1) return true end}))
        elseif G.P_STAKES['boss_stake4'] and G.GAME.stake >= G.P_STAKES['boss_stake4'].order and G.GAME.round_resets.ante == 6 then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(1) return true end}))
        elseif G.P_STAKES['boss_stake3'] and G.GAME.stake >= G.P_STAKES['boss_stake3'].order and G.GAME.round_resets.ante == 7 then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(1) return true end}))
        elseif G.P_STAKES['boss_stake2'] and G.GAME.stake >= G.P_STAKES['boss_stake2'].order and G.GAME.round_resets.ante == 8 then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(1) return true end}))
        elseif G.P_STAKES['boss_stake1'] and G.GAME.stake >= G.P_STAKES['boss_stake1'].order and G.GAME.round_resets.ante == 8 then
            G.E_MANAGER:add_event(Event({func = function() give_random_boss_joker(1) return true end}))
        end
    end
end