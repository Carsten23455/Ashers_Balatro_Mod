
SMODS.Joker{ --Asher Ball
    key = "asherball",
    config = {
        extra = {
            chips0 = 10
        }
    },
    loc_txt = {
        ['name'] = 'Asher Ball',
        ['text'] = {
            [1] = 'Activates only on {C:attention}Straight Flush{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["ashersba_ashersba_jokers"] = true },
    soul_pos = {
        x = 4,
        y = 1
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
        if context.joker_main and context.scoring_name == 'Straight Flush' then
            local loops = pseudorandom('bloop_loops', 2, 5)
            
            for i = 1, loops do
                local r_chips = pseudorandom('bloop_chips'..i, 10, 100)
                local r_mult  = pseudorandom('bloop_mult'..i, 1, 20)
                local r_xmult = pseudorandom('bloop_xmult'..i, 1, 3)
                local r_money = pseudorandom('bloop_money'..i, 2, 5)

                SMODS.calculate_effect({
                    message = '!bloop',
                    chips = r_chips,
                    mult = r_mult,
                    Xmult = r_xmult,
                    dollars = r_money,
                    colour = G.C.BLACK,
                    card = card
                }, card)
            end
            
            return {
                message = 'Wrapped Up!',
                colour = G.C.BLACK
            }
        end
    end
}

