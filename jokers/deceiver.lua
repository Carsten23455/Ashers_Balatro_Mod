
SMODS.Joker{ --Deceiver
    key = "deceiver",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Deceiver',
        ['text'] = {
            [1] = '{C:red}+4{} Mult?'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
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
        if context.setting_blind and G and G.GAME and G.GAME.blind and G.GAME.blind.boss then
            if G.GAME.blind.disabled ~= nil then
                G.GAME.blind:disable()
                return { message = localize('ph_boss_disabled'), colour = G.C.GREEN }
            end
        end

        if context.cardarea == G.jokers and context.joker_main then
            if G and G.GAME and G.GAME.round_resets and (G.GAME.round_resets.ante or 0) >= 8 then
                return { Xmult = 8, mult = 4 }
            end
            return { mult = 4 }
        end
    end
}

