
SMODS.Joker{ --Lovely Vandel
    key = "lovelyvandel",
    config = {
        extra = {
            hands0 = 1
        }
    },
    loc_txt = {
        ['name'] = 'Lovely Vandel',
        ['text'] = {
            [1] = 'If {C:red}Discarded Hand{} is a {C:hearts}Hearts Flush{} {C:red}+1 Discards{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 0
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
    pools = { ["ashersba_steamkey_jokers"] = true },
    
    calculate = function(self, card, context)
        if context.pre_discard  then
            if (function()
                local allMatchSuit = true
                for i, c in ipairs(context.full_hand) do
                    if not (c:is_suit("Hearts")) then
                        allMatchSuit = false
                        break
                    end
                end
                
                return allMatchSuit and #context.full_hand > 0
            end)() then
                return {
                    
                    func = function()
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Yay yippee!", colour = G.C.GREEN})
                        
                        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                        ease_hands_played(1)
                        
                        return true
                    end
                }
            end
        end
    end
}

