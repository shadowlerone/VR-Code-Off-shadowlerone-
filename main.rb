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
r = {
	'distances' => /^mm$|^cm$|^m$|^km$|^in$|^ft$|^yd$/i,
	'temperatures' => /^c$|^f$|^k$/,
	'volumes' => /^ml$|^cc$|^l$|^oz$|^qt$|^gal$/i,
	'currencies' => /^aud$|^usd$|^cad$|^yen$|^gbp$|^nzd$/
}

maths_r = /^((\(|\d+\.\d|\d+| [\^*+\-\/] | |\)))+$/i

bot.message do |event|
	# break unless event.channel.id == "572770301948198942" # For the code off'
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
	# convert(_event, value, unit1, to, unit2, fx, r)
	#ic_url = "http://andraelewis.ca/assets/music2.jpg"
	if !(to =~ /to/i)
		event << "Error raised because <@87118368078835712> demands `to` and not `#{to}`. The function would still work :P"
	end
	if (unit1 =~  r['distances']) && (unit1 =~ r['distances'])
		out = convert_d(value.to_f, unit1, unit2)
	elsif (unit1 =~ r['volumes']) && (unit1 =~ r['volumes'])
		out = convert_v(value.to_f, unit1, unit2)
	elsif (unit1 =~ r['temperatures']) && (unit1 =~ r['temperatures'])
		out = convert_temps(value.to_f, unit1, unit2)
	elsif (unit1 =~ r['currencies']) && (unit1 =~ r['currencies'])
		out = convert_currency(value.to_f, unit1, unit2, fx)
		ic_url = "https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/052012/bank-of-canada_blk-converted.png"
		ft_text = "Currency exchange rates gracefully supplied by the Bank of Canada"
	else
		out = "Check your units.\nMy physics teacher keeps telling me that if I have the wrong units, you're garanteed to have the wrong answer.\nYou have the wrong answer.\nCheck your units."
	end
	ft_text ||= 'Lerone Bot - Unit Converter'
	title = "Unit Convertion Unit"
	_event.channel.send_embed do |embed|
		embed.title = title
		embed.description = out
		embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
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

bot.command(:calc) do |event, *code|
	calculate(event, code, maths_r)
end

bot.command(:add_swear) do |event, *code|
	addSwear(code)
	swears_string = gen_swears_string()
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