
SMODS.Voucher {
    key = 'occult_club',
    pos = { x = 1, y = 1 },
    config = {
        extra = {
            mult_per_club = 20
        }
    },
    loc_txt = {
        name = 'Occult Club',
        text = {
            [1] = '{C:red}+20{} Mult Per {C:clubs}Club{} Suit scored'
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

        local scoring = context.scoring_hand or context.full_hand or {}
        local clubs_scored = 0
        for _, c in ipairs(scoring) do
            if c and c.is_suit and c:is_suit("Clubs") then
                clubs_scored = clubs_scored + 1
            end
        end

        if clubs_scored > 0 then
            local per = (self.config.extra and self.config.extra.mult_per_club) or 20
            return { mult = per * clubs_scored }
        end
    end,
}

