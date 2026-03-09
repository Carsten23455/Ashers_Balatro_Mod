
SMODS.Joker{ --Rainbow Suit
    key = "rainbowsuit",
    config = {
        extra = {
            mult0 = 0
        }
    },
    loc_txt = {
        ['name'] = 'Rainbow Suit',
        ['text'] = {
            [1] = 'Hands Having 3 Different Suits will not Score'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
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
        y = 4
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'rif' 
            or args.source == 'jud' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
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
        if context.cardarea == G.jokers and context.joker_main then
            local scoring_hand = context.scoring_hand or {}
            local suits = {}

            for _, playing_card in pairs(scoring_hand) do
                if playing_card:is_suit("Spades") then suits.Spades = true end
                if playing_card:is_suit("Hearts") then suits.Hearts = true end
                if playing_card:is_suit("Diamonds") then suits.Diamonds = true end
                if playing_card:is_suit("Clubs") then suits.Clubs = true end
            end

            local suit_count = 0
            for _ in pairs(suits) do
                suit_count = suit_count + 1
            end

            if suit_count == 3 then
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
}

