SMODS.Sticker({
    key = "boss_eternal",
    badge_colour = G.C.BLACK,
    atlas = "CustomStickers",
    pos = { x = 2, y = 2 },
    sets = { Joker = true },
    default_compat = true,
    prevent_debuff = true,
    no_sell = true,
    loc_txt = {
        name = "Bound",
        label = "Bound",
        text = { "Cannot be Sold, Destroyed or Debuffed" }
    },
    apply = function(self, card, val)
        card.ability[self.key] = val
  
        card.keep_on_destruction = function(card_self)
            return true
        end
	    end,
	})

local ashersba_bound_sell_ref = Card.sell_card
function Card:sell_card(...)
    local is_bound = self
        and self.ability
        and (
            self.ability.ashersba_boss_eternal
            or self.ability.boss_eternal
            or self.ability.eternal
        )

    if is_bound then
        if card_eval_status_text then
            card_eval_status_text(self, 'extra', nil, nil, nil, {
                message = "Bound",
                colour = G.C.RED
            })
        end
        return nil
    end

    return ashersba_bound_sell_ref(self, ...)
end
