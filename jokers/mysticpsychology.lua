
SMODS.Joker{ --Mystic Psychology
    key = "mysticpsychology",
    config = {
        extra = {
            chips0 = 10
        }
    },
    loc_txt = {
        ['name'] = 'Mystic Psychology',
        ['text'] = {
            [1] = 'First Hand wont Score unless it has 5 Cards'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 2
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
    update = function(self, card)
        if not (G and G.GAME and G.jokers and G.jokers.cards and card and card.area == G.jokers) then
            return
        end

        local in_joker_area = false
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                in_joker_area = true
                break
            end
        end

        if in_joker_area and G.jokers.cards[#G.jokers.cards] ~= card then
            if not card.states.drag.is then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.jokers:remove_card(card)
                        G.jokers:emplace(card)
                        return true
                    end
                }))
            end
        end
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
        if context.cardarea == G.jokers and context.joker_main and not context.blueprint then
            if G and G.GAME and G.GAME.current_round and context.full_hand and G.GAME.current_round.hands_played == 0 then
                if #context.full_hand < 5 then
                    
                    for i = 1, #context.full_hand do
                        context.full_hand[i].debuff = true
                    end

                    return {
                        message = 'Nullified!',
                        colour = G.C.RED,

                        chips = to_big(0),
                        mult = to_big(0),
                        mod_chips = to_big(0),
                        mod_mult = to_big(0),

                        x_mult = 0 
                    }
                end
            end
        end
    end
}

