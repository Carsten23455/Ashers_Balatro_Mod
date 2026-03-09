SMODS.Enhancement {
    key = 'stinkycurse',
    pos = { x = 5, y = 0 },
    config = {},
    loc_txt = {
        name = 'Stinky Curse',
        text = {
            'When played, applies to entire scoring hand',
            'Halves base Chips {C:inactive}(odd ranks round up){}'
        }
    },
    atlas = 'CustomEnhancements',
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if not context.main_scoring then
            return
        end

        local scoring_cards = context.scoring_hand or context.full_hand or {}
        if #scoring_cards == 0 then
            return
        end

        local stinky_center = G.P_CENTERS.m_ashersba_stinkycurse or G.P_CENTERS.m_stinkycurse
        if not stinky_center then
            return
        end

        local function is_stinky(playing_card)
            local center = playing_card and playing_card.config and playing_card.config.center
            return center and (center.key == 'm_ashersba_stinkycurse' or center.key == 'm_stinkycurse')
        end

        local first_stinky = nil
        for _, scored_card in ipairs(scoring_cards) do
            if is_stinky(scored_card) then
                first_stinky = scored_card
                break
            end
        end

        if not first_stinky or first_stinky ~= card then
            return
        end

        for _, scored_card in ipairs(scoring_cards) do
            if scored_card ~= card and not is_stinky(scored_card) then
                scored_card:set_ability(stinky_center, nil, true)
            end
        end

        local total_reduction = 0
        for _, scored_card in ipairs(scoring_cards) do
            local rank_id = scored_card:get_id()
            local base = 0

            if rank_id >= 2 and rank_id <= 10 then
                base = rank_id
            elseif rank_id >= 11 and rank_id <= 13 then
                base = 10
            elseif rank_id == 14 then
                base = 11
            end

            if base > 0 then
                total_reduction = total_reduction + math.floor(base / 2)
            end
        end

        if total_reduction > 0 then
            return {
                chips = -total_reduction,
                message = 'Stinky!'
            }
        end
    end
}
