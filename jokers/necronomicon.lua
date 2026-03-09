SMODS.Joker{ --Necronomicon
    key = "necronomicon",
    config = {
        extra = {
            odds = 6,
            repetitions = 2
        }
    },
    loc_txt = {
        ['name'] = 'Necronomicon',
        ['text'] = {
            [1] = 'Two Pair cards retrigger {C:attention}2{} times',
            [2] = '{C:green}1 in 6{} chance to curse a random deck card',
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 5
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

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_ashersba_necronomicon')
        return { vars = { card.ability.extra.repetitions, new_numerator, new_denominator } }
    end,

    calculate = function(self, card, context)
        local cursed_center = G.P_CENTERS.m_ashersba_cursed or G.P_CENTERS.m_cursed
        local function contains_two_pair(cards)
            if type(cards) ~= 'table' or #cards < 4 then
                return false
            end
            local counts = {}
            for _, c in ipairs(cards) do
                if c and c.get_id then
                    local id = c:get_id()
                    counts[id] = (counts[id] or 0) + 1
                end
            end
            local pair_ranks = 0
            for _, n in pairs(counts) do
                if n >= 2 then
                    pair_ranks = pair_ranks + 1
                end
            end
            return pair_ranks >= 2
        end

        local function is_cursed(playing_card)
            if not playing_card then return false end
            local center = playing_card.config and playing_card.config.center
            return center and (center.key == 'm_ashersba_cursed' or center.key == 'm_cursed')
        end

        local function add_cursed_card_to_deck()
            if not (cursed_center and G and G.deck and G.playing_cards) then
                return nil
            end
            local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('necronomicon_curse_front'))
            local base_card = create_playing_card({
                front = card_front,
                center = cursed_center
            }, G.discard, true, false, nil, true)

            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local new_card = copy_card(base_card, nil, nil, G.playing_card)
            new_card:add_to_deck()

            G.deck.config.card_limit = G.deck.config.card_limit + 1
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
            return new_card
        end

        local hand_has_two_pair = contains_two_pair(context.scoring_hand or context.full_hand)

        if context.repetition and context.cardarea == G.play and context.other_card and hand_has_two_pair then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.repetitions,
                card = card
            }
        end

        if context.cardarea == G.jokers and context.joker_main and hand_has_two_pair and cursed_center then
            if SMODS.pseudorandom_probability(card, 'necronomicon_curse_roll', 1, card.ability.extra.odds, 'j_ashersba_necronomicon', false) then
                local target = (G.playing_cards and #G.playing_cards > 0) and pseudorandom_element(G.playing_cards, pseudoseed('necronomicon_curse_target')) or nil
                if target then
                    target:set_ability(cursed_center, nil, true)
                    return {
                        message = 'Cursed!',
                        colour = G.C.RED
                    }
                end
            end
        end

        if context.remove_playing_cards and context.removed and #context.removed > 0 then
            local cursed_removed = 0
            for _, removed_card in ipairs(context.removed) do
                if is_cursed(removed_card) then
                    cursed_removed = cursed_removed + 1
                end
            end
            if cursed_removed > 0 then
                for i = 1, cursed_removed do
                    add_cursed_card_to_deck()
                end
                return {
                    message = 'Curse Spreads!',
                    colour = G.C.RED
                }
            end
        end
    end
}

