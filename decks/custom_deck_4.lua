
SMODS.Back {
    key = 'custom_deck_4',
    pos = { x = 3, y = 0 },
    config = {
        void_chips = 50
    },
    loc_txt = {
        name = 'Void Deck',
        text = {
            [1] = 'Lets you play a Hand with',
            [2] = '0 cards'
        },
    },
    unlocked = true,
    discovered = false,
    no_collection = false,
    atlas = 'CustomDecks',

    apply = function(self, back)
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_void_deck = true
    end
}

local function void_deck_active()
    return G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_void_deck
end

local function ashersba_void_trigger_jokers(context)
    if not (G and G.jokers and G.jokers.cards) then
        return
    end

    for _, joker in ipairs(G.jokers.cards) do
        if joker and joker.calculate_joker then
            local effect = joker:calculate_joker(context)
            if effect and SMODS and SMODS.calculate_effect then
                SMODS.calculate_effect(effect, joker)
            end
        end
    end
end

if G and G.FUNCS and G.FUNCS.can_play and not G.FUNCS.ashersba_void_can_play_wrapped then
    local void_can_play_ref = G.FUNCS.can_play
    G.FUNCS.can_play = function(e)
        if void_deck_active() and G.hand and G.hand.highlighted and #G.hand.highlighted == 0 then
            e.config.colour = G.C.BLUE
            e.config.button = 'ashersba_void_play'
            return
        end
        return void_can_play_ref(e)
    end
    G.FUNCS.ashersba_void_can_play_wrapped = true
end

if G and G.FUNCS and G.FUNCS.play_cards_from_highlighted and not G.FUNCS.ashersba_void_play then
    G.FUNCS.ashersba_void_play = function(e)
        if not void_deck_active() then
            return G.FUNCS.play_cards_from_highlighted(e)
        end

        if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            return G.FUNCS.play_cards_from_highlighted(e)
        end

        if not (G.GAME and G.GAME.current_round) then
            return
        end

        local chips_gained = (G.GAME.selected_back and G.GAME.selected_back.effect
            and G.GAME.selected_back.effect.config and G.GAME.selected_back.effect.config.void_chips) or 50

        G.GAME.current_round.hands_left = math.max(0, (G.GAME.current_round.hands_left or 0) - 1)
        if G.GAME.round_scores and G.GAME.round_scores.hands then
            G.GAME.round_scores.hands.amt = (G.GAME.round_scores.hands.amt or 0) + 1
        end

        G.GAME.chips = (G.GAME.chips or 0) + chips_gained
        if G.GAME.round_scores and G.GAME.round_scores.hand then
            G.GAME.round_scores.hand.amt = chips_gained
        end

        -- Fire "hand played" joker contexts even when no cards are played.
        local void_context_base = {
            cardarea = G.jokers,
            scoring_name = 'High Card',
            scoring_hand = {},
            full_hand = {},
            blueprint = false
        }
        local main_ctx = {}
        for k, v in pairs(void_context_base) do main_ctx[k] = v end
        main_ctx.joker_main = true
        ashersba_void_trigger_jokers(main_ctx)

        local after_ctx = {}
        for k, v in pairs(void_context_base) do after_ctx[k] = v end
        after_ctx.after = true
        ashersba_void_trigger_jokers(after_ctx)

        local blind_target = G.GAME.blind and G.GAME.blind.chips or math.huge
        if G.GAME.chips >= blind_target or G.GAME.current_round.hands_left <= 0 then
            if G.FUNCS.evaluate_round then
                return G.FUNCS.evaluate_round()
            end
            return
        end

        if G.STATE ~= G.STATES.DRAW_TO_HAND then
            G.STATE = G.STATES.DRAW_TO_HAND
            G.STATE_COMPLETE = false
        end
    end
end

