
SMODS.Joker{ --Joker-Onigiri
    key = "jokeronigiri",
    config = {
        extra = {
            Chips_Mult = 0,
            Chips_Mult_Text = '-3 Mult',
            mult0 = -3,
            chips0 = 50,
            chips = -15,
            mult = 12
        }
    },
    loc_txt = {
        ['name'] = 'Joker-Onigiri',
        ['text'] = {
            [1] = 'Switches between {C:blue}+50{} Chips {C:red}-3{} Mult',
            [2] = 'and {C:blue}-12{} Chips {C:red}+12{} Mult',
            [3] = '{C:inactive}Currently #2# {}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 0
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
    pools = { ["ashersba_steamkey_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.Chips_Mult, card.ability.extra.Chips_Mult_Text}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
            if to_big((card.ability.extra.Chips_Mult or 0)) == to_big(0) then
                card.ability.extra.Chips_Mult_Text = '-15 Chips'
                return {
                    func = function()
                        card.ability.extra.Chips_Mult = 1
                        return true
                    end
                }
            elseif to_big((card.ability.extra.Chips_Mult or 0)) == to_big(1) then
                card.ability.extra.Chips_Mult_Text = '-3 Mult'
                return {
                    func = function()
                        card.ability.extra.Chips_Mult = 0
                        return true
                    end
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            if to_big((card.ability.extra.Chips_Mult or 0)) == to_big(0) then
                return {
                    mult = -3,
                    extra = {
                        chips = 50,
                        colour = G.C.CHIPS
                    }
                }
            elseif to_big((card.ability.extra.Chips_Mult or 0)) == to_big(1) then
                return {
                    chips = -15,
                    extra = {
                        mult = 12
                    }
                }
            end
        end
    end
}

