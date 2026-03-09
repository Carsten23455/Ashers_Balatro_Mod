
SMODS.Enhancement{
    key = 'cursed',
    pos = { x = 1, y = 0 },
    config = {
        h_chips = 0
    },
    loc_txt = {
        name = 'Cursed',
        text = {
            [1] = 'Zero Chips',
            [2] = 'When destroyed, creates a copy'
        }
    },
    atlas = 'CustomEnhancements',
    any_suit = false,
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
	    always_scores = false,
	    unlocked = true,
	    discovered = false,
	    no_collection = false,
	    weight = 0,
	    in_pool = function(self, args)
	        return false
	    end,
	    calculate = function(self, card, context)
	        local function add_cursed_clone()
	            local cursed_center = G.P_CENTERS.m_ashersba_cursed or G.P_CENTERS.m_cursed
	            if not cursed_center then
	                return false
	            end
	            local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('cursed_clone_front'))
	            local base_card = create_playing_card({
	                front = card_front,
	                center = cursed_center
	            }, G.discard, true, false, nil, true)
	
	            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
	            local new_card = copy_card(base_card, nil, nil, G.playing_card)
	            new_card:add_to_deck()
	            G.deck.config.card_limit = (G.deck.config.card_limit or #G.playing_cards) + 1
	            G.deck:emplace(new_card)
	            table.insert(G.playing_cards, new_card)
	            base_card:remove()
	
	            G.E_MANAGER:add_event(Event({
	                func = function()
	                    new_card:start_materialize()
	                    return true
	                end
	            }))
	            SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
	            return true
	        end

	        if context.individual and context.cardarea == G.play and context.other_card == card then
	            return {
	                chips = 0
            }
        end

	        if context.discard and context.other_card == card then
	            if add_cursed_clone() then
	                return {
	                    message = 'Curse Spreads!',
	                    colour = G.C.RED
	                }
	            end
	        end
	
	        if context.remove_playing_cards and context.removed and #context.removed > 0 then
	            if not (G.P_CENTERS.m_ashersba_cursed or G.P_CENTERS.m_cursed) then
	                return
	            end

            local destroyed_cursed = 0
            for _, removed_card in ipairs(context.removed) do
                local center = removed_card and removed_card.config and removed_card.config.center
                if center and (center.key == 'm_ashersba_cursed' or center.key == 'm_cursed') then
                    destroyed_cursed = destroyed_cursed + 1
                end
            end

	            if destroyed_cursed > 0 then
	                for i = 1, destroyed_cursed do
	                    add_cursed_clone()
	                end

                return {
                    message = 'Curse Spreads!',
                    colour = G.C.RED
                }
            end
        end
    end
}

