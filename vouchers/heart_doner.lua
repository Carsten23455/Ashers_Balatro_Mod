
SMODS.Voucher {
    key = 'heart_doner',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            odds = 4,
            xmult = 2
        }
    },
    loc_txt = {
        name = 'Heart Doner',
        text = {
            [1] = '{C:green}1 in 4{} Chance to {X:red,C:white}X2{} Mult per Hand that contains {C:hearts}Hearts{} Suit'
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

    loc_vars = function(self, info_queue, card)
        local odds = (card and card.ability and card.ability.extra and card.ability.extra.odds)
            or (self.config.extra and self.config.extra.odds)
            or 4
        local xmult = (card and card.ability and card.ability.extra and card.ability.extra.xmult)
            or (self.config.extra and self.config.extra.xmult)
            or 2
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, odds, 'v_ashersba_heart_doner')
        return { vars = { new_numerator, new_denominator, xmult } }
    end,

    calculate = function(self, card, context)
        if not context.joker_main or context.blueprint then
            return
        end

        local played = context.full_hand or context.scoring_hand or {}
        local has_heart = false
        for _, c in ipairs(played) do
            if c and c.is_suit and c:is_suit("Hearts") then
                has_heart = true
                break
            end
        end
        if not has_heart then return end

        local odds = (self.config.extra and self.config.extra.odds) or 4
        local xmult = (self.config.extra and self.config.extra.xmult) or 2
        if SMODS.pseudorandom_probability(card, 'heart_doner_roll', 1, odds, 'v_ashersba_heart_doner', false) then
            return {
                x_mult = xmult
            }
        end
    end,
}

