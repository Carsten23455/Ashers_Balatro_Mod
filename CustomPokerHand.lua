SMODS.PokerHand {
    key = "Three Pair",
    prefix_config = { key = false },
    mult = 5,
    l_mult = 5,
    chips = 50,
    l_chips = 50,
    visible = true,
    discovered = false, -- <--- ADD THIS to show in collection immediately
    above_hand = "Two Pair", 
    example = {
        { 'S_K', true }, { 'H_K', true },
        { 'S_Q', true }, { 'D_Q', true },
        { 'S_J', true }, { 'C_J', true },
    },
    loc_txt = {
        name = "Three Pair",
        description = {
            [1] = "3 pairs of different",
            [2] = "ranks (requires 6 cards)"
        },
        text = {
            [1] = "3 pairs of different",
            [2] = "ranks (requires 6 cards)"
        }
    },
    evaluate = function(parts)
        local pair_groups = (parts and parts._2) or {}
        local valid_pairs = {}

        for _, pair in ipairs(pair_groups) do
            if type(pair) == "table" and pair[1] and pair[2] then
                valid_pairs[#valid_pairs + 1] = pair
            end
        end

        if #valid_pairs >= 3 then
            local scoring_cards = {
                valid_pairs[1][1], valid_pairs[1][2],
                valid_pairs[2][1], valid_pairs[2][2],
                valid_pairs[3][1], valid_pairs[3][2]
            }
            return {
                scoring_cards
            }
        end
    end,
}

