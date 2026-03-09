
SMODS.Joker{ --Staceys mom
    key = "staceysmom",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Staceys mom',
        ['text'] = {
            [1] = 'If played hand contains a {C:attention}Queen{},',
            [2] = 'turn it into a {C:attention}Wild{} card',
            [3] = 'and create {C:tarot}The Lovers{}',
            [4] = '{C:inactive}(Must have room){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
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
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand then
            local wild_center = G.P_CENTERS.m_wild
            if not wild_center then return end

            local found_queen = false
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card and playing_card:get_id() == 12 then
                    found_queen = true
                    local enhancements = SMODS.get_enhancements(playing_card)
                    if not enhancements["m_wild"] then
                        playing_card:set_ability(wild_center, nil, true)
                    end
                end
            end

            if found_queen then
                local created_consumable = false
                for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
                    created_consumable = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            play_sound('timpani')
                            SMODS.add_card({ set = 'Tarot', key = 'c_lovers' })
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                end
                delay(0.6)

                return {
                    message = created_consumable and localize('k_plus_tarot') or 'Wild!',
                    colour = created_consumable and G.C.PURPLE or G.C.GREEN
                }
            end
        end
    end
}

