
SMODS.Joker{ --Mosquito Ball
    key = "mosquitoball",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Mosquito Ball',
        ['text'] = {
            [1] = 'Summon 1 Baby Ball If have Room Per hand or discard played. {C:red}-2{} Discard'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 7
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

    add_to_deck = function(self, card, from_debuff)
        if G and G.GAME and G.GAME.round_resets then
            G.GAME.round_resets.discards = math.max(0, (G.GAME.round_resets.discards or 0) - 2)
            if G.GAME.current_round then
                G.GAME.current_round.discards_left = math.max(0, (G.GAME.current_round.discards_left or 0) - 2)
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G and G.GAME and G.GAME.round_resets then
            G.GAME.round_resets.discards = (G.GAME.round_resets.discards or 0) + 2
            if G.GAME.current_round then
                G.GAME.current_round.discards_left = (G.GAME.current_round.discards_left or 0) + 2
            end
        end
    end,

    calculate = function(self, card, context)
        local function summon_babyball()
            local baby_center = G.P_CENTERS.m_ashersba_babyball or G.P_CENTERS.m_babyball
            if not (baby_center and G and G.deck and G.playing_cards) then
                return false
            end
            if #G.playing_cards >= (G.deck.config.card_limit or math.huge) then
                return false
            end

            local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('mosquitoball_baby_front'))
            local base_card = create_playing_card({
                front = card_front,
                center = baby_center
            }, G.discard, true, false, nil, true)

            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local new_card = copy_card(base_card, nil, nil, G.playing_card)
            new_card:add_to_deck()

            G.deck:emplace(new_card)
            table.insert(G.playing_cards, new_card)
            base_card:remove()
            SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
            return true
        end

        if (context.after or context.discard) and not context.blueprint then
            if summon_babyball() then
                return {
                    message = "Baby Ball!",
                    colour = G.C.GREEN
                }
            end
        end
    end
}

