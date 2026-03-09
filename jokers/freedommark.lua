
SMODS.Joker{ --Freedom Mark
    key = "freedommark",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Freedom Mark',
        ['text'] = {
            [1] = 'Face Cards with Seals are Disabled',
            [2] = '{C:spades}Give me your [[Certified Royal Ticket]]{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 7
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "ashersba_boss",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_Boss_Jokers"] = true },
    soul_pos = {
        x = 2,
        y = 7
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' 
            or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,

    set_ability = function(self, card, initial, delay_sprites)
        local sticker = SMODS.Stickers and SMODS.Stickers["ashersba_boss_eternal"]
        if sticker and sticker.apply then
            sticker:apply(card, true)
        elseif card and card.ability then
            card.ability.ashersba_boss_eternal = true
        end
    end,

    calculate = function(self, card, context)
        -- Trigger when the blind is set
        if context.setting_blind then
            local debuffed_any = false
            
            -- 1. Identify and Debuff cards
            for _, v in ipairs(G.playing_cards) do
                if v:is_face() and v.seal then
                    v.debuff = true
                    debuffed_any = true
                end
            end

            -- 2. Play sound ONLY if cards were debuffed (or remove the check if you want it every time)
            if debuffed_any then 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4, -- Slight delay so the visual debuff happens first
                    func = function()
                        play_sound("ashersba_jevil_laugh")
                        return true
                    end,
                }))
            end
        end
    end,

    -- Keep this to ensure any NEW face cards with seals (created mid-round) also get debuffed
    update = function(self, card)
        if G.playing_cards then
            for _, v in ipairs(G.playing_cards) do
                if v:is_face() and v.seal then
                    v.debuff = true
                end
            end
        end
    end
}
