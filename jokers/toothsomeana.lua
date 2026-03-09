
SMODS.Joker{ --ToothsoMeana
    key = "toothsomeana",
    config = {
        extra = {
            dollars0 = 1
        }
    },
    loc_txt = {
        ['name'] = 'ToothsoMeana',
        ['text'] = {
            [1] = '{C:red}-1{}$ per hand played'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 1
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
        x = 0,
        y = 2
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' 
            or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
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
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                
                func = function()
                    
                    local current_dollars = G.GAME.dollars
                    local target_dollars = G.GAME.dollars - 1
                    local dollar_value = target_dollars - current_dollars
                    ease_dollars(dollar_value)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(1), colour = G.C.MONEY})
                    return true
                end
            }
        end
    end
}

