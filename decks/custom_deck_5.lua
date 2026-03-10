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
    key = 'custom_deck_5',
    pos = { x = 5, y = 0 },
    config = {
    },
    loc_txt = {
        name = 'Secret Deck',
        text = {
            [1] = 'Something Happened to Ante 9'
        },
    },
    unlocked = false,
    discovered = false,
    no_collection = false,
    atlas = 'CustomDecks',
    check_for_unlock = function(self, args)
        return ashersba_deck_has_win('b_ashersba_custom_deck_1', 'b_custom_deck_1')
            and ashersba_deck_has_win('b_ashersba_custom_deck_2', 'b_custom_deck_2')
            and ashersba_deck_has_win('b_ashersba_custom_deck_3', 'b_custom_deck_3')
            and ashersba_deck_has_win('b_ashersba_custom_deck_4', 'b_custom_deck_4')
            and ashersba_deck_has_win('b_ashersba_custom_deck_6', 'b_custom_deck_6')
    end,
    apply = function(self, back)
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_secret_deck = true
        G.GAME.modifiers.ashersba_sus_mode = false
        G.GAME.win_ante = 9
    end
}

