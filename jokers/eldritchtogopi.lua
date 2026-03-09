
SMODS.Joker{ --Eldritch Togopi
    key = "eldritchtogopi",
    config = {
        extra = {
            repetitions = 4
        }
    },
    loc_txt = {
        ['name'] = 'Eldritch Togopi',
        ['text'] = {
            [1] = '{C:gold}Lest Incomprehensive be given and more to apprehend{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 5
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
        if context.destroy_card and context.destroy_card.should_destroy  then
            return { remove = true }
        end
        if context.individual and context.cardarea == G.play and context.other_card then
            context.other_card.should_destroy = false
            if SMODS.get_enhancements(context.other_card)["m_wild"] == true then
                context.other_card.should_destroy = true
                return {
                    message = "Destroyed!"
                    ,
                    func = function()
                        local ranks = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'}
                        local suits = {'S', 'H', 'D', 'C'}

                        local function add_random_card_of_suit(suit_prefix, i)
                            local rank_suffix = pseudorandom_element(ranks, pseudoseed('eldritch_rank_'..suit_prefix..'_'..i))
                            local card_front = G.P_CARDS[suit_prefix..rank_suffix]
                            local base_card = create_playing_card({
                                front = card_front,
                                center = G.P_CENTERS.c_base
                            }, G.discard, true, false, nil, true)

                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local new_card = copy_card(base_card, nil, nil, G.playing_card)
                            new_card:add_to_deck()

                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            G.deck:emplace(new_card)
                            table.insert(G.playing_cards, new_card)
                            base_card:remove()

                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    new_card:start_materialize()
                                    return true
                                end
                            }))
                        end

                        for i = 1, 4 do
                            for _, suit_prefix in ipairs(suits) do
                                add_random_card_of_suit(suit_prefix, i)
                            end
                        end
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Added 16 Cards!", colour = G.C.GREEN})
                        return true
                    end
                }
            end
        end
    end
}

