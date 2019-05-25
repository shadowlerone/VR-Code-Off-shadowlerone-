
def extention length, randoms
	string = ""
	length.times {|i| string << randoms.sample}
	return string
end
def censor_message event, swears_string, randoms, circ = false
	if (event.content =~ /#{swears_string}/)
		# event.respond "Found Objectionable content"
		new_string = "**#{event.author.display_name}**:\t#{event.content.gsub(/#{swears_string}/i, extention($&.length, randoms))}"
		event.message.delete
		event.channel.send_embed do |embed|
			# embed.color = 
			if circ == true
				embed.title = 'Swear Removal Service - Disciplinary Committee'
				message = "#{"="*10}\n\nWe've noticed you've tried to edit a swear into your message.\nAttempts to circumvent rules *will* result in a ban.\n#{"="*20}"
			else
				embed.title = 'Swear Removal Service'
			end
			embed.description = "#{new_string}#{message}"
			# embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: 'Language Police', icon_url:"https://cdn.shopify.com/s/files/1/1151/9112/products/image_199487ac-517a-4fbd-a1c4-2853f3de975c_large.png")
		end
	end
end

def gen_swears_string
	data = JSON.parse(File.read("swears.json"))
	array = []
	
	data['swears'].each {|i|
		i[0] = "(?!#{i[0]})"
		array << i
	} 
	# puts array
	swears_string = array.join("|")
	# puts swears_string
	randoms = data['randoms']
	return [swears_string, randoms]
end