
SMODS.Joker{ --Amethist wall
    key = "amethistwall",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Amethist wall',
        ['text'] = {
            [1] = 'adds 25% more to the score needed for the rest of the run'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 2
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
    atlas = 'CustomJokers',
    pools = { ["ashersba_Boss_Jokers"] = true },
    soul_pos = {
        x = 6,
        y = 2
    },
    in_pool = function(self, args)
        return (
            not args 
            or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' and args.source ~= 'rif' 
            or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
        )
        and true
    end,
    
        add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            -- This directly multiplies the score requirement for all future blinds
            G.GAME.starting_params.ante_scaling = (G.GAME.starting_params.ante_scaling or 1) * 1.25
            
            if G.LEVEL and G.LEVEL.current_blind then
                G.LEVEL.current_blind:set_blind(G.LEVEL.current_blind.config.blind)
            end

            attention_text({
                text = 'Blinds +25%',
                scale = 0.8, 
                hold = 1.2,
                major = card,
                backdrop_colour = G.C.RED,
                align = 'cm',
            })
        end
    end,
    
    remove_from_deck = function(self, card, from_debuff)
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local sticker = SMODS.Stickers and SMODS.Stickers["ashersba_boss_eternal"]
        if sticker and sticker.apply then
            sticker:apply(card, true)
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            return {
                message = "Blinds +25%",
                colour = G.C.RED
            }
        end
    end,
}

