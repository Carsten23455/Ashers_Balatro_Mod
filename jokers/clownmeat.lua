
SMODS.Joker{ --Clown Meat
    key = "clownmeat",
    config = {
        extra = {
            CardsPlayed = 0,
            dollars0 = 29
        }
    },
    loc_txt = {
        ['name'] = 'Clown Meat',
        ['text'] = {
            [1] = '{C:attention} 29${} per {C:blue}100g{}',
            [2] = '{C:inactive}Currently #1#g/100g{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
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
    pools = { ["ashersba_steamkey_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.CardsPlayed}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            card.ability.extra.CardsPlayed = (card.ability.extra.CardsPlayed) + 1
        end
        if context.after and context.cardarea == G.jokers  then
            if to_big((card.ability.extra.CardsPlayed or 0)) >= to_big(100) then
                return {
                    
                    func = function()
                        
                        local current_dollars = G.GAME.dollars
                        local target_dollars = G.GAME.dollars + 29
                        local dollar_value = target_dollars - current_dollars
                        ease_dollars(dollar_value)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(29), colour = G.C.MONEY})
                        return true
                    end,
                    extra = {
                        func = function()
                            card.ability.extra.CardsPlayed = 0
                            return true
                        end,
                        colour = G.C.BLUE
                    }
                }
            end
        end
    end
}

