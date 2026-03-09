
SMODS.Joker{ --The Arsonist
    key = "thearsonist",
    config = {
        extra = {
            hands0 = 1,
            discards0 = 5,
            mult0 = 50
        }
    },
    loc_txt = {
        ['name'] = 'The Arsonist',
        ['text'] = {
            [1] = 'When boss blind is selected',
            [2] = 'Disable boss effect',
            [3] = 'Set {C:blue}Hands{} to {C:blue}1{}',
            [4] = '{C:attention}+5{} Discards',
            [5] = '{C:red}+50{} Mult',
            [6] = 'When boss is defeated',
            [7] = 'Destroys self'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
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
    pools = { ["ashersba_ashersba_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.setting_blind  then
            if G.GAME.blind.boss then
                return {
                    func = function()
                        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.blind:disable()
                                    play_sound('timpani')
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled'), colour = G.C.GREEN})
                        end
                        return true
                    end,
                    extra = {
                        
                        func = function()
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Set to "..tostring(1).." Hands", colour = G.C.BLUE})
                            G.GAME.current_round.hands_left = 1
                            return true
                        end,
                        colour = G.C.GREEN,
                        extra = {
                            
                            func = function()
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(5).." Discards", colour = G.C.GREEN})
                                
                                G.GAME.round_resets.discards = G.GAME.round_resets.discards + 5
                                ease_discard(5)
                                
                                return true
                            end,
                            colour = G.C.GREEN
                        }
                    }
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                mult = 50
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval  then
            if G.GAME.blind.boss then
                return {
                    func = function()
                        local target_joker = card
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Destroyed!", colour = G.C.RED})
                        end
                        return true
                    end
                }
            end
        end
    end
}

