
SMODS.Joker{ --Meanas Dawn
    key = "meanasdawn",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Meanas Dawn',
        ['text'] = {
            [1] = 'Destroys The Final Hand'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 9,
        y = 8
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },

    calculate = function(self, card, context)
        if context.before and not context.blueprint and G and G.GAME and G.GAME.current_round and (G.GAME.current_round.hands_left or 0) <= 1 then
            for _, playing_card in ipairs(context.full_hand or {}) do
                playing_card.should_destroy = true
            end
            return { message = "Final Hand Burned", colour = G.C.RED }
        end
    end
}
