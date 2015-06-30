module Slackbotsy

  module Helper

  	def draw
  		if !Game.is_active?
  			return "There is no active game. Start a new game with !start"
  		end

  		game = Game.get_active
  		deck = Json.decode(game.deck)
  		hands = Json.decode(game.hands)
  		turn = game.turn

  		card = deck.pop
  		hands[turn] << card

  		game.deck = deck
  		game.hands = hands
  		if game.save
  			return hands[turn]
  		else
  			return "Error drawing card >.<"
  		end
  	end

  	def play(card)
  		if !Game.is_active?
  			return "There is no active game. Start a new game with !start"
  		end
  	end

  end

end
