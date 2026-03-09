
SMODS.Joker{ --Technical Difficulties
    key = "technicaldifficulties",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Technical Difficulties',
        ['text'] = {
            [1] = 'Turns {C:spades}Spades{} into',
            [2] = '{C:attention}Glass{} cards',
            [3] = '{C:inactive}(Glass cards now break more often){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
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
        local glass_center = G.P_CENTERS.m_glass
        if not glass_center then return end

        local function make_spades_glass()
            if not G or not G.playing_cards then return end
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card and playing_card:is_suit("Spades") then
                    local enh = SMODS.get_enhancements(playing_card)
                    if not enh["m_glass"] then
                        playing_card:set_ability(glass_center, nil, true)
                    end
                end
            end
        end

        if context.setting_blind and not context.blueprint then
            make_spades_glass()
            return {
                message = "Corrupted!"
            }
        end

        if context.destroy_card and context.destroy_card.should_destroy then
            return { remove = true }
        end

        if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
            local enh = SMODS.get_enhancements(context.other_card)
            if enh["m_glass"] and not context.other_card.should_destroy then
                if SMODS.pseudorandom_probability(card, 'technicaldifficulties_break', 1, 2, 'j_ashersba_technicaldifficulties', false) then
                    context.other_card.should_destroy = true
                    return {
                        message = "Shattered!",
                        colour = G.C.RED
                    }
                end
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        local glass_center = G.P_CENTERS.m_glass
        if not glass_center or not G or not G.playing_cards then return end
        for _, playing_card in ipairs(G.playing_cards) do
            if playing_card and playing_card:is_suit("Spades") then
                local enh = SMODS.get_enhancements(playing_card)
                if not enh["m_glass"] then
                    playing_card:set_ability(glass_center, nil, true)
                end
            end
        end
    end
}

