
def extention match, randoms
	string = match[0]
	length = match.length - 1
	prev = ""
	length.times {|i|
		x = randoms.sample
		while x == prev
			x = randoms.sample
		end
		string << x
		prev = x
	}
	return string
end

def censor_message event, swears_string, randoms, circ = false
	if (event.content =~ /#{swears_string}/i)
		# event.respond "Found Objectionable content"
		new_string = "**#{event.author.display_name}**:\t#{event.content.gsub(/#{swears_string}/i, extention($&, randoms))}"
		event.message.delete
		new_string << message = "\n#{"="*20}\nWe've noticed you've tried to edit a swear into your message.\nAttempts to circumvent rules *will* result in a ban.\n#{"="*20}" if circ
		title = 'Swear Removal Service'
		title << 'Disciplinary Committee' if circ == true
		event.channel.send_embed do |embed|
			embed.title = title
			embed.description = new_string
			ft_text = 'Lerone Bot - Language Police'
			ic_url = "https://cdn.shopify.com/s/files/1/1151/9112/products/image_199487ac-517a-4fbd-a1c4-2853f3de975c_large.png"
			embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
		end
		# respond(event, props = {'title': title, 'desc': new_string})
	end
end

def gen_swears_string
	data = JSON.parse(File.read("swears.json"))
	array = []
	
	data['swears'].each {|i|
		i[0] = "(#{i[0]})("
		i << ")"
		array << i
	} 
	# puts array
	swears_string = array.join("|")
	# puts swears_string
	randoms = data['randoms']
	return [swears_string, randoms]
end

def addSwear args
	data = JSON.parse(File.read("swears.json"))
	args.each{|s|
		data['swears'] << s
	}
	data
end