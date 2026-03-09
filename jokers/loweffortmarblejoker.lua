
SMODS.Joker{ --Low Effort Marble Joker
    key = "loweffortmarblejoker",
    config = {
        extra = {
            chips = 100,
            growth = 2
        }
    },
    loc_txt = {
        ['name'] = 'Low Effort Marble Joker',
        ['text'] = {
            [1] = 'Played {C:attention}High Card{} gives {C:blue}+#1#{} Chips.',
            [2] = 'After scoring, this amount {C:attention}doubles{}.',
            [3] = '{C:inactive}(Tracked separately){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 6,
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
    pools = { ["ashersba_ashersba_jokers"] = true },

	    loc_vars = function(self, info_queue, card)
	        local giveaway_count = 0
	        if G and G.consumeables and G.consumeables.cards then
	            for _, consumable in ipairs(G.consumeables.cards) do
	                local key = consumable
	                    and consumable.config
	                    and (consumable.config.center_key or (consumable.config.center and consumable.config.center.key))
	                    or nil
	                if key == 'c_ashersba_giveaway' or key == 'c_giveaway' then
	                    giveaway_count = giveaway_count + 1
	                end
	            end
	        end
	        return { vars = { card.ability.extra.chips, giveaway_count } }
	    end,

	    calculate = function(self, card, context)
	        if context.joker_main and context.scoring_name == 'High Card' then
	            return {
	                chips = card.ability.extra.chips,
	                colour = G.C.CHIPS
	            }
	        end

	        if context.after and context.scoring_name == 'High Card' and not context.blueprint then
	            local giveaway_count = 0
	            if G and G.consumeables and G.consumeables.cards then
	                for _, consumable in ipairs(G.consumeables.cards) do
	                    local key = consumable
	                        and consumable.config
	                        and (consumable.config.center_key or (consumable.config.center and consumable.config.center.key))
	                        or nil
	                    if key == 'c_ashersba_giveaway' or key == 'c_giveaway' then
	                        giveaway_count = giveaway_count + 1
	                    end
	                end
	            end

	            local growth = card.ability.extra.growth or 2
	            -- Double only once per Giveaway currently in consumable hand.
	            local multiplier = growth ^ giveaway_count
	            card.ability.extra.chips = math.min(100000, math.floor((card.ability.extra.chips or 0) * multiplier))
	            return {
	                message = giveaway_count > 0 and 'Boosted!' or 'No Giveaway',
	                colour = G.C.ATTENTION
	            }
	        end
	    end
	}
	
	-- foreach Giveaway double the chips capping at 100k

