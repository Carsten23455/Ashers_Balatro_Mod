local function ashersba_sus_mode_active()
    return G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_sus_mode
end

for i = 1, 4 do
    SMODS.Enhancement {
        key = 'deadcurse_' .. tostring(i),
        pos = { x = i - 1, y = 2 },
        loc_txt = {
            name = 'Playing Card',
            text = {}
        },
        atlas = 'GrayCurse',
        any_suit = false,
        replace_base_card = false,
        no_rank = false,
        no_suit = false,
        always_scores = false,
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
                return {
                    chips = 0,
                    mult = 0,
                    message = 'Dead',
                    colour = G.C.RED
                }
            end
            if context.main_scoring and in_scoring_hand then
                return {
                    chips = 0,
                    mult = 0,
                    x_mult = 1,
                    message = 'Dead',
                    colour = G.C.RED
                }
            end
        end
    }
end

