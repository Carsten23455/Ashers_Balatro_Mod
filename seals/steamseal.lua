
SMODS.Seal {
    key = 'steamseal',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            mult0 = 2
        }
    },
    badge_colour = HEX('DC143C'),
    loc_txt = {
        name = 'SteamSeal',
        label = 'SteamSeal',
        text = {
            [1] = 'if The card with this seal has {C:gold}Key enchantment{}',
            [2] = 'create a Giveaway  card and destroy this card',
            [3] = 'else {C:red}+2 mult{}'
        }
    },
	    atlas = 'CustomSeals',
	    unlocked = true,
	    discovered = false,
	    no_collection = false,
	    in_pool = function(self, args)
	        return false
	    end,
	    sound = { sound = "multhit2", per = 1.2, vol = 0.4 },
	    calculate = function(self, card, context)
	        if context.individual and context.cardarea == G.play and context.other_card == card then
	            local center_key = card
	                and card.config
	                and card.config.center
	                and card.config.center.key
	                or nil
	            local has_key_enchantment = center_key == 'm_ashersba_key'
	
	            if has_key_enchantment then
	                local can_create = G
	                    and G.consumeables
	                    and G.consumeables.cards
	                    and G.consumeables.config
	
	                if not can_create then
	                    return { mult = 2 }
	                end

	                local room = (G.consumeables.config.card_limit or 0) - #G.consumeables.cards
	                if room <= 0 then
	                    return { mult = 2 }
	                end
	
	                return {
	                    func = function()
	                        play_sound('timpani')
	                        SMODS.add_card({ set = 'Spectral', key = 'c_ashersba_giveaway' })
	                        card:juice_up(0.3, 0.5)
	                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = '+Giveaway', colour = G.C.SECONDARY_SET.Spectral })
	                        card:start_dissolve({ G.C.RED }, nil, 1.6)
	                        return true
	                    end
	                }
	            end
	
	            return { mult = 2 }
	        end
	    end
	}

