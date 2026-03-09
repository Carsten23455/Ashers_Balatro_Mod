local function ashersba_sus_mode_active()
    return G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_sus_mode
end

local function ashersba_apply_sus_penalty()
    if G and G.GAME then
        G.GAME.chips = -9999999
        if G.GAME.round_scores and G.GAME.round_scores.hand then
            G.GAME.round_scores.hand.amt = -9999999
        end
    end
end

local function ashersba_hidden_curse_center(center)
    if not center or not center.key then
        return false
    end
    local key = string.lower(tostring(center.key))
    return key:find('sus_', 1, true) or key:find('deadcurse_', 1, true)
end

local sus_positions = {
    { x = 0, y = 0 }, { x = 1, y = 0 }, { x = 2, y = 0 }, { x = 3, y = 0 },
    { x = 0, y = 1 }, { x = 1, y = 1 }, { x = 2, y = 1 }, { x = 3, y = 1 }
}

for i = 1, 8 do
    SMODS.Enhancement {
        key = 'sus_' .. tostring(i),
        pos = sus_positions[i],
        loc_txt = {
            name = 'Playing Card',
            text = {}
        },
        atlas = 'GrayCurse',
        any_suit = false,
        replace_base_card = false,
        no_rank = false,
        no_suit = false,
        always_scores = true,
        unlocked = true,
        discovered = false,
        no_collection = true,
        weight = 0,
        in_pool = function(self, args)
            return false
        end,
        calculate = function(self, card, context)
            if not ashersba_sus_mode_active() then
                return
            end

            local in_scoring_hand = false
            if context.scoring_hand and type(context.scoring_hand) == 'table' then
                for _, c in ipairs(context.scoring_hand) do
                    if c == card then
                        in_scoring_hand = true
                        break
                    end
                end
            end

            if context.individual and context.cardarea == G.play and context.other_card == card then
                ashersba_apply_sus_penalty()
                return {
                    chips = -9999999,
                    mult = 1,
                    message = ' ',
                    colour = G.C.RED
                }
            end

            if context.main_scoring and in_scoring_hand then
                ashersba_apply_sus_penalty()
                return {
                    chips = -9999999,
                    mult = 1,
                    message = "Your the Impostor!",
                    colour = G.C.RED
                }
            end

        end
    }
end

