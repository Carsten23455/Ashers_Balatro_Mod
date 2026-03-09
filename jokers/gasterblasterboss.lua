
SMODS.Joker{ --GasterBlaster Boss
    key = "gasterblasterboss",
    config = {
        extra = {
            destroy_count = 2
        }
    },
    loc_txt = {
        ['name'] = 'GasterBlaster Boss',
        ['text'] = {
            [1] = 'Destroys 2 random cards each hand played'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 6
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
    sticker = "ashersba_boss_eternal",
    unlocked = true,
    discovered = false,
    no_collection = true,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },
    soul_pos = {
        x = 6,
        y = 6
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' 
            or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_hand and #context.scoring_hand > 0 and not context.blueprint then
            local pool = {}
            for _, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card and not scoring_card.gasterblaster_target then
                    pool[#pool + 1] = scoring_card
                end
            end

            local to_mark = math.min(card.ability.extra.destroy_count or 2, #pool)
            for i = 1, to_mark do
                local pick = pseudorandom_element(pool, pseudoseed('gasterblasterboss_destroy_'..i))
                if pick then
                    pick.should_destroy = true
                    pick.gasterblaster_target = true
                    for j = #pool, 1, -1 do
                        if pool[j] == pick then
                            table.remove(pool, j)
                            break
                        end
                    end
                end
            end

            return {
                message = "Blasted!",
                colour = G.C.RED
            }
        end

        if context.destroy_card and context.destroy_card.should_destroy and context.destroy_card.gasterblaster_target then
            context.destroy_card.gasterblaster_target = nil
            return { remove = true }
        end
    end
}
