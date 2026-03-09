
SMODS.Enhancement {
    key = 'blueattack',
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            dollars0 = 10
        }
    },
    loc_txt = {
        name = 'BlueAttack',
        text = {
            [1] = 'Description: Unavailable'
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
	        if context.discard and context.other_card == card then
	            return {
	                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars - 10
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-"..tostring(10), colour = G.C.MONEY})
                    return true
                end
            }
        end
    end
}

