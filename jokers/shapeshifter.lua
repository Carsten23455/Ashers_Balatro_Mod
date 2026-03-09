
SMODS.Joker{ --ShapeShifter
    key = "shapeshifter",
    config = {
        extra = {
            RoundsHeld = 0
        }
    },
    loc_txt = {
        ['name'] = 'ShapeShifter',
        ['text'] = {
            [1] = 'After 3 Rounds, Sell this Joker to copy the Joker to the left of this Joker, removes negative from copy',
            [2] = '[Currently #1#/3]'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "ashersba_impostor",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_steamkey_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.RoundsHeld}}
    end,
    
    calculate = function(self, card, context)
        if context.selling_self  then
            if to_big((card.ability.extra.RoundsHeld or 0)) >= to_big(3) then
                return {
                    func = function()
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_joker = (my_pos and my_pos > 1) and G.jokers.cards[my_pos - 1] or nil
                        
                        if target_joker and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local copied_joker = copy_card(target_joker, nil, nil, nil, target_joker.edition and target_joker.edition.negative)
                                    
                                    copied_joker:add_to_deck()
                                    G.jokers:emplace(copied_joker)
                                    G.GAME.joker_buffer = 0
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex'), colour = G.C.GREEN})
                        end
                        return true
                    end
                }
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval  then
            return {
                func = function()
                    card.ability.extra.RoundsHeld = (card.ability.extra.RoundsHeld) + 1
                    return true
                end
            }
        end
    end
}

