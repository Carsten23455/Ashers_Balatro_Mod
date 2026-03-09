
SMODS.Joker{ --Sneko
    key = "sneko",
    config = {
        extra = {
            odds = 3
        }
    },
    loc_txt = {
        ['name'] = 'Sneko',
        ['text'] = {
            [1] = '1 in 3 chance to overwrite',
            [2] = 'played hand to a different hand type'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 3
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
        x = 0,
        y = 4
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
        if context.cardarea == G.jokers and context.joker_main and context.scoring_name then
            if SMODS.pseudorandom_probability(card, 'sneko_two_pair_override', 1, card.ability.extra.odds, 'j_ashersba_sneko', false) then
                local current_hand = context.scoring_name
                local target_hands = {}
                for hand_name, hand_data in pairs(G.GAME.hands or {}) do
                    if hand_name ~= current_hand and hand_data and hand_data.visible then
                        target_hands[#target_hands + 1] = hand_name
                    end
                end

                if #target_hands > 0 then
                    local new_hand = pseudorandom_element(target_hands, pseudoseed('sneko_new_hand'))
                    local original = G.GAME.hands[current_hand] or {}
                    local replacement = G.GAME.hands[new_hand] or {}

                    return {
                        message = 'Sneko: ' .. localize(new_hand, 'poker_hands') .. '!',
                        colour = G.C.ORANGE,
                        chips = (replacement.chips or 0) - (original.chips or 0),
                        mult = (replacement.mult or 0) - (original.mult or 0)
                    }
                end
            end
        end
    end
}

