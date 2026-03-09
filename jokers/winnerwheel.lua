
SMODS.Joker{ --Winner Wheel
    key = "winnerwheel",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Winner Wheel',
        ['text'] = {
            [1] = 'Disables a random card for that blind'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
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
        x = 2,
        y = 3
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
        if context.first_hand_drawn and not context.blueprint then
            local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'}
            local random_index = math.floor(pseudorandom('winner_wheel') * 13) + 1
            local random_rank = ranks[random_index]
        
            card.ability.extra = card.ability.extra or {}
            card.ability.extra.last_debuffed = random_rank
        
            for _, v in ipairs(G.playing_cards) do
                -- Reset your custom flag ONLY
                if v.ability.winner_wheel_debuff then
                    v.ability.winner_wheel_debuff = nil
                end

                -- Safe comparison using tostring() to match number cards with strings
                if tostring(v.base.value) == random_rank then
                    v.ability.winner_wheel_debuff = true
                    -- Force a visual update immediately
                    v:set_debuff(true)
                else
                    -- If we removed the flag, let the game recalculate its state (fix visuals)
                    if v.debuff then 
                        G.GAME.blind:debuff_card(v)
                    end
                end
            end

            return {
                message = 'Debuffed ' .. random_rank .. 's!',
                colour = G.C.RED
            }
        end
    end
}

