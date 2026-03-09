
SMODS.Joker{ --Melatonin Deprived
    key = "melatonindeprived",
    config = {
        extra = {
            last_ante_checked = -1
        }
    },
    loc_txt = {
        ['name'] = 'Melatonin Deprived',
        ['text'] = {
            [1] = '{X:red,C:white}X2{} Mult, {C:green}1 in 3{} chance to be Debuffed every other round'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 7
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
        if context.setting_blind and not context.blueprint and G and G.GAME and G.GAME.round_resets then
            local ante = G.GAME.round_resets.ante or 1
            if card.ability.extra.last_ante_checked ~= ante then
                card.ability.extra.last_ante_checked = ante
                local should_roll = (ante % 2 == 0)
                local debuff_now = false
                if should_roll then
                    debuff_now = SMODS.pseudorandom_probability(
                        card,
                        'melatonin_debuff_roll',
                        1,
                        3,
                        'j_ashersba_melatonindeprived',
                        false
                    )
                end
                if card.set_debuff then
                    card:set_debuff(debuff_now)
                else
                    card.debuff = debuff_now
                end
            end
        end

        if context.cardarea == G.jokers and context.joker_main then
            if not card.debuff then
                return { Xmult = 2 }
            end
        end
    end
}

