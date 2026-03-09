
SMODS.Joker{ --Oxen Peak
    key = "oxenpeak",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Olie OxenFree',
        ['text'] = {
            [1] = '{C:money}-20${} for every 5 lvls on a Hand Type'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 4
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
        y = 5
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' 
            or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
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
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local penalty = 0
            for _, hand_data in pairs(G.GAME.hands or {}) do
                local lvl = hand_data and hand_data.level or 0
                penalty = penalty + (math.floor(lvl / 5) * 20)
            end

            if penalty > 0 then
                return {
                    func = function()
                        ease_dollars(-penalty)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-"..tostring(penalty), colour = G.C.MONEY})
                        return true
                    end
                }
            end
        end
    end,
}

