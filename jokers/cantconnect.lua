
SMODS.Joker{ --Cant Connect
    key = "cantconnect",
    config = {
        extra = {
            odds = 8,
            odds2 = 6,
            odds2 = 8,
            odds22 = 6,
            odds3 = 8,
            odds23 = 6
        }
    },
    loc_txt = {
        ['name'] = 'Cant Connect',
        ['text'] = {
            [1] = '1 in 8 Chance to connect {C:attention}Jokers{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
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
        
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'j_ashersba_cantconnect')
        local new_numerator2, new_denominator2 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds2, 'j_ashersba_cantconnect')
        local new_numerator3, new_denominator3 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds3, 'j_ashersba_cantconnect')
        local new_numerator4, new_denominator4 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds4, 'j_ashersba_cantconnect')
        local new_numerator5, new_denominator5 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds5, 'j_ashersba_cantconnect')
        local new_numerator6, new_denominator6 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds6, 'j_ashersba_cantconnect')
        local new_numerator7, new_denominator7 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds7, 'j_ashersba_cantconnect')
        local new_numerator8, new_denominator8 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds8, 'j_ashersba_cantconnect')
        local new_numerator9, new_denominator9 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds9, 'j_ashersba_cantconnect')
        local new_numerator10, new_denominator10 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds10, 'j_ashersba_cantconnect')
        local new_numerator11, new_denominator11 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds11, 'j_ashersba_cantconnect')
        local new_numerator12, new_denominator12 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds12, 'j_ashersba_cantconnect')
        return {vars = {new_numerator, new_denominator, new_numerator2, new_denominator2, new_numerator3, new_denominator3, new_numerator4, new_denominator4, new_numerator5, new_denominator5, new_numerator6, new_denominator6, new_numerator7, new_denominator7, new_numerator8, new_denominator8, new_numerator9, new_denominator9, new_numerator10, new_denominator10, new_numerator11, new_denominator11, new_numerator12, new_denominator12}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind  then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_1d0aad49', 1, card.ability.extra.odds, 'j_ashersba_cantconnect', false) then
                    SMODS.calculate_effect({func = function()
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
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_1_b4696d25', 1, card.ability.extra.odds, 'j_ashersba_cantconnect', false) then
                    SMODS.calculate_effect({func = function()
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_joker = (my_pos and my_pos < #G.jokers.cards) and G.jokers.cards[my_pos + 1] or nil
                        
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
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_2_82e5cc8b', 1, card.ability.extra.odds2, 'j_ashersba_cantconnect', false) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("ashersba_Disconnect")
                            
                            return true
                        end,
                    }))
                    SMODS.calculate_effect({func = function()
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_joker = nil
                        if my_pos and my_pos > 1 then
                            local joker = G.jokers.cards[my_pos - 1]
                            if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                                target_joker = joker
                            end
                        end
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Disconnected!", colour = G.C.RED})
                        end
                        return true
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_3_90c3160b', 1, card.ability.extra.odds2, 'j_ashersba_cantconnect', false) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("ashersba_Disconnect")
                            
                            return true
                        end,
                    }))
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
                            if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                                target_joker = joker
                            end
                        end
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Disconnected!", colour = G.C.RED})
                        end
                        return true
                    end}, card)
                end
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_06075e56', 1, card.ability.extra.odds, 'j_ashersba_cantconnect', false) then
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
                    
                end
                if SMODS.pseudorandom_probability(card, 'group_1_cd6f9272', 1, card.ability.extra.odds, 'j_ashersba_cantconnect', false) then
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then
                            my_pos = i
                            break
                        end
                    end
                    local target_joker = (my_pos and my_pos < #G.jokers.cards) and G.jokers.cards[my_pos + 1] or nil
                    
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
                    
                end
                if SMODS.pseudorandom_probability(card, 'group_2_1337f0fb', 1, card.ability.extra.odds2, 'j_ashersba_cantconnect', false) then
                    local my_pos = nil
                    for i = 1, #G.jokers.cards do
                        if G.jokers.cards[i] == card then
                            my_pos = i
                            break
                        end
                    end
                    local target_joker = nil
                    if my_pos and my_pos > 1 then
                        local joker = G.jokers.cards[my_pos - 1]
                        if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                            target_joker = joker
                        end
                    end
                    
                    if target_joker then
                        target_joker.getting_sliced = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                target_joker:explode({G.C.RED}, nil, 1.6)
                                return true
                            end
                        }))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Disconnected!", colour = G.C.RED})
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("ashersba_Disconnect")
                            
                            return true
                        end,
                    }))
                    
                end
                if SMODS.pseudorandom_probability(card, 'group_3_2123d3d3', 1, card.ability.extra.odds2, 'j_ashersba_cantconnect', false) then
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
                        if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                            target_joker = joker
                        end
                    end
                    
                    if target_joker then
                        target_joker.getting_sliced = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                target_joker:explode({G.C.RED}, nil, 1.6)
                                return true
                            end
                        }))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Disconnected!", colour = G.C.RED})
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("ashersba_Disconnect")
                            
                            return true
                        end,
                    }))
                    
                end
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval  then
            if true then
                if SMODS.pseudorandom_probability(card, 'group_0_9d30f24f', 1, card.ability.extra.odds, 'j_ashersba_cantconnect', false) then
                    SMODS.calculate_effect({func = function()
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
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_1_f15305ef', 1, card.ability.extra.odds, 'j_ashersba_cantconnect', false) then
                    SMODS.calculate_effect({func = function()
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_joker = (my_pos and my_pos < #G.jokers.cards) and G.jokers.cards[my_pos + 1] or nil
                        
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
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_2_235a665e', 1, card.ability.extra.odds2, 'j_ashersba_cantconnect', false) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("ashersba_Disconnect")
                            
                            return true
                        end,
                    }))
                    SMODS.calculate_effect({func = function()
                        local my_pos = nil
                        for i = 1, #G.jokers.cards do
                            if G.jokers.cards[i] == card then
                                my_pos = i
                                break
                            end
                        end
                        local target_joker = nil
                        if my_pos and my_pos > 1 then
                            local joker = G.jokers.cards[my_pos - 1]
                            if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                                target_joker = joker
                            end
                        end
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Disconnected!", colour = G.C.RED})
                        end
                        return true
                    end}, card)
                end
                if SMODS.pseudorandom_probability(card, 'group_3_cdf9cd36', 1, card.ability.extra.odds2, 'j_ashersba_cantconnect', false) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound("ashersba_Disconnect")
                            
                            return true
                        end,
                    }))
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
                            if not SMODS.is_eternal(joker) and not joker.getting_sliced then
                                target_joker = joker
                            end
                        end
                        
                        if target_joker then
                            target_joker.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    target_joker:explode({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Disconnected!", colour = G.C.RED})
                        end
                        return true
                    end}, card)
                end
            end
        end
    end
}

