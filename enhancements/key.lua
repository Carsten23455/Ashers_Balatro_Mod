
SMODS.Enhancement {
    key = 'key',
    pos = { x = 0, y = 0 },
    config = {
        h_chips = 50
    },
    loc_txt = {
        name = 'Key',
        text = {
            [1] = '+50 Chips when card is held in hand'
        }
    },
    atlas = 'CustomEnhancements',
    any_suit = true,
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = false,
    unlocked = true,
    discovered = false,
    no_collection = false,
    weight = 5,
    calculate = function(self, card, context)
        local matches_card = (context.other_card == card) or (context.card == card) or (context.other_card == nil)
        if context.individual and context.cardarea == G.hand and matches_card and not context.end_of_round then
            return {
                h_chips = card.ability.h_chips or 50
            }
        end
    end
}

