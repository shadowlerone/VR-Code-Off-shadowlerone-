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
	# whatsHotTick(event)
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
	
end

bot.command(:eval, help_available: false) do |event, *code|
	break unless event.user.id == 196290553141264384 # Replace number with your ID
	begin
		eval code.join(' ')
	rescue StandardError
		'An error occurred 😞'
	end
end

bot.command(:calc, description: "I do math.", usage: "Just dump a valid string of math code in here and I'll try to work it out.") do |event, *code|
	calculate(event, code, maths_r)
end

bot.command(:add_swear, description: "I add words to the swear list!") do |event, *code|
	data1 = JSON.parse(File.read("swears.json"))
	data1['swears'].concat code
	file = File.open("swears.json", "w")
	file.puts(JSON.generate(data1))
	file.close()
	event.channel.send_embed do |embed|
		embed.title = 'Swear Removal Service'
		embed.description = "We appreciate your concern. We have added `#{code.join('`, `')}` to our list of watch words.\nPlease reload the swear list manually with `reload_swears`."
		ft_text = 'Lerone Bot - Language Police'
		ic_url = "https://cdn.shopify.com/s/files/1/1151/9112/products/image_199487ac-517a-4fbd-a1c4-2853f3de975c_large.png"
		embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
	end
	# swears_string, randoms = gen_swears_string()
end

bot.command :reload_swears, description: "I reload the swear list!" do |event|
	swears_string, randoms = gen_swears_string()
	event.channel.send_embed do |embed|
		embed.title = 'Swear Removal Service'
		embed.description = "We appreciate your concern. We have reloaded the swear list."
		ft_text = 'Lerone Bot - Language Police'
		ic_url = "https://cdn.shopify.com/s/files/1/1151/9112/products/image_199487ac-517a-4fbd-a1c4-2853f3de975c_large.png"
		embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
	end
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