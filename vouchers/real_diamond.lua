
SMODS.Voucher {
    key = 'real_diamond',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            dollars = 2
        }
    },
    loc_txt = {
        name = 'Real Diamond',
        text = {
            [1] = '+2$ per Hand that contains a {C:diamonds}Diamond{} Suit'
        },
        unlock = {
            [1] = 'Unlocked by default.'
        }
    },
    cost = 10,
    unlocked = true,
    discovered = false,
    no_collection = false,
    can_repeat_soul = false,
    atlas = 'CustomVouchers',

    calculate = function(self, card, context)
        if not context.joker_main or context.blueprint then
            return
        end

        local played = context.full_hand or context.scoring_hand or {}
        for _, c in ipairs(played) do
            if c and c.is_suit and c:is_suit("Diamonds") then
                local dollars = (self.config.extra and self.config.extra.dollars) or 2
                return {
                    func = function()
                        ease_dollars(dollars)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..tostring(dollars), colour = G.C.MONEY})
                        return true
                    end
                }
            end
        end
    end,
}

