local function ashersba_is_royal_flush_label(label)
    if type(label) ~= 'string' then
        return false
    end
    local normalized = string.lower(label):gsub("[^a-z]", "")
    return normalized == 'royalflush'
end

local function ashersba_is_royal_flush_cards(cards)
    if type(cards) ~= 'table' or #cards < 5 then
        return false
    end

    local suit = nil
    local needed = { [10] = false, [11] = false, [12] = false, [13] = false, [14] = false }
    local count = 0

    for _, c in ipairs(cards) do
        if c and c.get_id then
            local id = c:get_id()
            if needed[id] ~= nil then
                needed[id] = true
                count = count + 1

                if not suit and c.base and c.base.suit then
                    suit = c.base.suit
                end
                if suit and c.base and c.base.suit and c.base.suit ~= suit then
                    return false
                end
            end
        end
    end

    return count >= 5 and needed[10] and needed[11] and needed[12] and needed[13] and needed[14]
end

local function ashersba_is_velvet_fight(blind_obj)
    local b = blind_obj or (G and G.GAME and G.GAME.blind)
    if not b then return false end

    local key = b.key
        or (b.config_blind and b.config_blind.key)
        or (b.config and b.config.blind and b.config.blind.key)
        or ''
    if type(key) ~= 'string' then key = '' end
    local k = string.lower(key):gsub("%s+", "")
    return k == 'bl_ashersba_velvetflower' or k == 'velvetflower'
end

local function ashersba_apply_sus_penalty()
    if G and G.GAME then
        G.GAME.chips = -9999999
        if G.GAME.round_scores and G.GAME.round_scores.hand then
            G.GAME.round_scores.hand.amt = -9999999
        end
    end
end

local function ashersba_force_enhanced_set(card)
    if not card then
        return
    end
    card.ability = card.ability or {}
    card.ability.set = card.ability.set or 'Enhanced'
end

local function ashersba_fix_hidden_curse_sets()
    if not (G and G.playing_cards) then
        return
    end
    for _, c in ipairs(G.playing_cards) do
        local key = c and c.config and c.config.center and c.config.center.key and string.lower(c.config.center.key) or ''
        if key:find('sus_', 1, true) or key:find('deadcurse_', 1, true) then
            ashersba_force_enhanced_set(c)
        end
    end
end

local ashersba_woomy_color_keys = {
    'color_red', 'color_orange', 'color_yellow', 'color_green', 'color_blue', 'color_purple', 'color_white'
}

