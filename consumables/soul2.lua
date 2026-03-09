
SMODS.Consumable {
    key = 'soul2',
    set = 'Spectral',
    pos = { x = 6, y = 0 },
    loc_txt = {
        name = 'Soul',
        text = {
            [1] = 'Creates a',
            [2] = '{C:legendary}Legendary{} Joker',
            [3] = '{C:inactive}(Must have room){}'
        }
    },
    cost = 3,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    no_collection = true,
    atlas = 'CustomConsumables',
    soul_pos = {
        x = 7,
        y = 0
    },
    use = function(self, card, area, copier)
        local used_card = copier or card
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound("ashersba_eramlaugh")
                
                return true
            end,
        }))
    end,
    can_use = function(self, card)
        return true
    end
}
