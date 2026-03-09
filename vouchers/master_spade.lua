
SMODS.Voucher {
    key = 'master_spade',
    pos = { x = 0, y = 1 },
    config = {
        extra = {
            chips = 180
        }
    },
    loc_txt = {
        name = 'Master Spade',
        text = {
            [1] = '{C:blue}+180{} Chips per Hand containing a {C:spades}Spade{}'
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
            if c and c.is_suit and c:is_suit("Spades") then
                return {
                    chips = (self.config.extra and self.config.extra.chips) or 180
                }
            end
        end
    end,
}

