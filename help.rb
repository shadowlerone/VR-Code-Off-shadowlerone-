bot.command(bot.attributes[:help_command], max_args: 1, description: 'Shows a list of all the commands available or displays help for a specific command.', usage: 'help [command name]') do |event, command_name|
	
	if command_name
		command = bot.commands[command_name.to_sym]
		if command.is_a?(CommandAlias)
			command = command.aliased_command
			command_name = command.name
		end
		unless command
			event.channel.send_embed do |embed|
				embed.title = "Lerone Bot Helpline"
				embed.description = "The command `#{command_name}` does not exist!"
				ft_text = "We will be with you shortly. Please hold..."
				ic_url = "https://cdn.shopify.com/s/files/1/1151/9112/products/image_199487ac-517a-4fbd-a1c4-2853f3de975c_large.png"
				embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
			end
		end

		desc = command.attributes[:description] || '*No description available*'
		usage = command.attributes[:usage]
		parameters = command.attributes[:parameters]
		result = "**`#{command_name}`**: #{desc}"
		aliases = command_aliases(command_name.to_sym)
		unless aliases.empty?
			result += "\nAliases: "
			result += aliases.map { |a| "`#{a.name}`" }.join(', ')
		end
		result += "\nUsage: `#{usage}`" if usage;
		if parameters
			result += "\nAccepted Parameters:\n```"
			parameters.each { |p| result += "\n#{p}" }
			result += '```'
		end
		
		out = result
		
	else
		available_commands = bot.commands.values.reject do |c|
			c.is_a?(CommandAlias) || !c.attributes[:help_available] || !required_roles?(event.user, c.attributes[:required_roles]) || !allowed_roles?(event.user, c.attributes[:allowed_roles]) || !required_permissions?(event.user, c.attributes[:required_permissions], event.channel)
		end
		case available_commands.length
			when 0..5
				available_commands.reduce "**List of commands:**\n" do |memo, c|
				out = memo + "**`#{c.name}`**: #{c.attributes[:description] || '*No description available*'}\n"
			end
			when 5..50
				out = (available_commands.reduce "**List of commands:**\n" do |memo, c|
				memo + "`#{c.name}`, "
				end)[0..-3]
			else
				event.user.pm(available_commands.reduce("**List of commands:**\n") { |m, e| m + "`#{e.name}`, " }[0..-3])
				event.channel.pm? ? '' : 'Sending list in PM!'
			end
		end
	end
	event.channel.send_embed do |embed|
		embed.title = "Lerone Bot Helpline"
		embed.description = out
		ft_text = "We will be with you shortly. Please hold..."
		ic_url = "https://cdn.shopify.com/s/files/1/1151/9112/products/image_199487ac-517a-4fbd-a1c4-2853f3de975c_large.png"
		embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
	end
end