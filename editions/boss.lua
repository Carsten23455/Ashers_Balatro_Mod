SMODS.Edition {
    key = 'boss',
    shader = false,
    in_shop = false,
    apply_to_float = false,
    badge_colour = HEX('940a0a'),
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Bond',
        label = 'Bond',
        text = {
            [1] = '{C:attention}+1{} Joker slot'
        }
    },
    unlocked = true,
    discovered = false,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,

    config = { card_limit = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.edition.card_limit } }
    end,
}
