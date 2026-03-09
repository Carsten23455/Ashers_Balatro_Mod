
SMODS.Joker{ --Faulty Achivement
    key = "faultyachivement",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Faulty Achivement',
        ['text'] = {
            [1] = 'Joker gains {X:red,C:white}X2{} Mult for every {C:attention}Stone{} like joke Owned,',
            [2] = '{C:green} 1 in 4 {}chance does not trigger and destroys a joker'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
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
        if context.cardarea == G.jokers and context.joker_main then
            local fail = SMODS.pseudorandom_probability(
                card,
                'faulty_fail_roll',
                1,
                4,
                'j_ashersba_faultyachivement',
                false
            )

            if fail and G and G.jokers and G.jokers.cards then
                local pool = {}
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and not v.getting_sliced then
                        pool[#pool + 1] = v
                    end
                end
                if #pool > 0 then
                    local target = pseudorandom_element(pool, pseudoseed('faulty_destroy_target'))
                    target.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end
                    }))
                end
                return { message = "Failed!", colour = G.C.RED }
            end

            local stone_like = {
                j_mystic_summit = true,
                j_marble = true,
                j_obelisk = true,
                j_erosion = true,
                j_stone = true,
                j_ancient = true,
                j_rough_gem = true,
                j_bloodstone = true,
                j_arrowhead = true,
                j_onyx_agate = true
            }

            local count = 0
            for _, v in ipairs((G and G.jokers and G.jokers.cards) or {}) do
                local key = v and v.config and (v.config.center_key or (v.config.center and v.config.center.key))
                if key and stone_like[key] then
                    count = count + 1
                end
            end

            return { Xmult = math.max(1, 2 ^ count) }
        end
    end
}

