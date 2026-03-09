
SMODS.Joker{ --The Mechanic
    key = "themechanic",
    config = {
        extra = {
            xmult0 = 5,
            chips0 = 50,
            mult0 = 3,
            chips = 50
        }
    },
    loc_txt = {
        ['name'] = 'The Mechanic',
        ['text'] = {
            [1] = 'When in a Boss Blind {X:red,C:white}X5{} Mult',
            [2] = 'otherwise {C:red}+3{} Mult',
            [3] = '{C:blue}+50{} Chips'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "ashersba_crewmate",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if G.GAME.blind.boss then
                return {
                    Xmult = 5,
                    extra = {
                        chips = 50,
                        colour = G.C.CHIPS
                    }
                }
            elseif not (G.GAME.blind.boss) then
                return {
                    mult = 3,
                    extra = {
                        chips = 50,
                        colour = G.C.CHIPS
                    }
                }
            end
        end
    end
}

