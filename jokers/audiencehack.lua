
SMODS.Joker{ --Audience Hack
    key = "audiencehack",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Audience Hack',
        ['text'] = {
            [1] = 'adds {C:red}+1{} to {C:red}+8{} Mult to all jokers and has a {C:green}1 in 8{} Chance to add {X:red,C:white}X8{} Mult and Destroys it self'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 8,
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
        card.ability.extra = card.ability.extra or {}

        if context.cardarea == G.jokers and context.joker_main then
            local rolled = pseudorandom('audiencehack_mult_roll')
            local random_mult = math.floor(rolled * 8) + 1
            card.ability.extra._audiencehack_mult = random_mult

            local jackpot = SMODS.pseudorandom_probability(
                card,
                'audiencehack_x8',
                1,
                8,
                'j_ashersba_audiencehack',
                false
            )
            card.ability.extra._audiencehack_x8 = jackpot and true or false

            if jackpot then
                card.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end
            return
        end

        if context.other_joker and context.other_joker ~= card then
            local out_mult = card.ability.extra._audiencehack_mult
            if not out_mult then
                return
            end
            if card.ability.extra._audiencehack_x8 then
                return {
                    mult = out_mult,
                    Xmult = 8,
                    message = "X8!",
                    colour = G.C.RED
                }
            end
            return { mult = out_mult }
        end

        if context.after then
            card.ability.extra._audiencehack_mult = nil
            card.ability.extra._audiencehack_x8 = nil
        end
    end
}

