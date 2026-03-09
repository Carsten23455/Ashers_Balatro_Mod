
SMODS.Enhancement {
    key = 'whitebonesattack',
    pos = { x = 2, y = 0 },
    config = {
        bonus = -10
    },
    loc_txt = {
        name = 'WhiteBonesAttack',
        text = {
            [1] = '-10 Chips when played'
        }
    },
    atlas = 'CustomEnhancements',
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
	    always_scores = true,
	    unlocked = true,
	    discovered = false,
	    no_collection = true,
	    weight = 0,
	    in_pool = function(self, args)
	        return false
	    end,
	    calculate = function(self, card, context)
	        if context.individual and context.cardarea == G.play and context.other_card == card then
	            return {
	                chips = card.ability.bonus
            }
        end
    end
}

