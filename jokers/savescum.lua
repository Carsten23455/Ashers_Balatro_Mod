
SMODS.Joker{ --Save Scum
    key = "savescum",
    config = {
        extra = {
            joker_slots0 = 1,
            ante_value0 = 2
        }
    },
    loc_txt = {
        ['name'] = 'Save Scum',
        ['text'] = {
            [1] = 'Prevents Death',
            [2] = '{C:red}-2{} Antes',
            [3] = 'Sets Joker Slots to 1'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and context.main_eval  then
            return {
                func = function()
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Joker Slots set to "..tostring(1), colour = G.C.BLUE})
                    G.jokers.config.card_limit = 1
                    return true
                end,
                extra = {
                    saved = true,
                    message = "LOAD SAVE",
                    colour = G.C.RED,
                    extra = {
                        
                        func = function()
                            
                            local mod = -2
                            ease_ante(mod)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + mod
                                    return true
                                end,
                            }))
                            return true
                        end,
                        message = "Ante -" .. 2,
                        colour = G.C.YELLOW
                    }
                }
            }
        end
    end
}

