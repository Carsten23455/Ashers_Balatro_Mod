
SMODS.Enhancement {
    key = 'babyball',
    pos = { x = 6, y = 0 },
    loc_txt = {
        name = 'Baby Ball',
        text = {
            [1] = 'Upgrades High Card on hand played and destroys itself'
        }
    },
    atlas = 'CustomEnhancements',
    any_suit = false,
    replace_base_card = true,
    no_rank = false,
    no_suit = false,
    always_scores = false,
    unlocked = true,
    discovered = false,
    no_collection = false,
    weight = 0,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card == card then
            if G and G.GAME and G.GAME.hands and G.GAME.hands['High Card'] then
                G.GAME.hands['High Card'].level = (G.GAME.hands['High Card'].level or 1) + 1
            end
            card.should_destroy = true
            return {
                message = 'High Card +1',
                colour = G.C.ATTENTION
            }
        end
    end
}

