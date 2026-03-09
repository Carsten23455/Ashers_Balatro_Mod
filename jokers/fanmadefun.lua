
SMODS.Joker{ --Fanmade Fun
    key = "fanmadefun",
    config = {
        extra = {
            shop_slots_increase = '1',
            voucher_slots_increase = '1',
            booster_slots_increase = '1',
            reroll_amount = '1',
            hands_change = '1',
            discards_change = '1',
            hand_size_increase = '1',
            play_size_increase = '1',
            discard_size_increase = '1',
            slot_change = '1',
            mult0 = 1,
            chips0 = 1,
            blind_reward0 = 1
        }
    },
    loc_txt = {
        ['name'] = 'Fanmade Fun',
        ['text'] = {
            [1] = '{C:hearts}+{}{C:attention}1{} {C:money}t{}{C:green}o{} {C:common}a{}{C:inactive}l{}{C:default}l{}',
            [2] = '{C:inactive}limited only voucher effects{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true }, 
    
    calc_dollar_bonus = function(card)
        local blind_reward = 0
        blind_reward = blind_reward + math.max(1, 0)
        if blind_reward > 0 then
            return blind_reward
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
        end
        if context.cardarea == G.jokers and context.joker_main  then
            return {
                mult = 1,
                extra = {
                    chips = 1,
                    colour = G.C.CHIPS
                }
            }
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        change_shop_size(1)
        SMODS.change_voucher_limit(1)
        SMODS.change_booster_limit(1)
        SMODS.change_free_rerolls(1)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
        G.hand:change_size(1)
        SMODS.change_play_limit(1)
        SMODS.change_discard_limit(1)
        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            return true
        end }))
        G.jokers.config.highlighted_limit =G.jokers.config.highlighted_limit + 1
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) +1
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        change_shop_size(-1)
        SMODS.change_voucher_limit(-1)
        SMODS.change_booster_limit(-1)
        SMODS.change_free_rerolls(-(1))
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
        G.hand:change_size(-1)
        SMODS.change_play_limit(-1)
        SMODS.change_discard_limit(-1)
        G.jokers.config.card_limit = G.jokers.config.card_limit - 1
        G.E_MANAGER:add_event(Event({func = function()
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - 1
            return true
        end }))
        G.jokers.config.highlighted_limit =G.jokers.config.highlighted_limit - 1
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) -1
    end
}

