
SMODS.Joker{ --D.O.D.E
    key = "dode",
    config = {
        extra = {
            mult = 0
        }
    },
    loc_txt = {
        ['name'] = 'D.O.D.E',
        ['text'] = {
            [1] = 'Joker gains 25 Mult per sold {C:planet}Planet{} Card'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
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
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult or 0 } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return { mult = card.ability.extra.mult or 0 }
        end
    end
}

local dode_sell_card_ref = Card.sell_card
function Card:sell_card(...)
    local sold_set = self and self.ability and self.ability.set
    local ret = dode_sell_card_ref(self, ...)

    if ret and sold_set == 'Planet' then
        local dodes = SMODS.find_card("j_ashersba_dode")
        for _, dode_card in ipairs(dodes) do
            dode_card.ability.extra.mult = (dode_card.ability.extra.mult or 0) + 25
        end
    end
    return ret
end

