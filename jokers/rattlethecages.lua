
SMODS.Joker{ --Rattle the Cages
    key = "rattlethecages",
    config = {
        extra = {
            triggered_this_round = false
        }
    },
    loc_txt = {
        ['name'] = 'Rattle the Cages',
        ['text'] = {
            [1] = '{C:enhanced}Enhance{} the first card scored each round.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
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

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.triggered_this_round = false
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.triggered_this_round = false
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            if card.ability.extra.triggered_this_round then
                return
            end

            local possible_enhancements = {
                G.P_CENTERS.m_bonus,
                G.P_CENTERS.m_mult,
                G.P_CENTERS.m_wild,
                G.P_CENTERS.m_glass,
                G.P_CENTERS.m_steel,
                G.P_CENTERS.m_lucky,
                G.P_CENTERS.m_gold
            }
            local valid_enhancements = {}
            for _, center in ipairs(possible_enhancements) do
                if center then table.insert(valid_enhancements, center) end
            end

            if #valid_enhancements > 0 then
                local chosen_enhancement = pseudorandom_element(valid_enhancements, pseudoseed('rattlethecages_enhance'))
                context.other_card:set_ability(chosen_enhancement, nil, true)
                card.ability.extra.triggered_this_round = true
                return {
                    message = "Enhanced!",
                    colour = G.C.GREEN
                }
            end
        end
    end
}

