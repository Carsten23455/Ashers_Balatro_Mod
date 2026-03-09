
SMODS.Joker{ --The Ferry
    key = "theferry",
    config = {
        extra = {
            Mult = 0,
            Chips = 0
        }
    },
    loc_txt = {
        ['name'] = 'The Ferry',
        ['text'] = {
            [1] = '{C:red}+8{} Mult and {C:blue}+50{} Chips per {C:planet}Pluto{} used',
            [2] = '{C:inactive}(Currently #1# Mult and #2# Chips){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 6
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
        
        return {vars = {card.ability.extra.Mult, card.ability.extra.Chips}}
    end,
    
    calculate = function(self, card, context)
        if context.using_consumeable  then
            if context.consumeable and context.consumeable.ability.set == 'Planet' and context.consumeable.config.center.key == 'c_pluto' then
                return {
                    func = function()
                        card.ability.extra.Mult = (card.ability.extra.Mult) + 8
                        return true
                    end,
                    extra = {
                        func = function()
                            card.ability.extra.Chips = (card.ability.extra.Chips) + 50
                            return true
                        end,
                        colour = G.C.GREEN
                    }
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                mult = card.ability.extra.Mult,
                extra = {
                    chips = card.ability.extra.Chips,
                    colour = G.C.CHIPS
                }
            }
        end
    end
}
