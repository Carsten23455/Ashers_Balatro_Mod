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
    key = 'custom_deck_6',
    pos = { x = 4, y = 0 },
    config = {
        extra = {
            dollars_bonus = 1,
            hand_size_bonus = 2,
            joker_slots = 2
        }
    },
    loc_txt = {
        name = 'Twitch Deck',
        text = {
            [1] = 'Chat has chosen to make this deck',
        },
    },
    unlocked = false,
    discovered = false,
    no_collection = false,
    atlas = 'CustomDecks',
    check_for_unlock = function(self, args)
        return ashersba_deck_has_win('b_ashersba_custom_deck_4', 'b_custom_deck_4')
    end,
    apply = function(self, back)
        G.GAME.starting_params.dollars = (G.GAME.starting_params.dollars or 4) + self.config.extra.dollars_bonus
        G.GAME.starting_params.joker_slots = self.config.extra.joker_slots

        G.E_MANAGER:add_event(Event({
            delay = 0.3,
            func = function()
                if G.hand then
                    G.hand:change_size(self.config.extra.hand_size_bonus)
                end

                if G.consumeables and G.consumeables.config then
                    local starter_consumables = {
                        { set = 'Spectral', key = 'c_soul' },
                        { set = 'Planet', key = 'c_saturn' }
                    }

                    for _, starter in ipairs(starter_consumables) do
                        local free_slots = G.consumeables.config.card_limit - #G.consumeables.cards
                        if free_slots > 0 then
                            SMODS.add_card(starter)
                        end
                    end
                end

                if G.playing_cards then
                    for i = #G.playing_cards, 1, -1 do
                        local card = G.playing_cards[i]
                        if card and card:is_suit('Diamonds') then
                            if card.area and card.area.remove_card then
                                card.area:remove_card(card)
                            end
                            table.remove(G.playing_cards, i)
                            card:remove()
                        end
                    end
                end

                if G.deck and G.deck.config then
                    G.deck.config.card_limit = #G.playing_cards
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end
        }))
    end
}

