module Slackbotsy

  module Helper

    def create_new_game
    	if !Game.active_game?
    		game = Game.create(status: 1, turn: 1)
    		return game.get_status
    	else
   			return "Game already created. Type !join or wait for it to finish."
   		end
    end

    def add_player(slack_id)
    	user = User.find(:first, :conditions => ['slack_id = ?', slack_id])
    	game = Game.get_active

    	if game.players < 1
    		players = [user.id]
    	else
				players = JSON.parse(game.players)[0]
				players.each do |p|
					if p == user.id
						return "#{user.name} already joined the game!"
					end
				end

    		players.push(user.id)
    	end

    	players = JSON.generate(players)
    	game.players = players
    	game.save
    	return "Player #{user.user} added to the game!"
    rescue ActiveRecord::RecordNotFound
    	return "No user found. Please !register first."
    end

    def generate_deck
    	freshdeck = "{1: r0, 2: r1, 3: r2, 4: r3, 5: r4, 6: r5, 7: r6, 8: r7, 9: r8, 10: r9, 11: rS, 12: rR, 13: rD2, 14: rW, 15: y0, 16: y1, 17: y2, 18: y3, 19: y4, 20: y5, 21: y6, 22: y7, 23: y8, 24: y9, 25: yS, 26: yR, 27: yD2, 28: yW, 29: g0, 30: g1, 31: g2, 32: g3, 33: g4, 34: g5, 35: g6, 36: g7, 37: g8, 38: g9, 39: gS, 40: gR, 41: gD2, 42: gW, 43: b0, 44: b1, 45: b2, 46: b3, 47: b4, 48: b5, 49: b6, 50: b7, 51: b8, 52: b9, 53: bS, 54: bR, 55: bD2, 56: bW, 58: r1, 59: r2, 60: r3, 61: r4, 62: r5, 63: r6, 64: r7, 65: r8, 66: r9, 67: rS, 68: rR, 69: rD2, 70: rW4, 72: y1, 73: y2, 74: y3, 75: y4, 76: y5, 77: y6, 78: y7, 79: y8, 80: y9, 81: yS, 82: yR, 83: yD2, 84: yW4, 86: g1, 87: g2, 88: g3, 89: g4, 90: g5, 91: g6, 92: g7, 93: g8, 94: g9, 95: gS, 96: gR, 97: gD2, 98: gW4, 100: b1, 101: b2, 102: b3, 103: b4, 104: b5, 105: b6, 106: b7, 107: b8, 108: b9, 109: bS, 110: bR, 111: bD2, 112: bW4 }"
    	game = Game.get_active
    	game.deck = freshdeck
    	game.save
    end

  end

end
