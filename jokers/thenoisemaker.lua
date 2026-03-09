
SMODS.Joker{ --The Noisemaker
    key = "thenoisemaker",
    config = {
        extra = {
            mult0 = 5,
            odds = 16,
            xmult0 = 5
        }
    },
    loc_txt = {
        ['name'] = 'The Noisemaker',
        ['text'] = {
            [1] = 'When a Hand is played',
            [2] = '{C:green}1{} in {C:green}16{} chance for {X:red,C:white}X5{} Mult',
            [3] = 'otherwise, {C:red}+5{} Mult'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
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
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_ashersba_thenoisemaker') 
        return {vars = {new_numerator, new_denominator}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                return {
                    mult = 5
                    ,
                    func = function()
                        if SMODS.pseudorandom_probability(card, 'group_0_a297d6eb', 1, card.ability.extra.odds, 'j_ashersba_thenoisemaker', false) then
                            SMODS.calculate_effect({Xmult = 5}, card)
                        end
                        return true
                    end
                }
            end
        end
    end
}

