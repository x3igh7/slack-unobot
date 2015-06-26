require 'sinatra'
require 'slackbotsy'
require 'sinatra/activerecord'
require './config/environments'

## our working dir
dirname = File.dirname(File.expand_path(__FILE__))

## load helper functions
Dir.glob(File.join(dirname, 'helpers', '**')).each do |helper|
  require helper
end

## configure with environment variables
config = %w[channel name incoming_webhook outgoing_token].inject({}) do |hash, var|
  hash[var] = ENV[var.upcase]
  hash
end

bot = Slackbotsy::Bot.new(config)

## load all configs in this dir
bot.eval_scripts(Dir[File.join(dirname, 'scripts', '**', '*.rb')])

## receive from slack
post '/' do
  bot.handle_item(params)
end

class User < ActiveRecord::Base
	validates :slack_id, :name, presence: true
end

class Game < ActiveRecord::Base
	validates :turn, :status, presence: true

	def self.active_game?
		games = Game.where("status != ?", 3)
		if games.count > 0
			return true
		end

		return false
	end

	def self.get_active
		return Game.where("status = ?", 2)
	end

	def get_status
		case self.status
		when 1
			return "Waiting for players."
		when 2
			return "Game in progress."
		when 3
			return "Game is finished."
		end
	end

end
