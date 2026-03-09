
SMODS.Joker{ --Tetos Tounge
	    key = "tetostounge",
	    config = {
	        extra = {
	            odds = 4,
	            _teto_last_hand_id = nil,
	            _teto_destroy_this_hand = false
	        }
	    },
	    loc_txt = {
	        ['name'] = 'Tetos Tounge',
	        ['text'] = {
	            [1] = 'Repeat Hand Type has a 1 in 4 chance to destroy Hand Played'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 6
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "ashersba_boss",
	    blueprint_compat = true,
	    eternal_compat = true,
	    perishable_compat = true,
        sticker = "ashersba_boss_eternal",
	    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_Boss_Jokers"] = true },
    soul_pos = {
        x = 0,
        y = 7
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' 
            or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_ashersba_tetostounge') 
        return {vars = {new_numerator, new_denominator}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local sticker = SMODS.Stickers and SMODS.Stickers["ashersba_boss_eternal"]
        if sticker and sticker.apply then
            sticker:apply(card, true)
        elseif card and card.ability then
            card.ability.ashersba_boss_eternal = true
        end
    end,
    calculate = function(self, card, context)
		        local function ensure_roll_for_current_hand()
		            local hand_id = (G and G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played) or 0
		            if card.ability.extra._teto_last_hand_id ~= hand_id then
		                card.ability.extra._teto_last_hand_id = hand_id
		                card.ability.extra._teto_destroy_this_hand = SMODS.pseudorandom_probability(
		                    card,
		                    'tetostounge_destroy_roll',
		                    1,
		                    card.ability.extra.odds or 4,
		                    'j_ashersba_tetostounge',
		                    false
		                ) and true or false
		            end
		        end

		        if (context.before and context.scoring_hand and not context.blueprint) then
		            ensure_roll_for_current_hand()
		        end
	
		        if context.repetition and context.cardarea == G.play and context.other_card and not context.blueprint then
		            ensure_roll_for_current_hand()
		            if card.ability.extra._teto_destroy_this_hand then
		                context.other_card.should_destroy = true
		                context.other_card.tetostounge_target = true
		            end
		        end

	        if context.destroy_card and context.destroy_card.should_destroy and context.destroy_card.tetostounge_target then
	            context.destroy_card.tetostounge_target = nil
	            return { remove = true }
	        end
	    end
	}

