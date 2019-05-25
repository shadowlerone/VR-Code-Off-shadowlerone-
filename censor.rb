def censor_message event, swears_string
	if (event.content =~ /#{swears_string}/)
		# event.respond "Found Objectionable content"
		new_string = event.content.gsub(/#{swears_string}/, "*"*($&.length))
		#event.message.delete
		event.channel.send_embed do |embed|
			embed.title = 'Swear Removal Service'
			embed.description = new_string
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
	return swears_string
end