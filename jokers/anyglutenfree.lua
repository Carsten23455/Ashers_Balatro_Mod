
SMODS.Joker{ --Any Gluten Free?
	    key = "anyglutenfree",
	    config = {
	        extra = {
	            mult_per_negative_dollar = 4
	        }
	    },
	    loc_txt = {
	        ['name'] = 'Any Gluten Free?',
	        ['text'] = {
	            [1] = '{C:red}+4{} Mult Per -{C:gold}$$${}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
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
	        local dollars = (G and G.GAME and G.GAME.dollars) or 0
	        local per = (card.ability.extra and card.ability.extra.mult_per_negative_dollar) or 4
	        local current_mult = 0
	        if dollars < 0 then current_mult = (-dollars) * per end
	        return {vars = {current_mult}}
	    end,
	    
	    calculate = function(self, card, context)
	        if context.cardarea == G.jokers and context.joker_main  then
	            local dollars = (G and G.GAME and G.GAME.dollars) or 0
	            local per = (card.ability.extra and card.ability.extra.mult_per_negative_dollar) or 4
	            if dollars < 0 then
	                return { mult = (-dollars) * per }
	            end
	            return {
	                mult = 0
	            }
	        end
	    end
	} 

