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

  		# if you draw a card, you have to play it if possible.
  		result = determine_play(card, game.discard, hands[turn])
  		if !result
  			game.turn = next_turn(game)
  			if game.save
  				return "The top card is: #{game.discard}"
  			else
  				return "Error progressing game >.<"
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
	  	discard = game.discard
	  	determine_play(card, discard, hand)
  	end

  	private

  	def determine_play
  		if hand.include?(card)
	  		if is_same_color(card, discard)
	  			play_normal_or_special_card(card, game)
	  			hand.delete(card)
	  		elsif discard.length == 1 && !is_same_number(card, discard)
	  			return false
	  		elsif is_same_number(card, discard)
	  			play_normal_or_special_card(card, game)
	  			hand.delete(card)
	  		elsif is_wild(card)
	  			play_wild_card(game)
	  			hand.delete(card)
	  		elsif is_wild_draw_four(card)
	  			play_wild_draw_four(game)
	  			hand.delete(card)
	  		else
	  			return false
	  		end
	  	end
	  end

	  def play_normal_or_special_card(card)
	  	if(card.slice(1) == "S")
	  		skip_turn(game)
	  	elsif (card.slice(1) == "D")
	  		draw_two(game)
	  	elsif (card.slice(1) == "R")
	  		reverse(game)
	  	else
	  		normal_play(game)
	  	end
	  end

	  def skip_turn(game)
	  	skipped_player = next_turn(game)
	  	game.turn = skipped_player
	  	next_player = next_turn(game)
	  	game.turn = next_player

	  	game.save
	  end

  	def is_same_color(card, discard)
  		card.slice(0) == discard.slice(0)
  	end

  	def is_same_number(card, discard)
  		card.slice(1..2) == discard.slice(1..2)
  	end

  	def is_wild(card)
  		card.slice(0) == "W"
  	end

  	def is_wild_draw_four(card)
  		card.slice(0..1) == "W4"
  	end

  	def next_turn(game)
  		turn = game.turn
  		next_player = turn + 1
  		if(next_player >= game.hands.length)
  			next_player = 0
  		end

  		return next_player
  	end

  end

end
