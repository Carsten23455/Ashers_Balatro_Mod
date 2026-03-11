
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
	        local function count_steel(scoring_hand)
	            local n = 0
	            for _, scoring_card in ipairs(scoring_hand or {}) do
	                local enh = (SMODS.get_enhancements and SMODS.get_enhancements(scoring_card)) or {}
	                if enh["m_steel"] then
	                    n = n + 1
	                end
	            end
	            return n
	        end

	        if context.cardarea == G.jokers and context.joker_main then
	            local steel_count = count_steel(context.scoring_hand)
	            if steel_count > 0 then
	                return { Xmult = 2 ^ steel_count }
	            end
	        end

	        if context.individual and context.cardarea == G.play and context.other_card then
	            -- Only apply the chip multiplier on hands with no steel cards.
	            if context.scoring_hand and count_steel(context.scoring_hand) == 0 then
	                return { x_chips = 2 }
	            end
	        end
	    end
	}
	
