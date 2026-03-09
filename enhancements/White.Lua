SMODS.Enhancement {
    key = 'color_white',
    pos = { x = 4, y = 0 },
    loc_txt = {
        name = 'Teal Curse',
        text = {
            [1] = 'Color Curse'
        }
    },
    atlas = 'MintCurse',
    any_suit = true,
    replace_base_card = false,
    no_rank = false,
    no_suit = false,
    always_scores = true,
    unlocked = true,
    discovered = false,
    no_collection = true,
    weight = 0,
    in_pool = function(self, args)
        return false
    end
}

