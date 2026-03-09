
SMODS.Joker{ --You Cant Read This
    key = "youcantreadthis",
    config = {
        extra = {
            repetitions = 12
        }
    },
    loc_txt = {
        ['name'] = 'You Cant Read This',
        ['text'] = {
            [1] = 'By Purchasing this card,  the Purchaser hereby irrevocably acknowledges,  agrees,  and',
            [2] = 'consents,  without  reservation  or  limitation,  to  be  mechanically  bound  by  the',
            [3] = 'following  terms,  which  shall  take  immediate,  automatic,  and  permanent  effect:',
            [4] = 'any  Stone  Card  Played  shall  be  irrevocably  Annihilated,  such  Annihilation  constituting',
            [5] = 'a  mandatory,  absolute,  and  non-negotiable  prerequisite  and  cost,  without  which  no',
            [6] = 'benefit  shall  be  conferred,  and  being  undertaken  solely  and  exclusively  to  Facilitate',
            [7] = 'the  Generation  of  one  Random  Lucky  Card  with  the  attributes  and  utility  of  a  Red',
            [8] = 'Seal,  said  Lucky  Card  being  generated  only  as  a  direct  consequence  of  said  Annihilation',
            [9] = 'and  provided  with  the  base  mechanics  of  the  Ace  to  King  Playing  Card  Standard  Deck',
            [10] = 'numerical  range,  wherein  the  designation  Played  shall  be  strictly  limited  to  a Stone Card',
            [11] = 'actively  included  in  the  scoring  portion  of  a  hand  at  the  time  scoring  is  resolved,',
            [12] = 'expressly  excluding  mere  presence  in  hand  or  any  non-scoring  interaction,  with  all  other',
            [13] = 'mechanics,  interactions,  priorities,  and  determinations  not  expressly  defined  herein  being',
            [14] = 'governed  by  the  standard  poker  rules  and  systems  of  Balatro.',
            [15] = 'Any  instance  wherein  the  Purchaser  elects,  whether  by  voluntary  alienation,  transfer,  relinquishment,',
            [16] = 'or  other  operational  manifestation  hereinafter  subsumed  under  the  denomination  \'SELLING\'  or  \'DISCARDING\',',
            [17] = 'as  per  the  intricate  Balatro  mechanics,  shall  inexorably,  immediately,  and  without  possibility  of  mitigation,',
            [18] = 'precipitate  the  creation,  issuance,  and  irrevocable  attribution  of  precisely  twelve  (12)  Stone  Cards',
            [19] = 'the  procurement  and  disposition  of  which  shall  be  construed  as  the  sole,  mandatory,  and  compensatory',
            [20] = 'recompense  demanded  by  the  intrinsic  operational  architecture  of  this  Agreement.'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 3,
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
    
    calculate = function(self, card, context)
        local function add_card_to_deck(card_center, seal_key)
            if not (G and G.deck and G.playing_cards) then
                return nil
            end

            local card_front = pseudorandom_element(G.P_CARDS, pseudoseed('add_card_hand'))
            local base_card = create_playing_card({
                front = card_front,
                center = card_center
            }, G.discard, true, false, nil, true)

            if seal_key then
                base_card:set_seal(seal_key, true)
            end

            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local new_card = copy_card(base_card, nil, nil, G.playing_card)
            new_card:add_to_deck()

            G.deck.config.card_limit = G.deck.config.card_limit + 1
            G.deck:emplace(new_card)
            table.insert(G.playing_cards, new_card)
            base_card:remove()

            G.E_MANAGER:add_event(Event({
                func = function()
                    new_card:start_materialize()
                    return true
                end
            }))

            SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
            return new_card
        end

        if context.remove_playing_cards  then
            if (function()
                for _, removed_card in ipairs(context.removed or {}) do
                    if SMODS.get_enhancements(removed_card)["m_stone"] == true then
                        return true
                    end
                end
                return false
            end)() then
                add_card_to_deck(G.P_CENTERS.m_lucky, "Red")
                return {
                    message = "Added Card!"
                }
            end
        end
        if context.destroy_card and context.destroy_card.should_destroy  then
            return { remove = true }
        end
        if context.individual and context.cardarea == G.play and context.other_card then
            context.other_card.should_destroy = false
            if SMODS.get_enhancements(context.other_card)["m_stone"] == true then
                context.other_card.should_destroy = true
                return {
                    message = "Destroyed!"
                }
            end
        end
        if context.selling_self  then
            if true then
                for i = 1, 12 do
                    add_card_to_deck(G.P_CENTERS.m_steel, nil)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Added Card!", colour = G.C.GREEN})
                end
            end
        end
    end
}


