WIP = "GIMME TIME I'M WORKING ON IT OKAY!"

Currencies = {
	'aud' => 'AUD',
	'cad' => 'CAD',
	'yen' => 'JPY',
	'nzd' => 'NZD',
	'gbp' => 'GBP',
	'usd' => 'USD'
}

def convert_currency value, base, final, fx
	if final == 'cad'
		value * fx["FX#{Currencies[base]}CAD"]['v']
	elsif base == 'cad'
		value * (1/fx["FX#{Currencies[final]}CAD"]['v'])
	else	
		value * fx["FX#{Currencies[base]}CAD"]['v'] * (1/fx["FX#{Currencies[final]}CAD"]['v'])
	end
end

def convert_d(value, base, final)
	WIP
end

def convert_v(value, base, final)
	WIP
end

def convert_temps(value, base, final)
	WIP
end

def get_exchange_rate
	response = HTTParty.get('https://www.bankofcanada.ca/valet/observations/group/FX_RATES_DAILY/json?recent=1')
	# puts response['observations'][0]
	return response['observations'][0]
end