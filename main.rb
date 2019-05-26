# frozen_string_literal: true

# This bot has various commands that show off CommandBot.
require './botlerone'
require 'discordrb'
require 'json'
require './bot_start'
require 'ohai'
require 'os'
require 'httparty'


# Here we instantiate a `CommandBot` instead of a regular `Bot`, which has the functionality to add commands using the
# `command` method. We have to set a `prefix` here, which will be the character that triggers command execution.
#bot = BotLerone.new
bot = Discordrb::Commands::CommandBot.new token: get_token, prefix: 's>'
swears_string = ""
randoms = []
fx = {}

#regex for units
distances = /mm|cm|m|km|in|ft|yd/i
volumes = /ml|cc|l|oz|qt|gal/i
temperatures = //


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

bot.command :sysinfo do |event|
	"So I don't actually work, but here's the best I've got...\n```#{get_sysinfo}```"
end

bot.command(:from, min_args:4, max_args: 4, description: "Converts units and currencies", usage: "from <value> <unit> to <unit>") do |_event, value, unit1, to, unit2|
	if !(to =~ /to/i)
		return "Error Raised because Zap demands it. the function would still work :P"
	end
	if (unit1 =~  distances && unit1 =~ distances)
		convert_d(value.to_f, unit1, unit2)
	elsif (unit1 =~ volumes) && (unit1 =~ volumes)
		convert_v(value.to_f, unit1, unit2)
	elsif (unit1 =~ temperatures) && (unit1 =~ temperatures)
		convert_temps(value.to_f, unit1, unit2)
	elsif (unit1 =~ currencies) && (unit1 =~ currencies)
		convert_currency(value.to_f, unit1, unit2, fx)
	else
		return "Sorry, but your unit is not valid."
	end
end

bot.command(:eval, help_available: false) do |event, *code|
	break unless event.user.id == 196290553141264384 # Replace number with your ID
	begin
		eval code.join(' ')
	rescue StandardError
		'An error occurred 😞'
	end
end

bot.command :reload_swears, description: "I reload the swear list!" do |event|
	swears_string = gen_swears_string()
	event << "Swears reloaded!"
end

bot.command(:random, min_args: 0, max_args: 2, description: 'Dunno why I\'m here...', usage: 'I\' probably get commented out soon...') do |_event, min, max|
	"I shouldn't exist..."
end

bot.ready do |event|
	puts "Ready!"
	bot.game = "Victory Road Code Off - Fighting with shadowlerone"
	# bot.send_message "572770301948198942", "Hi <@196290553141264384>! I'm ready to roll."
	swears_string, randoms = gen_swears_string()
	fx = get_exchange_rate()
end

startup(bot)