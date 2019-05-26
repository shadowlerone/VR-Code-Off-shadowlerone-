WIP = "GIMME TIME I'M WORKING ON IT OKAY!"

Currencies = {
	'aud' => 'AUD',
	'cad' => 'CAD',
	'yen' => 'JPY',
	'nzd' => 'NZD',
	'gbp' => 'GBP',
	'usd' => 'USD'
}

To_mm = {
	'ft' => 304.8,
	'cm' => 10,
	'm' => 1000,
	'km' => 1000000,
	'in' => 25.4,
	'yd' => 914.4,
	'mm' => 1
}

To_ml = {
	'oz' => 29.5735,
	'ml' => 1,
	'cc' => 1,
	'L' => 1000,
	'qt' => 25.4,
	'gal' => 914.4,
}

def convert_currency value, base, final, fx
	if final == 'cad'
		'%.2f' % (value * fx["FX#{Currencies[base]}CAD"]['v'])
	elsif base == 'cad'
		'%.2f' % (value * (1/fx["FX#{Currencies[final]}CAD"]['v']))
	else	
		'%.2f' % (value * fx["FX#{Currencies[base]}CAD"]['v'] * (1/fx["FX#{Currencies[final]}CAD"]['v']))
	end
end

def convert_d(value, base, final)
	'%.2f' % (value * To_mm[base] * (1/To_mm[final]))
end

def convert_v(value, base, final)
	'%.2f' % (value * To_ml[base] * (1/To_ml[final]))
end

def convert_temps(value, base, final)
	if base == "f"
		interim = value *  9/5 + 32
	elsif base == "c"
		interim = value
	elsif base = "k"
		interim = value - 273
	end

	if base == "f"
		value * 1/(9/5 + 32)
	elsif base == "c"
		interim
	elsif base = "k"
		interim + 273
	end
end

def get_exchange_rate
	response = HTTParty.get('https://www.bankofcanada.ca/valet/observations/group/FX_RATES_DAILY/json?recent=1')
	# puts response['observations'][0]
	return response['observations'][0]
end

def convert event, value, unit1, to, unit2, fx, r
	ic_url = "http://andraelewis.ca/assets/music2.jpg"
	if !(to =~ /to/i)
		return "Error Raised because <@87118368078835712> demands it. the function would still work :P"
	end
	if (unit1 =~  r['distances']) && (unit1 =~ r['distances'])
		out = convert_d(value.to_f, unit1, unit2)
	elsif (unit1 =~ r['volumes']) && (unit1 =~ r['volumes'])
		out = convert_v(value.to_f, unit1, unit2)
	elsif (unit1 =~ r['temperatures']) && (unit1 =~ r['temperatures'])
		out = convert_temps(value.to_f, unit1, unit2)
	elsif (unit1 =~ r['currencies']) && (unit1 =~ r['currencies'])
		out = convert_currency(value.to_f, unit1, unit2, fx)
		# ic_url = "https://upload.wikimedia.org/wikipedia/en/7/7e/BankOfCanada.svg"
	else
		out = "Sorry, but your unit is not valid."
	end
	title = "Unit Convertion Squad"
	event.channel.send_embed do |embed|
		embed.title = title.to_s
		embed.description = "About #{out.to_s}"
		embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: ft_text, icon_url: ic_url)
	end
end