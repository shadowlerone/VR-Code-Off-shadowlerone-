## Calculator
def calculate event, code, maths_r
	math = code.join(' ')
	if (math =~ maths_r)
		begin
			out = '%.4f' % eval(math.gsub('^', '**'))
		rescue StandardError
			out = "Maths are hard. I'm trying my best."
		end
	else
		out = "Sorry, your formatting is incorrect"
	end
	event.channel.send_embed do |embed|
		embed.title = "The Lerone Calculator"
		embed.description = "#{math}\n= #{out.to_s}"
		ft_text = "Mathletes Unite!"
		embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text)
	end

end

