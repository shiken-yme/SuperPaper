
SMODS.Seal {
    key = 'chaos',
    loc_txt = {
        name = "Chaos Seal",
        text = {"Played cards remove a random card from deck"}
    },
    pos = { x = 5, y = 4 },
    config = { extra = { mult = 0 } },
    badge_colour = G.C.BLACK,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.before then
          local full_deck = G.deck
          local random_card = pseudorandom_element(G.deck.cards, 'seed')
          if random_card ~= nil then 
            if random_card.seal ~= "chaos" then
              SMODS.destroy_cards(random_card)
                          card_eval_status_text(context.blueprint_card or card, 'extra', nil,
                                  nil, nil,
                                  {message = 'Glomp!', colour = G.C.RED})
            end
          end
        end
    end,
      draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('negative', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
      end
}