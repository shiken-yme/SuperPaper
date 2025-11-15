SMODS.Enhancement {
    key = "brainwashed",
    pos = {x = 5, y = 1},
    config = {extra = {odds = 4}},
    loc_txt = {
        name = "Brainwashed",
        text = {
            "Cards generate a random {C:tarot}Tarot{} when scored",
            "{C:inactive}Must have room{}",
            "1 in 4 chance to remove enhancement on scoring"
        }
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator =
            SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "vremade_brainwashed")
        return {vars = {numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if
            context.cardarea == G.play and context.main_scoring and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
         then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(
                Event(
                    {
                        trigger = "before",
                        delay = 0.0,
                        func = function()
                            SMODS.add_card({set = "Tarot"})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }
                )
            )
            card_eval_status_text(card, "extra", nil, nil, nil, {message = "+1 Tarot!", colour = G.C.ORANGE})
            if SMODS.pseudorandom_probability(card, "vremade_brainwashed", 1, card.ability.extra.odds) then
                card:set_ability("c_base", nil, true)
                card_eval_status_text(card, "extra", nil, nil, nil, {message = "Resisted!", colour = G.C.BLACK})
            end
        end
    end
}
