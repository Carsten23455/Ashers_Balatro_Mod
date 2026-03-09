
SMODS.Joker{ --Darkners House
    key = "darknershouse",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Darkners House',
        ['text'] = {
            [1] = 'First Card Drawn Face Down'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 1,
        y = 5
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
        y = 5
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
            G.E_MANAGER:add_event(Event({
                func = function()
                    local first_card = G.hand.cards and G.hand.cards[1] or nil
                    if first_card then
                        first_card.facing = 'back'
                        first_card.sprite_facing = 'back'
                        card.ability.extra.flipped_card = first_card
                        return true
                    end
                    return true
                end
            }))
            return {
                message = "Face Down",
                colour = G.C.RED
            }
        end

        if context.end_of_round and not context.repetition and not context.blueprint then
            local flipped = card.ability.extra and card.ability.extra.flipped_card
            if flipped and flipped.set then
                flipped.facing = 'front'
                flipped.sprite_facing = 'front'
            end
            if card.ability.extra then
                card.ability.extra.flipped_card = nil
            end
        end
    end
}

