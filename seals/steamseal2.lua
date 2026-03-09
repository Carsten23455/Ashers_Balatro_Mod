
SMODS.Seal {
    key = 'steamseal2',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            chips0 = 700,
            mult0 = 24
        }
    },
    badge_colour = HEX('000000'),
    loc_txt = {
        name = 'SteamSeal',
        label = 'SteamSeal',
        text = {
            [1] = '{C:blue}+700{} Chips',
            [2] = '{C:red}+24{} Mult'
        }
    },
	    atlas = 'CustomSeals',
	    unlocked = true,
	    discovered = false,
	    no_collection = true,
	    in_pool = function(self, args)
	        return false
	    end,
	    calculate = function(self, card, context)
	        if context.individual and context.cardarea == G.play and context.other_card == card then
	            return {
	                chips = 700,
	                mult = 24
	            }
	        end
	    end
	}

