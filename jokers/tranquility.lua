
SMODS.Joker{ --Tranquility
    key = "tranquility",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Tranquility',
        ['text'] = {
            [1] = 'Creates 1 Sigil {C:spectral}Spectral{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
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
        if context.setting_blind and not context.blueprint then
            if G and G.consumeables and G.consumeables.config and G.consumeables.cards then
                local free = (G.consumeables.config.card_limit or 0) - #G.consumeables.cards
                if free > 0 then
                    SMODS.add_card({ set = 'Spectral', key = 'c_sigil' })
                    return { message = "+Sigil", colour = G.C.SECONDARY_SET.Spectral }
                end
            end
        end
    end
}
