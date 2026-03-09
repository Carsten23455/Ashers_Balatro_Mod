
SMODS.Joker{ --Completionist Award
    key = "completionistaward",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Completionist Award',
        ['text'] = {
            [1] = 'Shuffles 2 {C:attention}Gold{} Polychrome {C:attention}Gold{} Seal Face Cards Every Round'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 9
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

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and G and G.P_CARDS and G.deck and G.playing_cards then
            local ranks = { 'J', 'Q', 'K' }
            local suits = { 'S', 'H', 'D', 'C' }

            local function add_face_card(idx)
                local suit = pseudorandom_element(suits, pseudoseed('completionist_suit_' .. tostring(idx)))
                local rank = pseudorandom_element(ranks, pseudoseed('completionist_rank_' .. tostring(idx)))
                local card_front = G.P_CARDS[suit .. rank]
                local base_card = create_playing_card({
                    front = card_front,
                    center = G.P_CENTERS.c_base
                }, G.discard, true, false, nil, true)

                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local new_card = copy_card(base_card, nil, nil, G.playing_card)
                new_card:add_to_deck()
                new_card:set_edition('e_polychrome', true, true)
                new_card:set_seal('Gold', true)
                G.deck.config.card_limit = (G.deck.config.card_limit or #G.playing_cards) + 1
                G.deck:emplace(new_card)
                table.insert(G.playing_cards, new_card)
                base_card:remove()
                SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
            end

            add_face_card(1)
            add_face_card(2)
            if G.deck.shuffle then
                G.deck:shuffle('completionist_award_shuffle')
            end
            return { message = "+2 Face Cards", colour = G.C.GOLD }
        end
    end
}
