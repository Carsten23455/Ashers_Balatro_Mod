
SMODS.Joker{ --ClubberPit
    key = "clubberpit",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'ClubberPit',
        ['text'] = {
            [1] = '-1$ per hand played, If hand contains a 3 of a kind and rank above 7 +10$, below 6 -2$ x2mult instead'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
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
        local function get_trips_rank(ctx)
            local cards = ctx.full_hand or ctx.scoring_hand or {}
            if type(cards) ~= 'table' or #cards == 0 then
                return nil
            end
            local rank_counts = {}
            for _, v in ipairs(cards) do
                if v and v.get_id then
                    local id = v:get_id()
                    rank_counts[id] = (rank_counts[id] or 0) + 1
                end
            end
            for id, n in pairs(rank_counts) do
                if n >= 3 then
                    return id
                end
            end
            return nil
        end

        if context.after and not context.blueprint then
            ease_dollars(-1)
            local trips_rank = get_trips_rank(context)
            if trips_rank then
                if trips_rank > 7 then
                    ease_dollars(10)
                    return { message = "+$10", colour = G.C.MONEY }
                elseif trips_rank < 6 then
                    ease_dollars(-2)
                    return { message = "-$2", colour = G.C.RED }
                end
            end
        end

        if context.cardarea == G.jokers and context.joker_main then
            local trips_rank = get_trips_rank(context)
            if trips_rank and trips_rank < 6 then
                return { Xmult = 2 }
            end
        end
    end
}

