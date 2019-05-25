# frozen_string_literal: true

# This bot has various commands that show off CommandBot.
require './botlerone'
require 'discordrb'
require 'json'
require './bot_start'

# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
#bot = BotLerone.new
bot = Discordrb::Commands::CommandBot.new token: get_token, prefix: '!'
swears_string = ""
randoms = []

bot.message do |event|
	# break unless event.channel.id == "572770301948198942" # For the code off
	# puts event.content
	require './botlerone'
	censor_message(event, swears_string, randoms)
end

bot.message_edit do |event|
	if event.message.edited?
		censor_message event, swears_string,randoms, circ = true
	end
end


bot.command(:invite, chain_usable: false) do |event|
  # This simply sends the bot's invite URL, without any specific permissions,
  # to the channel.
  event.bot.invite_url
end

bot.command :reload_swears do |event|
	swears_string = gen_swears_string()
	event << "Swears reloaded!"
end

bot.command(:random, min_args: 0, max_args: 2, description: 'Generates a random number between 0 and 1, 0 and max or min and max.', usage: 'random [min/max] [max]') do |_event, min, max|
  # The `if` statement returns one of multiple different things based on the condition. Its return value
  # is then returned from the block and sent to the channel
  if max
    rand(min.to_i..max.to_i)
  elsif min
    rand(0..min.to_i)
  else
    rand
  end
end

bot.ready do |event|
	puts "Ready!"
	bot.game = "Victory Road Code Off - Fighting with shadowlerone"
	# bot.send_message "572770301948198942", "Hi <@196290553141264384>! I'm ready to roll."
end
swears_string, randoms = gen_swears_string()
startup(bot)