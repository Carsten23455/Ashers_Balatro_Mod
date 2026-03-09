
SMODS.Joker{ --Out of Bounds
    key = "outofbounds",
    config = {
        extra = {
            Straight_Level_Num = 1,
            straightflushlevel = 1
        }
    },
    loc_txt = {
        ['name'] = 'Out of Bounds',
        ['text'] = {
            [1] = 'Adds X Chips and {X:red,C:white}X{} Mult from Current Straight Level to played Hand'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.Straight_Level_Num, localize((G.GAME.current_round.straight_level_hand or 'High Card'), 'poker_hands'), card.ability.extra.straightflushlevel + ((G.GAME.hands['Straight Flush'].level or 0))}}
    end,
    
    set_ability = function(self, card, initial)
        G.GAME.current_round.straight_level_hand = 'Straight'
    end,
    
    calculate = function(self, card, context)
        -- Update the stored level number when a blind is set
        if context.setting_blind then
            card.ability.extra.Straight_Level_Num = G.GAME.hands['Straight'].level
        end

        -- Add the Straight's Chips and Mult to the currently played hand
        if context.joker_main then
            local straight_data = G.GAME.hands['Straight']
            return {
                message = 'Out of Bounds!',
                chips = straight_data.chips,
                mult = straight_data.mult,
                colour = G.C.CHIPS
            }
        end
    end
}

