
SMODS.Joker{ --BuckShot
    key = "buckshot",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'BuckShot',
        ['text'] = {
            [1] = '{C:green}1 in 2{} Chance to get a Hand Otherwise a Discard'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
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
        if context.setting_blind and not context.blueprint and G and G.GAME and G.GAME.current_round and G.GAME.round_resets then
            local give_hand = SMODS.pseudorandom_probability(card, 'buckshot_roll', 1, 2, 'j_ashersba_buckshot', false)
            if give_hand then
                G.GAME.round_resets.hands = (G.GAME.round_resets.hands or 0) + 1
                G.GAME.current_round.hands_left = (G.GAME.current_round.hands_left or 0) + 1
                return { message = "+1 Hand", colour = G.C.BLUE }
            else
                G.GAME.round_resets.discards = (G.GAME.round_resets.discards or 0) + 1
                G.GAME.current_round.discards_left = (G.GAME.current_round.discards_left or 0) + 1
                return { message = "+1 Discard", colour = G.C.RED }
            end
        end
    end
}
