
SMODS.Joker{ --Air Hockey
    key = "airhockey",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Air Hockey',
        ['text'] = {
            [1] = '{C:green}1 in 4{} chance for {C:red}+20{} Mult otherwise {C:blue}+80{} Chips',
            [2] = '{C:inactive}(Immune to Disabled){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
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
    pools = { ["ashersba_ashersba_jokers"] = true }
    ,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            -- Immune to disabled/debuffed states
            if card.set_debuff then
                card:set_debuff(false)
            else
                card.debuff = false
            end

            local hit_mult = SMODS.pseudorandom_probability(
                card,
                'airhockey_roll',
                1,
                4,
                'j_ashersba_airhockey',
                false
            )
            if hit_mult then
                return { mult = 20 }
            end
            return {
                chips = 80,
                colour = G.C.CHIPS
            }
        end
    end
}

