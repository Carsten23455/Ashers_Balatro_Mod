
SMODS.Joker{ --Team Comedians
    key = "teamcomedians",
    config = {
        extra = {
            Chips = 0
        }
    },
    loc_txt = {
        ['name'] = 'Team Comedians',
        ['text'] = {
            [1] = '{C:blue}+25{} Chips Each time any pack or blind is skipped',
            [2] = '{C:inactive}Currently +#1# Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 7
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
        
        return {vars = {card.ability.extra.Chips}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                chips = card.ability.extra.Chips
            }
        end
        if context.skipping_booster  then
            return {
                func = function()
                    card.ability.extra.Chips = (card.ability.extra.Chips) + 25
                    return true
                end
            }
        end
        if context.skip_blind  then
            return {
                func = function()
                    card.ability.extra.Chips = (card.ability.extra.Chips) + 25
                    return true
                end
            }
        end
    end
}
