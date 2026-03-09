
SMODS.Joker{ --TriviaVictims
    key = "triviavictims",
    config = {
        extra = {
            question_text = "1 + 1 = ?",
            answer = 2,
            checked_this_hand = false
        }
    },
    loc_txt = {
        ['name'] = 'TriviaVictims',
        ['text'] = {
            [1] = 'A Math Question Pops Up, if first card played equals to the answer.',
            [2] = 'One random card in your hand becomes Polychrome or Foil.',
            [3] = '{C:inactive}#1# {}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 8
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
	        return {vars = {card.ability.extra.question_text or "1 + 1 = ?"}}
	    end,

	        calculate = function(self, card, context)
	            local function roll_question()
	                local use_add = pseudorandom('trivia_op') < 0.5
	                local a, b, answer
	                if use_add then
	                    -- Keep answer in [1..10] for rank matching.
	                    a = math.floor(pseudorandom('trivia_a') * 9) + 1      -- 1..9
	                    b = math.floor(pseudorandom('trivia_b') * (10 - a)) + 1 -- 1..(10-a)
	                    answer = a + b
	                else
	                    -- Always non-negative display and answer in [1..10].
	                    a = math.floor(pseudorandom('trivia_a') * 9) + 2      -- 2..10
	                    b = math.floor(pseudorandom('trivia_b') * (a - 1)) + 1 -- 1..(a-1)
	                    answer = a - b
	                end

	                card.ability.extra.answer = answer
	                card.ability.extra.question_text = use_add and (tostring(a).." + "..tostring(b).." = ?") or (tostring(a).." - "..tostring(b).." = ?")
	            end

            if context.setting_blind and not context.blueprint then
                roll_question()
                card.ability.extra.checked_this_hand = false
            end

            if context.after then
                card.ability.extra.checked_this_hand = false
            end

            if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
                if card.ability.extra.checked_this_hand then
                    return
                end
                card.ability.extra.checked_this_hand = true

                local id = context.other_card:get_id()
                local answer = card.ability.extra.answer or 0
                local matches = (id == answer) or (answer == 1 and id == 14)
                if matches and G and G.hand and G.hand.cards and #G.hand.cards > 0 then
                    local chosen = pseudorandom_element(G.hand.cards, pseudoseed('trivia_target'))
                    local edition_key = (pseudorandom('trivia_edition') < 0.5) and 'e_foil' or 'e_polychrome'
                    chosen:set_edition(edition_key, true, true)
                    return { message = "Correct!", colour = G.C.GREEN }
                end
            end
        end
}

