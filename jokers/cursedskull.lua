
SMODS.Joker{ --Cursed Skull
    key = "cursedskull",
    config = {
        extra = {
            odds = 4,
            joker_slots0 = 1,
            ante_value0 = 2
        }
    },
    loc_txt = {
        ['name'] = 'Cursed Skull',
        ['text'] = {
            [1] = '{C:purple}Death Awaits{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 0
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
    
    loc_vars = function(self, info_queue, card)
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_ashersba_cursedskull')
        local new_numerator2, new_denominator2 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds2, 'j_ashersba_cursedskull')
        local new_numerator3, new_denominator3 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds3, 'j_ashersba_cursedskull')
        local new_numerator4, new_denominator4 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds4, 'j_ashersba_cursedskull')
        return {vars = {new_numerator, new_denominator, new_numerator2, new_denominator2, new_numerator3, new_denominator3, new_numerator4, new_denominator4}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_111d7a06', 1, card.ability.extra.odds, 'j_ashersba_cursedskull', false) then
                    SMODS.calculate_effect({func = function()
                        
                        for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.4,
                                func = function()
                                    play_sound('timpani')
                                    SMODS.add_card({ set = 'Tarot', key = 'c_death'})                            
                                    card:juice_up(0.3, 0.5)
                                    return true
                                end
                            }))
                        end
                        delay(0.6)
                        
                        if created_consumable then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                        end
                        return true
                    end}, card)
                    SMODS.calculate_effect({func = function()
                        local target_joker = card
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Bye Bye!!!", colour = G.C.RED})
                        end
                        return true
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_1_3152baa9', 1, card.ability.extra.odds, 'j_ashersba_cursedskull', false) then
                    SMODS.calculate_effect({func = function()
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_joker = nil
                        if my_pos and my_pos < #G.jokers.cards then
                            local joker = G.jokers.cards[my_pos + 1]
                            if true and not joker.getting_sliced then
                                target_joker = joker
                            end
                        end
                        
                        if target_joker then
                            if target_joker.ability.eternal then
                                target_joker.ability.eternal = nil
                            end
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
                    end}, card)
                    SMODS.calculate_effect({func = function()
                        
                        local created_joker = false
                        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                            created_joker = true
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_mr_bones' })
                                    if joker_card then
                                        
                                        
                                    end
                                    G.GAME.joker_buffer = 0
                                    return true
                                end
                            }))
                        end
                        if created_joker then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                        end
                        return true
                    end}, card)
                    SMODS.calculate_effect({func = function()
                        local target_joker = card
                        
                        if target_joker then
                            if target_joker.ability.eternal then
                                target_joker.ability.eternal = nil
                            end
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Bye Bye!!!", colour = G.C.RED})
                        end
                        return true
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_2_0c4b1e70', 1, card.ability.extra.odds, 'j_ashersba_cursedskull', false) then
                    SMODS.calculate_effect({func = function()
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Joker Slots set to "..tostring(1), colour = G.C.BLUE})
                        G.jokers.config.card_limit = 1
                        return true
                    end}, card)
                    SMODS.calculate_effect({
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
                        end}, card)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Ante -" .. 2, colour = G.C.YELLOW})
                        SMODS.calculate_effect({func = function()
                            local target_joker = card
                            
                            if target_joker then
                                if target_joker.ability.eternal then
                                    target_joker.ability.eternal = nil
                                end
                                target_joker.getting_sliced = true
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        target_joker:explode({G.C.RED}, nil, 1.6)
                                        return true
                                    end
                                }))
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Bye Bye!!", colour = G.C.RED})
                            end
                            return true
                        end}, card)
                    end
                    -- Probablity 4 (FakeCrash)
                    if SMODS.pseudorandom_probability(card, 'group_3_35ee7c5d', 1, card.ability.extra.odds, 'j_ashersba_cursedskull', false) then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                local atlas = G.ASSET_ATLAS["ashersba_Crash_Atlas"]
                                if atlas then
                                    local crash_sprite = Sprite(0, 0, 30, 15, atlas, {x=0, y=0})
                                    crash_sprite.states.visible = true
                                    crash_sprite.role.draw_major = crash_sprite

                                    G.FUNCS.overlay_menu{
                                        definition = {
                                            n = G.UIT.ROOT,
                                            config = {align = "cm", colour = G.C.CLEAR},
                                            nodes = {
                                                {
                                                    n = G.UIT.C,
                                                    config = {align = "cm", padding = 0, float = true},
                                                    nodes = {
                                                        {n = G.UIT.O, config = {object = crash_sprite}}
                                                    }
                                                }
                                            }
                                        },
                                        config = {type = 'cm', align = 'cm', offset = {x=3.5, y=0}, major = G.ROOM_ATTACH}
                                    }
                                end
                            return true
                        end
                    }))
                end
            end
        end
    end
}

