function SMODS.post_update()
    if G.STATE == G.STATES.MAIN_MENU and G.TITLE_CARD then
        local custom_key = 'j_ashersba_fanmadefun'
        

        if G.TITLE_CARD.config.center_key ~= custom_key then

            if G.P_CENTERS[custom_key] then
                G.TITLE_CARD:set_ability(G.P_CENTERS[custom_key])
                G.TITLE_CARD:set_sprites(G.P_CENTERS[custom_key])
            end
        end
    end 
end
