
SMODS.Joker{ --Leshys Photo
    key = "leshysphoto",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Leshys Photo',
        ['text'] = {
            [1] = 'On Final Hand Played Face cards trigger the joker to the right'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 5
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
            local is_last_hand = G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left <= 1
            if not is_last_hand then
                return
            end

            local has_face_card = false
            local played_cards = context.full_hand or context.scoring_hand or {}
            for _, played_card in ipairs(played_cards) do
                if played_card:is_face() then
                    has_face_card = true
                    break
                end
            end
            if not has_face_card then
                return
            end

            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            local target_joker = nil
            if my_pos and my_pos < #G.jokers.cards then
                target_joker = G.jokers.cards[my_pos + 1]
            end
            
            if target_joker and target_joker ~= card and target_joker.calculate_joker then
                local triggered_effect = target_joker:calculate_joker(context)
                if triggered_effect then
                    SMODS.calculate_effect(triggered_effect, target_joker)
                end
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Triggered!", colour = G.C.BLUE})
            end
        end
    end
}


