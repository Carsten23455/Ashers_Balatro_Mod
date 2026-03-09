
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
    unlocked = true,
    discovered = false,
    no_collection = false,
    atlas = 'CustomDecks',
    apply = function(self, back)
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_secret_deck = true
        G.GAME.modifiers.ashersba_sus_mode = false
        G.GAME.win_ante = 9
    end
}

