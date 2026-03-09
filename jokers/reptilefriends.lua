
SMODS.Joker{ --Reptile Friends
    key = "reptilefriends",
    config = {
        extra = {
            card_draw0 = 3,
            card_draw = 3
        }
    },
    loc_txt = {
        ['name'] = 'Reptile Friends',
        ['text'] = {
            [1] = 'Always Draw 3 Cards on Hand Played/Discarded'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 3,
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
        x = 4,
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
            if G.hand and #G.hand.cards > 0 then
                SMODS.draw_cards(3)
            end
            return {
                message = "+"..tostring(3).." Cards Drawn"
            }
        end
        if context.pre_discard  then
            if G.hand and #G.hand.cards > 0 then
                SMODS.draw_cards(3)
            end
            return {
                message = "+"..tostring(3).." Cards Drawn"
            }
        end
    end
}

