
SMODS.Consumable {
    key = 'Stinky',
    set = 'Spectral',
    pos = { x = 3, y = 0 },
    loc_txt = {
        name = 'Stinky',
        text = {
            [1] = 'No Effect?'
        }
    },
    cost = 3,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    can_use = function(self, card)
        return true
    end
}
