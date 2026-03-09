local PHONECALL_SUITS = { 'Spades', 'Hearts', 'Clubs', 'Diamonds' }
local PHONECALL_HANDS = {
    'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight',
    'Flush', 'Full House', 'Four of a Kind', 'Straight Flush', 'Royal Flush'
}
local PHONECALL_RANKS = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
local PHONECALL_TYPES = {
    'retrigger_target',
    'mult_target',
    'chips_target',
    'dollars_target',
    'reroll_discount',
    'xmult2',
    'madness_like',
    'hands_discards',
    'blueprint_like'
}

local function phonecall_pick_target(seed_key)
    local t = pseudorandom(seed_key .. '_kind')
    if t < 0.34 then
        local suit = pseudorandom_element(PHONECALL_SUITS, pseudoseed(seed_key .. '_suit'))
        return { kind = 'suit', value = suit, label = suit }
    elseif t < 0.67 then
        local rank = pseudorandom_element(PHONECALL_RANKS, pseudoseed(seed_key .. '_rank'))
        local rank_label = rank == 14 and 'Ace' or tostring(rank)
        return { kind = 'rank', value = rank, label = rank_label }
    end
    local hand = pseudorandom_element(PHONECALL_HANDS, pseudoseed(seed_key .. '_hand'))
    return { kind = 'hand', value = hand, label = hand }
end

local function phonecall_roll_ability(seed_key)
    local ability_type = pseudorandom_element(PHONECALL_TYPES, pseudoseed(seed_key .. '_type'))
    local ability = { type = ability_type }
    if ability_type == 'retrigger_target' or ability_type == 'mult_target' or ability_type == 'chips_target' or ability_type == 'dollars_target' then
        ability.target = phonecall_pick_target(seed_key)
    end
    return ability
end

local function phonecall_target_matches(target, context, scoring_card)
    if not target then return false end
    if target.kind == 'suit' then
        return scoring_card and scoring_card.is_suit and scoring_card:is_suit(target.value)
    elseif target.kind == 'rank' then
        return scoring_card and scoring_card.get_id and scoring_card:get_id() == target.value
    elseif target.kind == 'hand' then
        return context and context.scoring_name == target.value
    end
    return false
end

local function phonecall_count_matches(target, context)
    if not target or not context then return 0 end
    if target.kind == 'hand' then
        return context.scoring_name == target.value and 1 or 0
    end
    local n = 0
    for _, c in ipairs(context.scoring_hand or {}) do
        if phonecall_target_matches(target, context, c) then
            n = n + 1
        end
    end
    return n
end

SMODS.Joker{ --Phone Call
    key = "phonecall",
    config = {
        extra = {
            abilities = {},
            last_ante = -1,
            madness_xmult = 1
        }
    },
    loc_txt = {
        ['name'] = 'Phone Call',
        ['text'] = {
            [1] = 'Upon purchase, gains a random permanent effect.',
            [2] = 'Gains another random effect each ante.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 8
    },
    display_size = {
        w = 71 * 1,
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },

    add_to_deck = function(self, card, from_debuff)
        if not card.ability.extra.abilities then
            card.ability.extra.abilities = {}
        end
        card.ability.extra.abilities[#card.ability.extra.abilities + 1] = phonecall_roll_ability('phonecall_buy')
        if G and G.GAME and G.GAME.round_resets then
            card.ability.extra.last_ante = G.GAME.round_resets.ante or 0
        end
    end,

    calculate = function(self, card, context)
        card.ability.extra.abilities = card.ability.extra.abilities or {}

        if context.setting_blind and not context.blueprint and G and G.GAME and G.GAME.round_resets then
            local ante = G.GAME.round_resets.ante or 0
            local new_ante = ante ~= card.ability.extra.last_ante
            if new_ante then
                card.ability.extra.last_ante = ante
                card.ability.extra.abilities[#card.ability.extra.abilities + 1] = phonecall_roll_ability('phonecall_ante_' .. tostring(ante))
                for _, a in ipairs(card.ability.extra.abilities) do
                    if a.type == 'hands_discards' and G.GAME.current_round then
                        G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 1
                        G.GAME.round_resets.discards = math.max(0, (G.GAME.round_resets.discards or 0) - 2)
                        G.GAME.current_round.hands_left = (G.GAME.current_round.hands_left or 0) + 1
                        G.GAME.current_round.discards_left = math.max(0, (G.GAME.current_round.discards_left or 0) - 2)
                    elseif a.type == 'reroll_discount' and G.GAME.current_round then
                        G.GAME.current_round.reroll_cost = math.max(0, (G.GAME.current_round.reroll_cost or 0) - 5)
                    elseif a.type == 'madness_like' then
                        card.ability.extra.madness_xmult = (card.ability.extra.madness_xmult or 1) + 0.5
                        local pool = {}
                        for _, v in ipairs((G.jokers and G.jokers.cards) or {}) do
                            if v ~= card and not v.getting_sliced then
                                pool[#pool + 1] = v
                            end
                        end
                        if #pool > 0 then
                            local target = pseudorandom_element(pool, pseudoseed('phonecall_madness_destroy'))
                            target.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target:start_dissolve({ G.C.RED }, nil, 1.6)
                                    return true
                                end
                            }))
                        end
                    end
                end
                return { message = "New Effect", colour = G.C.ATTENTION }
            end
        end

        if context.repetition and context.cardarea == G.play and context.other_card then
            local reps = 0
            for _, a in ipairs(card.ability.extra.abilities) do
                if a.type == 'retrigger_target' and phonecall_target_matches(a.target, context, context.other_card) then
                    reps = reps + 1
                end
            end
            if reps > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = reps,
                    card = card
                }
            end
        end

        if context.after and not context.blueprint then
            local dollars = 0
            for _, a in ipairs(card.ability.extra.abilities) do
                if a.type == 'dollars_target' then
                    dollars = dollars + (4 * phonecall_count_matches(a.target, context))
                end
            end
            if dollars > 0 then
                ease_dollars(dollars)
                return { message = "+$" .. tostring(dollars), colour = G.C.MONEY }
            end
        end

        if context.cardarea == G.jokers and context.joker_main then
            local out_mult = 0
            local out_chips = 0
            local out_xmult = 1

            for _, a in ipairs(card.ability.extra.abilities) do
                if a.type == 'mult_target' then
                    out_mult = out_mult + (6 * phonecall_count_matches(a.target, context))
                elseif a.type == 'chips_target' then
                    out_chips = out_chips + (50 * phonecall_count_matches(a.target, context))
                elseif a.type == 'xmult2' then
                    out_xmult = out_xmult * 2
                elseif a.type == 'madness_like' then
                    out_xmult = out_xmult * (card.ability.extra.madness_xmult or 1)
                elseif a.type == 'blueprint_like' then
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then my_pos = i break end
                    end
                    local target = (my_pos and G.jokers.cards[my_pos + 1]) or nil
                    if target and target ~= card and target.calculate_joker then
                        local copied = target:calculate_joker(context)
                        if copied then
                            out_mult = out_mult + (copied.mult or 0)
                            out_chips = out_chips + (copied.chips or 0)
                            if copied.Xmult then out_xmult = out_xmult * copied.Xmult end
                        end
                    end
                end
            end

            local out = {}
            if out_mult ~= 0 then out.mult = out_mult end
            if out_chips ~= 0 then
                out.chips = out_chips
                out.colour = G.C.CHIPS
            end
            if out_xmult ~= 1 then out.Xmult = out_xmult end
            if next(out) then return out end
        end
    end
}

