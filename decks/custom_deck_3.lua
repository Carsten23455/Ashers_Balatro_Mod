local function ashersba_deck_has_win(...)
    if not get_deck_win_stake then
        return false
    end

    for _, deck_key in ipairs({ ... }) do
        local win_stake = get_deck_win_stake(deck_key)
        if type(win_stake) == 'number' and win_stake > 0 then
            return true
        end
    end

    return false
end

SMODS.Back {
    key = 'custom_deck_3',
    pos = { x = 2, y = 0 },
    config = {
        blind_mult = 0.5,
        stinky_odds = 4
    },
    loc_txt = {
        name = 'Stinky Deck',
        text = {
            "Deck and Jokers are {C:green}Rotten{}",
            "-50% Blind Requirements"
        },
    },
    unlocked = false,
    atlas = 'CustomDecks',
    check_for_unlock = function(self, args)
        return ashersba_deck_has_win('b_ashersba_custom_deck_2', 'b_custom_deck_2')
    end,

    apply = function(self)
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_stinky_deck = true
        G.GAME.ashersba_stinky_round_counter = 0

        G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * self.config.blind_mult

        if G.LEVEL and G.LEVEL.current_blind then
            G.LEVEL.current_blind:set_blind(G.LEVEL.current_blind.config.blind)
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                local curse = G.P_CENTERS['m_ashersba_stinkycurse'] or G.P_CENTERS['m_stinkycurse']
                if not curse then
                    return true
                end

                for _, card in ipairs(G.playing_cards) do
                    local id = card:get_id()
                    if id >= 11 and id <= 13 then
                        card:set_ability(curse)
                    end
                end
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.repetition then
            G.GAME.ashersba_stinky_round_counter = (G.GAME.ashersba_stinky_round_counter or 0) + 1
            if (G.GAME.ashersba_stinky_round_counter % 2) ~= 0 then
                return
            end

            local curse = G.P_CENTERS['m_ashersba_stinkycurse'] or G.P_CENTERS['m_stinkycurse']
            if not curse or not (G and G.playing_cards) then
                return
            end

            local candidates = {}
            for _, playing_card in ipairs(G.playing_cards) do
                local center = playing_card and playing_card.config and playing_card.config.center
                local already_stinky = center and (center.key == 'm_ashersba_stinkycurse' or center.key == 'm_stinkycurse')
                if not already_stinky then
                    candidates[#candidates + 1] = playing_card
                end
            end

            if #candidates > 0 then
                local chosen = pseudorandom_element(candidates, pseudoseed('stinky_round_card'))
                if chosen then
                    chosen:set_ability(curse, nil, true)
                    return { message = 'Stinky!' }
                end
            end
        end
    end
}
