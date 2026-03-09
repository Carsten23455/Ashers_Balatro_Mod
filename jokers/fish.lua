
SMODS.Joker{ --!fish
    key = "fish",
    config = {
        extra = {
            card_draw0 = 1
        }
    },
    loc_txt = {
        ['name'] = '!fish',
        ['text'] = {
            [1] = 'One Random Card Becomes Face Down'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 5,
        y = 3
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
        y = 3
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
        if context.first_hand_drawn and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local random_card = pseudorandom_element(G.hand.cards, pseudoseed('fish_flip'))
                    if random_card then
                        random_card.facing = 'back'
                        random_card.sprite_facing = 'back'
                        card.ability.extra.flipped_card = random_card
                        
                        attention_text({
                            text = "Flipped!",
                            scale = 1, 
                            hold = 1.2,
                            major = card,
                            backdrop_colour = G.C.SECONDARY_SET.Joker,
                            align = 'cm',
                        })
                    end
                    return true
                end
            }))
        end

        if context.end_of_round and not context.blueprint and not context.repetition then
            if card.ability.extra.flipped_card then
                if card.ability.extra.flipped_card.set then 
                    card.ability.extra.flipped_card.facing = 'front'
                    card.ability.extra.flipped_card.sprite_facing = 'front'
                end
                card.ability.extra.flipped_card = nil 
            end
        end
    end
}

