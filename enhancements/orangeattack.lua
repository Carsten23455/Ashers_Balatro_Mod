
SMODS.Enhancement {
    key = 'orangeattack',
    pos = { x = 3, y = 0 },
    config = {
        h_chips = -10
    },
    loc_txt = {
        name = 'OrangeAttack',
        text = {
            [1] = '-10 Chips while held in hand'
        }
    },
    atlas = 'CustomEnhancements',
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
	    always_scores = false,
	    unlocked = true,
	    discovered = false,
	    no_collection = true,
	    weight = 0,
	    in_pool = function(self, args)
	        return false
	    end,
	    calculate = function(self, card, context)
	        if context.cardarea == G.hand and context.individual and not context.end_of_round then
	            return {
	                h_chips = card.ability.h_chips
            }
        end
    end
}

