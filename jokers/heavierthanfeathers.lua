
SMODS.Joker{ --Heavier than feathers
    key = "heavierthanfeathers",
    config = {
        extra = {
            AmountLoop = 0,
            xmult0 = 2,
            xchips0 = 2
        }
    },
    loc_txt = {
        ['name'] = 'Heavier than feathers',
        ['text'] = {
            [1] = 'for every steel card played',
            [2] = '{X:red,C:white}X2 Mult{}',
            [3] = 'otherwise',
            [4] = '{X:blue,C:white} 2x Chips{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_steamkey_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.AmountLoop}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                Xmult = 2
            }
        end
        if context.individual and context.cardarea == G.play  then
            return {
                x_chips = 2
            }
        end
    end
}