local function ashersba_get_woomy_color_centers()
    if not G or not G.P_CENTERS then
        return {}
    end
    local out = {}
    for _, key in ipairs(ashersba_woomy_color_keys) do
        local c = G.P_CENTERS['m_ashersba_' .. key] or G.P_CENTERS['m_' .. key]
        if c then
            out[#out + 1] = c
        end
    end
    return out
end

local function ashersba_is_woomy_color_center(center)
    if not center or not center.key then
        return false
    end
    local k = string.lower(center.key)
    for _, color_key in ipairs(ashersba_woomy_color_keys) do
        if k == ('m_ashersba_' .. color_key) or k == ('m_' .. color_key) then
            return true
        end
    end
    return false
end

local function ashersba_pick_random_woomy_center(centers, seed_suffix)
    if not centers or #centers == 0 then
        return nil
    end
    local idx = math.floor(pseudorandom('woomy_color_pick_' .. tostring(seed_suffix or 'x')) * #centers) + 1
    return centers[math.min(#centers, math.max(1, idx))]
end

local function ashersba_set_woomy_color(card, center)
    if not card or not center then
        return
    end
    local current = card.config and card.config.center
    card.ability = card.ability or {}
    if current and not ashersba_is_woomy_color_center(current) and not card.ability.ashersba_woomy_prev_center_key then
        card.ability.ashersba_woomy_prev_center_key = current.key
    end
    card:set_ability(center, nil, true)
end

local function ashersba_seed_woomy_colors()
    if not (G and G.playing_cards and #G.playing_cards > 0) then
        return
    end
    local color_centers = ashersba_get_woomy_color_centers()
    if #color_centers == 0 then
        return
    end

    local pool = {}
    for _, c in ipairs(G.playing_cards) do
        pool[#pool + 1] = c
    end

    local function pop_random(seed_tag)
        if #pool <= 0 then return nil end
        local idx = math.floor(pseudorandom(seed_tag) * #pool) + 1
        return table.remove(pool, math.min(#pool, math.max(1, idx)))
    end

    -- Ensure each color appears at least once when deck size permits.
    local guaranteed = math.min(#color_centers, #pool)
    for i = 1, guaranteed do
        local target = pop_random('woomy_guaranteed_' .. tostring(i))
        if target then
            ashersba_set_woomy_color(target, color_centers[i])
        end
    end

    for i = 1, #pool do
        local target = pool[i]
        if target then
            ashersba_set_woomy_color(target, ashersba_pick_random_woomy_center(color_centers, 'woomy_rest_' .. tostring(i)))
        end
    end
end

local function ashersba_assign_woomy_to_uncolored_all()
    if not (G and G.playing_cards and #G.playing_cards > 0) then
        return
    end
    local color_centers = ashersba_get_woomy_color_centers()
    if #color_centers == 0 then
        return
    end
    for i, c in ipairs(G.playing_cards) do
        local center = c and c.config and c.config.center
        if c and (not center or not ashersba_is_woomy_color_center(center)) then
            ashersba_set_woomy_color(c, ashersba_pick_random_woomy_center(color_centers, 'woomy_fill_' .. tostring(i)))
        end
    end
end

local function ashersba_clear_woomy_colors()
    if not (G and G.playing_cards) then
        return
    end
    for _, c in ipairs(G.playing_cards) do
        if c and c.ability then
            local current = c.config and c.config.center
            if current and ashersba_is_woomy_color_center(current) then
                local prev_key = c.ability.ashersba_woomy_prev_center_key
                local prev_center = prev_key and G and G.P_CENTERS and G.P_CENTERS[prev_key] or nil
                c:set_ability(prev_center or G.P_CENTERS.c_base, nil, true)
            end
            c.ability.ashersba_woomy_prev_center_key = nil
        end
    end
end

local function ashersba_hand_has_multiple_woomy_colors(cards)
    if type(cards) ~= 'table' then
        return false
    end
    local seen = {}
    local total = 0
    for _, c in ipairs(cards) do
        local center_key = c and c.config and c.config.center and c.config.center.key
        local color_name = center_key and string.lower(center_key) or 'none'
        if not ashersba_is_woomy_color_center(c and c.config and c.config.center) then
            color_name = 'none'
        end
        if not seen[color_name] then
            seen[color_name] = true
            total = total + 1
            if total > 1 then
                return true
            end
        end
    end
    return false
end

local function ashersba_seed_jevil_sus_cards()
    if not (G and G.playing_cards and #G.playing_cards > 0 and G.P_CENTERS) then
        return
    end

    local sus_centers = {}
    for i = 1, 8 do
        local c = G.P_CENTERS['m_ashersba_sus_' .. tostring(i)] or G.P_CENTERS['m_sus_' .. tostring(i)]
        if c then
            sus_centers[#sus_centers + 1] = c
        end
    end
    if #sus_centers == 0 then
        for _, c in pairs(G.P_CENTERS) do
            local ck = c and c.key and string.lower(c.key) or ''
            if c and c.set == 'Enhanced' and ck:find('sus_', 1, true) then
                sus_centers[#sus_centers + 1] = c
            end
        end
    end
    if #sus_centers == 0 then
        return
    end

    local pool = {}
    for _, c in ipairs(G.playing_cards) do
        pool[#pool + 1] = c
    end

    local to_apply = math.min(8, #pool)
    for i = 1, to_apply do
        if #pool <= 0 then break end
        local idx = math.floor(pseudorandom('jevil_sus_pick_' .. tostring(i)) * #pool) + 1
        local target = table.remove(pool, idx)
        local sus_index = math.floor(pseudorandom('jevil_sus_center_pick') * #sus_centers) + 1
        local center = sus_centers[math.min(#sus_centers, math.max(1, sus_index))]
        if target and center then
            target:set_ability(center, nil, true)
            ashersba_force_enhanced_set(target)
        end
    end
end

local function ashersba_add_deadcurse_cards(amount)
    if not (G and G.P_CENTERS and G.playing_cards and #G.playing_cards > 0) then
        return
    end
    local dead_centers = {}
    for i = 1, 4 do
        local c = G.P_CENTERS['m_ashersba_deadcurse_' .. tostring(i)] or G.P_CENTERS['m_deadcurse_' .. tostring(i)]
        if c then
            dead_centers[#dead_centers + 1] = c
        end
    end
    if #dead_centers == 0 then
        for _, c in pairs(G.P_CENTERS) do
            local ck = c and c.key and string.lower(c.key) or ''
            if c and c.set == 'Enhanced' and ck:find('deadcurse_', 1, true) then
                dead_centers[#dead_centers + 1] = c
            end
        end
    end
    if #dead_centers == 0 then
        return
    end

    local pool = {}
    for _, c in ipairs(G.playing_cards) do
        pool[#pool + 1] = c
    end

    local to_apply = math.min(amount, #pool)
    for i = 1, to_apply do
        if #pool <= 0 then break end
        local pick_index = math.floor(pseudorandom('jevil_dead_pick_' .. tostring(i)) * #pool) + 1
        local target = table.remove(pool, pick_index)
        local dead_index = math.floor(pseudorandom('jevil_dead_center_pick_' .. tostring(i)) * #dead_centers) + 1
        local dead_center = dead_centers[math.min(#dead_centers, math.max(1, dead_index))]
        if target and dead_center then
            target:set_ability(dead_center, nil, true)
            ashersba_force_enhanced_set(target)
        end
    end
end

local function ashersba_ensure_jevil_discard_hook()
    if not (G and G.FUNCS and G.FUNCS.discard_cards_from_highlighted) then
        return
    end
    if G.FUNCS.ashersba_jevil_discard_wrapped then
        return
    end

    local ref = G.FUNCS.discard_cards_from_highlighted
    G.FUNCS.discard_cards_from_highlighted = function(e, hook)
        local had_cards = G and G.hand and G.hand.highlighted and #G.hand.highlighted or 0
        local had_sus = false
        if had_cards > 0 and G and G.hand and G.hand.highlighted then
            for _, c in ipairs(G.hand.highlighted) do
                local key = c and c.config and c.config.center and c.config.center.key and string.lower(c.config.center.key) or ''
                if key:find('sus_', 1, true) then
                    had_sus = true
                    break
                end
            end
        end
        local ret = ref(e, hook)
        if G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_sus_mode and had_cards > 0 then
            ashersba_add_deadcurse_cards(2)
            if had_sus then
                ashersba_apply_sus_penalty()
            end
        end
        return ret
    end
    G.FUNCS.ashersba_jevil_discard_wrapped = true
end

local velvet_blind_debuff_hand_ref = Blind.debuff_hand
function Blind.debuff_hand(self, cards, hand, handname, check)
    if not check and G and G.GAME and not ashersba_is_velvet_fight(self) then
        local label = handname or hand or ''
        if ashersba_is_royal_flush_label(label) or ashersba_is_royal_flush_cards(cards) then
            G.GAME.ashersba_velvet_royal_seen = true
        end
    end

    if velvet_blind_debuff_hand_ref then
        return velvet_blind_debuff_hand_ref(self, cards, hand, handname, check)
    end
    return false
end

SMODS.Blind({
    key = "Clopen",
    atlas = "SecretBoss",
    pos = { x = 0, y = 1 },
    mult = 2,
    boss = {
        showdown = true,
    },
    discovered = false,
    dollars = 8,
    boss_colour = G.C.BLUE,
    reward_resets = true,
    loc_txt = {
        name = "Clopen",
        text = {
            "Gives Debuff Cards",
        },
    },

    in_pool = function(self)
        local target_ante = (G and G.GAME and G.GAME.win_ante) or 9
        return G
            and G.GAME
            and G.GAME.modifiers
            and G.GAME.modifiers.ashersba_secret_deck
            and G.GAME.round_resets
            and G.GAME.round_resets.ante == target_ante
    end,

    set_blind = function(self)
    end,
})

SMODS.Blind({
    key = "Jevil",
    atlas = "SecretBoss",
    pos = { x = 0, y = 0 },
    mult = 2,
    boss_colour = G.C.RED,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    reward_resets = true,
    loc_txt = {
        name = "Gray",
        text = {
            "The House Always Wins..."
        },
    },

    set_blind = function(self)
        if not (G and G.GAME) then
            return
        end
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_sus_mode = true
        ashersba_ensure_jevil_discard_hook()
        ashersba_fix_hidden_curse_sets()

        if not G.GAME.ashersba_jevil_sus_seeded then
            ashersba_seed_jevil_sus_cards()
            G.E_MANAGER:add_event(Event({
                delay = 0.1,
                func = function()
                    ashersba_seed_jevil_sus_cards()
                    ashersba_fix_hidden_curse_sets()
                    return true
                end
            }))
            G.GAME.ashersba_jevil_sus_seeded = true
        end
    end,

    disable = function(self)
        if G and G.GAME and G.GAME.modifiers then
            G.GAME.modifiers.ashersba_sus_mode = false
            G.GAME.ashersba_jevil_sus_seeded = false
        end
    end,

    defeat = function(self)
        if G and G.GAME and G.GAME.modifiers then
            G.GAME.modifiers.ashersba_sus_mode = false
            G.GAME.ashersba_jevil_sus_seeded = false
        end
    end
})

SMODS.Blind({
    key = "Minty",
    atlas = "SecretBoss",
    pos = { x = 0, y = 2 },
    mult = 2,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    boss_colour = HEX("C0FFEE"),
    reward_resets = true,
    loc_txt = {
        name = "Woomy",
        text = {
            "Special Flushes Only",
        },
    },

    set_blind = function(self)
        if not (G and G.GAME) then
            return
        end
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_woomy_mode = true
        ashersba_seed_woomy_colors()
        ashersba_assign_woomy_to_uncolored_all()
    end,

    drawn_to_hand = function(self, cards)
        if not (G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_woomy_mode) then
            return
        end
        local pool = cards
        if not pool then
            pool = (G and G.hand and G.hand.cards) or {}
        elseif pool and pool.base and pool.area then
            pool = { pool }
        end
        local color_centers = ashersba_get_woomy_color_centers()
        if #color_centers == 0 then
            return
        end
        for i, c in ipairs(pool) do
            local center = c and c.config and c.config.center
            if c and (not center or not ashersba_is_woomy_color_center(center)) then
                ashersba_set_woomy_color(c, ashersba_pick_random_woomy_center(color_centers, 'woomy_drawn_' .. tostring(i)))
            end
        end
        ashersba_assign_woomy_to_uncolored_all()
    end,

    press_play = function(self)
        if G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_woomy_mode then
            ashersba_assign_woomy_to_uncolored_all()
        end
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        ashersba_assign_woomy_to_uncolored_all()
        return ashersba_hand_has_multiple_woomy_colors(cards)
    end,

    get_loc_debuff_text = function(self)
        return "One Color Only"
    end,

    disable = function(self)
        if G and G.GAME and G.GAME.modifiers then
            G.GAME.modifiers.ashersba_woomy_mode = false
        end
        ashersba_clear_woomy_colors()
    end,

    defeat = function(self)
        if G and G.GAME and G.GAME.modifiers then
            G.GAME.modifiers.ashersba_woomy_mode = false
        end
        ashersba_clear_woomy_colors()
    end,
})

SMODS.Blind({
    key = "Argent Blade",
    atlas = "Boss",
    pos = { x = 0, y = 0 },
    mult = 2,
    boss = {
        showdown = true
    },
    boss_colour = G.C.BLUE,
    discovered = false,
    dollars = 8,
    reward_resets = true,
    loc_txt = {
        name = "Argent Blade",
        text = {
            "Clubs Disabled, Hearts and Diamonds Drawn Face Down."
        },
    },

    debuff_card = function(self, card, from_blind)
        return card and card:is_suit('Clubs')
    end,

    drawn_to_hand = function(self, cards)
        local pool = cards
        if not pool then
            pool = (G and G.hand and G.hand.cards) or {}
        elseif pool and pool.base and pool.area then
            pool = { pool }
        end

        for _, c in ipairs(pool) do
            if c and (c:is_suit('Hearts') or c:is_suit('Diamonds')) and c.facing ~= 'back' then
                c:flip()
            end
        end
    end,
})

SMODS.Blind({
    key = "Oxide Baton",
    atlas = "Boss",
    pos = { x = 0, y = 1 },
    mult = 2,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    boss_colour = G.C.BLUE,
    reward_resets = true,
    loc_txt = {
        name = "Oxide Baton",
        text = {
            "Money must be exactly 40$ or Sets hands to 1."
        },
    },

    set_blind = function(self)
        if not (G and G.GAME and G.GAME.current_round and G.GAME.round_resets) then
            return
        end

        if (G.GAME.dollars or 0) ~= 40 then
            G.GAME.round_resets.hands = 1
            G.GAME.current_round.hands_left = 1
        end
    end,
})

SMODS.Blind({
    key = "Umber Club",
    atlas = "Boss",
    pos = { x = 0, y = 2 },
    mult = 2,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    boss_colour = G.C.BLUE,
    reward_resets = true,
    loc_txt = {
        name = "Umber Club",
        text = {
            "Halves Hand Size."
        },
    },

    set_blind = function(self)
        if not (G and G.hand and G.hand.config and G.hand.change_size) then
            return
        end

        local current_size = G.hand.config.card_limit or 0
        local target_size = math.max(1, math.floor(current_size / 2))
        local delta = target_size - current_size

        self.ashersba_umber_size_delta = delta
        if delta ~= 0 then
            G.hand:change_size(delta)
        end
    end,

    disable = function(self)
        if G and G.hand and G.hand.change_size and self.ashersba_umber_size_delta and self.ashersba_umber_size_delta ~= 0 then
            G.hand:change_size(-self.ashersba_umber_size_delta)
            self.ashersba_umber_size_delta = 0
        end
    end,

    defeat = function(self)
        if G and G.hand and G.hand.change_size and self.ashersba_umber_size_delta and self.ashersba_umber_size_delta ~= 0 then
            G.hand:change_size(-self.ashersba_umber_size_delta)
            self.ashersba_umber_size_delta = 0
        end
    end,
})

SMODS.Blind({
    key = "Golden Coin",
    atlas = "Boss",
    pos = { x = 0, y = 3 },
    mult = 2,
    boss_colour = G.C.BLUE,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    reward_resets = true,
    loc_txt = {
        name = "Golden Coin",
        text = {
            "+2 Hands, 1 in 2 chance hand will not score."
        },
    },

    set_blind = function(self)
        if not (G and G.GAME and G.GAME.current_round and G.GAME.round_resets) then
            return
        end

        G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 2
        G.GAME.current_round.hands_left = (G.GAME.current_round.hands_left or 0) + 2
    end,

    press_play = function(self)
        self.ashersba_golden_coin_blank_hand = pseudorandom('golden_coin_blank_hand') < ((G.GAME and G.GAME.probabilities and G.GAME.probabilities.normal) or 1) / 2
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        if self.ashersba_golden_coin_blank_hand then
            return true
        end
        return false
    end,

    get_loc_debuff_text = function(self)
        if self.ashersba_golden_coin_blank_hand then
            return "No score"
        end
    end,
})

SMODS.Blind({
    key = "Thistle Shield",
    atlas = "Boss",
    pos = { x = 0, y = 4 },
    mult = 2,
    boss_colour = G.C.BLUE,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    reward_resets = true,
    loc_txt = {
        name = "Thistle Shield",
        text = {
            "-1 Ante (Continues Blind Requirements)"
        },
    },

    set_blind = function(self)
        if self.ashersba_thistle_done then
            return
        end
        self.ashersba_thistle_done = true

        if ease_ante then
            ease_ante(-1)
        end

        if G and G.GAME and G.GAME.round_resets then
            G.GAME.round_resets.blind_ante = (G.GAME.round_resets.blind_ante or 0) + 1
        end
    end,

    defeat = function(self)
        self.ashersba_thistle_done = false
    end,
})

SMODS.Blind({
    key = "Velvet Flower",
    atlas = "Boss",
    pos = { x = 0, y = 5 },
    mult = 2,
    boss_colour = G.C.BLUE,
    boss = {
        showdown = true
    },
    discovered = false,
    dollars = 8,
    reward_resets = true,
    loc_txt = {
        name = "Velvet Flower",
        text = {
            "Requires A Royal Flush to Score. "
        },
    },

    debuff_hand = function(self, cards, hand, handname, check)
        local royal_seen = G and G.GAME and G.GAME.ashersba_velvet_royal_seen
        if not royal_seen then
            return false
        end

        local label = handname or hand or ''
        local is_royal = ashersba_is_royal_flush_label(label) or ashersba_is_royal_flush_cards(cards)
        return not is_royal
    end,

    get_loc_debuff_text = function(self)
        return "Needs Royal Flush"
    end,

    disable = function(self)
        if G and G.GAME then
            G.GAME.ashersba_velvet_royal_seen = false
        end
    end,

    defeat = function(self)
        if G and G.GAME then
            G.GAME.ashersba_velvet_royal_seen = false
        end
    end,
})

