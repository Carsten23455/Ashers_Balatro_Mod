SMODS.DeckSkin {
    key = "SpadeSkin",
    suit = "Spades",
    palettes = {
        -- Low Contrast Palette (Row 0)
        {
            key = 'lc',
            ranks = {'King', 'Queen', 'Jack'},
            display_ranks = {'King', 'Queen', 'Jack'},
            atlas = "ashersba_CustomCardTheme",
            pos_style = 'collab',
        },
        -- High Contrast Palette (Row 1)
        {
            key = 'hc',
            ranks = {'King', 'Queen', 'Jack'},
            display_ranks = {'Jack', 'Queen', 'King'},
            atlas = "ashersba_CustomCardTheme",
            pos_style = {
                fallback_style = 'collab',
                Jack = {x = 0, y = 1},
                Queen = {x = 1, y = 1},
                King = {x = 2, y = 1}
            }
        }
    }
}
