
SMODS.Consumable {
    key = 'giveaway',
    set = 'Spectral',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Giveaway',
        text = {
            [1] = 'Create {C:dark_edition}4 Negative{} {C:planet}Planet{} cards',
            [2] = 'and redeem {C:attention}2{} random {C:attention}Vouchers{}'
        }
    },
    cost = 4,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    use = function(self, card, area, copier)
        local used_card = copier or card
        local planets_to_add = 4
        local vouchers_to_redeem = 2

        local function has_room_in_area(target_area)
            if not (target_area and target_area.cards and target_area.config and target_area.config.card_limit) then
                return true
            end
            return #target_area.cards < target_area.config.card_limit
        end

        local function ensure_room_for_negative(target_area, amount)
            if not (target_area and target_area.config and target_area.config.card_limit) then return end
            target_area.config.card_limit = target_area.config.card_limit + (amount or 0)
        end

        local function pick_unique_from_pool(pool, count, seed_tag, predicate)
            local candidates = {}
            for _, v in ipairs(pool or {}) do
                if v and v.key and (not predicate or predicate(v)) then
                    candidates[#candidates + 1] = v
                end
            end

            local chosen = {}
            local chosen_keys = {}
            for i = 1, math.min(count or 0, #candidates) do
                local tries = 0
                while tries < 50 do
                    tries = tries + 1
                    local pick = pseudorandom_element(candidates, pseudoseed((seed_tag or 'giveaway_pick')..'_'..tostring(i)..'_'..tostring(tries)))
                    if pick and not chosen_keys[pick.key] then
                        chosen[#chosen + 1] = pick
                        chosen_keys[pick.key] = true
                        break
                    end
                end
            end
            return chosen
        end

        local function voucher_can_be_redeemed(v)
            if not (v and v.key) then return false end
            if v.unlocked == false or v.available == false then return false end
            if G and G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers[v.key] then return false end
            if v.requires and G and G.GAME and G.GAME.used_vouchers then
                for _, req in ipairs(v.requires) do
                    if not G.GAME.used_vouchers[req] then
                        return false
                    end
                end
            end
            return true
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.6, 0.4)
                return true
            end
        }))

        if G and G.consumeables then
            ensure_room_for_negative(G.consumeables, planets_to_add)

            local planet_pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS.Planet or {}
            for i = 1, planets_to_add do
                local chosen = pseudorandom_element(planet_pool, pseudoseed('giveaway_planet_'..tostring(i)))
                if chosen and chosen.key then
                    local c = SMODS.add_card({ set = 'Planet', area = G.consumeables, key = chosen.key, skip_materialize = true })
                    if c and c.set_edition then
                        c:set_edition('e_negative', true)
                    end
                    if c then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                c:start_materialize()
                                return true
                            end
                        }))
                    end
                end
            end
        end

        if G and G.vouchers then
            G.GAME.used_vouchers = G.GAME.used_vouchers or {}

            local voucher_pool = G.P_CENTER_POOLS and G.P_CENTER_POOLS.Voucher or {}
            local chosen_vouchers = pick_unique_from_pool(voucher_pool, vouchers_to_redeem, 'giveaway_voucher', voucher_can_be_redeemed)
            for i = 1, vouchers_to_redeem do
                local v = chosen_vouchers[i]
                if v and v.key then
                    G.GAME.used_vouchers[v.key] = true
                    local vc = SMODS.add_card({ set = 'Voucher', area = G.vouchers, key = v.key, skip_materialize = true, bypass_discovery_center = true })
                    if vc then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                vc:start_materialize()
                                vc:juice_up(0.4, 0.5)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end,
    can_use = function(self, card)
        return true
    end
}

