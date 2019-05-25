class response
	def initialize channel, message, title = nil, format = nil
		channel.send_embed do |embed|
			embed.title = 'The Ruby logo'
			# embed.image = Discordrb::Webhooks::EmbedImage.new(url: 'https://www.ruby-lang.org/images/header-ruby-logo.png')
		end		  
	end
end