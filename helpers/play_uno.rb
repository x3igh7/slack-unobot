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

	  	game = Game.get_active
	  	deck = Json.decode(game.deck)
	  	hands = Json.decode(game.hands)
	  	turn = game.turn

	  	hand = hands[turn]
	  	if hand.include?(card)
	  		color = card.slice(0)
	  		number = card.slice(1..2)

	  		if is_same_color
	  			hand.delete(card)
	  		elsif is_same_number
	  			hand.delete(card)
	  		elsif is_wild
	  			hand.delete(card)
	  		elsif is_wild_draw_four

	  	end
  	end

  	def is_same_color(color, discard)
  		color == game.discard.slice(0)
  	end

  	def is_same_number(number, discard)
  		number == game.discard.slice(1..2)
  	end

  	def is_wild(number)
  		number.slice(0) == "W"
  	end

  	def is_wild_draw_four
  		number.slice(0..1) == "W4"
  	end


  end

end
