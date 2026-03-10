local function ashersba_deck_has_win(...)
    if not get_deck_win_stake then
        return false
    end

    for _, deck_key in ipairs({ ... }) do
        local win_stake = get_deck_win_stake(deck_key)
        if type(win_stake) == 'number' and win_stake > 0 then
            return true
        end
    end

    return false
end

SMODS.Back {
    key = 'custom_deck_2',
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            membership_rate = 0.25,
            dollars_per_hand = 20,
            base_hands = 0,
            base_discards = 3,
            start_dollars = 80
        }
    },
    loc_txt = {
        name = 'Gilded Deck',
        text = {
            [1] = 'Economy has Changed',
            [2] = '25% Membership Fees'
        },
    },
    unlocked = false,
    discovered = false,
    no_collection = false,
    atlas = 'CustomDecks',
    check_for_unlock = function(self, args)
        return ashersba_deck_has_win('b_ashersba_custom_deck_1', 'b_custom_deck_1')
    end,
    apply = function(self, back)
        G.GAME.modifiers = G.GAME.modifiers or {}
        G.GAME.modifiers.ashersba_gilded_deck = true

        G.GAME.starting_params.dollars = self.config.extra.start_dollars
        G.GAME.dollars = self.config.extra.start_dollars
        G.GAME.interest_cap = 0

        G.GAME.round_resets.hands = self.config.extra.base_hands
        G.GAME.round_resets.discards = self.config.extra.base_discards

        if G.GAME.current_round then
            G.GAME.current_round.hands_left = math.floor((G.GAME.dollars or 0) / self.config.extra.dollars_per_hand)
            G.GAME.current_round.discards_left = self.config.extra.base_discards
            G.GAME.current_round.ashersba_membership_done = false
            G.GAME.current_round.ashersba_gilded_hand_money_removed = false
        end

        G.E_MANAGER:add_event(Event({
            delay = 0.3,
            func = function()
                local cards = {}
                local suits = { 'Spades', 'Hearts', 'Diamonds', 'Clubs' }
                local gold_center = G.P_CENTERS and G.P_CENTERS.m_gold
                for i = 1, #suits do
                    local new_card = SMODS.add_card({
                        set = 'Base',
                        area = G.deck,
                        rank = 'A',
                        suit = suits[i],
                        enhancement = gold_center and gold_center.key or nil
                    })
                    if new_card then
                        cards[#cards + 1] = new_card
                    end
                end

                if #cards > 0 then
                    pcall(function()
                        SMODS.calculate_context({ playing_card_added = true, cards = cards })
                    end)
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end
        }))
    end
}

local function gilded_deck_active()
    return G and G.GAME and G.GAME.modifiers and G.GAME.modifiers.ashersba_gilded_deck
end

local gilded_set_blind_ref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    gilded_set_blind_ref(self, blind, reset, silent)

    if not gilded_deck_active() or not blind or reset or silent then
        return
    end

    G.GAME.interest_cap = 0
    G.GAME.round_resets.hands = 0
    G.GAME.round_resets.discards = 3

    if G.GAME.current_round then
        G.GAME.current_round.ashersba_membership_done = false
        G.GAME.current_round.ashersba_gilded_hand_money_removed = false
        G.GAME.current_round.hands_left = math.floor((G.GAME.dollars or 0) / 20)
        G.GAME.current_round.discards_left = 3
    end
end

local gilded_card_set_cost_ref = Card.set_cost
function Card:set_cost()
    gilded_card_set_cost_ref(self)

    if not gilded_deck_active() then
        return
    end

    if self.ability and (
        self.ability.set == 'Joker'
        or self.ability.set == 'Tarot'
        or self.ability.set == 'Planet'
        or self.ability.set == 'Spectral'
        or self.ability.set == 'Voucher'
        or self.ability.set == 'Booster'
        or self.ability.set == 'Enhanced'
    ) then
        self.cost = 0
        self.sell_cost = math.max(1, math.floor(self.cost / 2)) + (self.ability.extra_value or 0)
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
end

local gilded_add_round_eval_row_ref = add_round_eval_row
function add_round_eval_row(config)
    if G and G.GAME and not G.GAME.round_eval then
        G.GAME.round_eval = { rows = {} }
    elseif G and G.GAME and G.GAME.round_eval and not G.GAME.round_eval.rows then
        G.GAME.round_eval.rows = {}
    end

    if gilded_deck_active() and config and G.GAME and G.GAME.current_round then
        if config.name == 'hands' and not G.GAME.current_round.ashersba_gilded_hand_money_removed then
            local hand_reward = math.max(0, G.GAME.current_round.hands_left or 0)
            if hand_reward > 0 then
                G.GAME.current_round.ashersba_gilded_hand_money_removed = true
                gilded_add_round_eval_row_ref({
                    name = 'custom',
                    text = 'Hands payout removed',
                    number = '-$' .. tostring(hand_reward),
                    number_colour = G.C.RED,
                    text_colour = G.C.UI.TEXT_LIGHT,
                    pitch = (config.pitch or 1)
                })
                ease_dollars(-hand_reward)
            end
        end

        if config.name == 'bottom' and not G.GAME.current_round.ashersba_membership_done then
            local membership_fee = math.floor((G.GAME.dollars or 0) * 0.25)
            if membership_fee > 0 then
                G.GAME.current_round.ashersba_membership_done = true
                gilded_add_round_eval_row_ref({
                    name = 'custom',
                    text = 'Membership fee',
                    number = '-$' .. tostring(membership_fee),
                    number_colour = G.C.RED,
                    text_colour = G.C.UI.TEXT_LIGHT,
                    pitch = (config.pitch or 1)
                })
                ease_dollars(-membership_fee)
            end
        end
    end

    return gilded_add_round_eval_row_ref(config)
end
