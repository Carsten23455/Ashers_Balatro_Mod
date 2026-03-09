
SMODS.Joker{ --Lopillar
    key = "lopillar",
    config = {
        extra = {
            Penilty = 2
        }
    },
    loc_txt = {
        ['name'] = 'Lopillar',
        ['text'] = {
            [1] = '{C:red}-2{} Hand Size',
            [2] = 'Reduce penalty by 1 for every Blind skipped.',
            [3] = '(resets per ante)',
            [4] = '[Currently #1#]'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 3
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "ashersba_boss",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    sticker = "ashersba_boss_eternal",
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_Boss_Jokers"] = true },
    soul_pos = {
        x = 4,
        y = 3
    },
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.Penilty}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local sticker = SMODS.Stickers and SMODS.Stickers["ashersba_boss_eternal"]
        if sticker and sticker.apply then
            sticker:apply(card, true)
        elseif card and card.ability then
            card.ability.ashersba_boss_eternal = true
        end
    end,
    calculate = function(self, card, context)
        if context.skip_blind  then
            if to_big((card.ability.extra.Penilty or 0)) > to_big(0) then
                return {
                    func = function()
                        card.ability.extra.Penilty = math.max(0, (card.ability.extra.Penilty) - 1)
                        return true
                    end
                }
            end
        end
        if context.end_of_round and context.main_eval and G.GAME.blind.boss  then
            return {
                func = function()
                    card.ability.extra.Penilty = 2
                    return true
                end
            }
        end
        if context.setting_blind  then
            return {
                
                func = function()
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(card.ability.extra.Penilty).." Hand Limit", colour = G.C.BLUE})
                    
                    G.hand:change_size(-card.ability.extra.Penilty)
                    return true
                end
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval  then
            return {
                
                func = function()
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(card.ability.extra.Penilty).." Hand Limit", colour = G.C.BLUE})
                    
                    G.hand:change_size(card.ability.extra.Penilty)
                    return true
                end
            }
        end
    end
}

