Defaults = {'title': 'Lerone Bot', 'desc': nil, 'footer_text': 'Lerone Bot - Language Police', 'footer_icon': "http://andraelewis.ca/assets/music2.jpg"}
def respond event, props
	event.channel.send_embed do |embed|
		embed.title = props['title'] #x|| Defaults['title']
		embed.description = props['desc'] #x|| Defaults['desc']
		ft_text = props['footer_text']#x || Defaults['footer_text']
		ic_url = props['footer_icon'] #x|| Defaults['footer_icon']
		# embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
	end
end