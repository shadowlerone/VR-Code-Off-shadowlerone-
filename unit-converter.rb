Currencies = {
	'aud': 'AUD',
	'cad': 'CAD',
	'yen': 'JPY',
	'nzd': 'NZD',
	'gbp': 'GBP',
	'usd': 'USD'
}

def convert_currency value, base, final, fx
	if final == cad
		value * fx["FX#{Currencies[base]}CAD"]['v']
	elsif base == cad
		value * (1/fx["FX#{Currencies[final]}CAD"]['v'])
	else	
		value * fx["FX#{Currencies[base]}CAD"]['v'] 
	end
end

def get_exchange_rate
	response = HTTParty.get('https://www.bankofcanada.ca/valet/observations/group/FX_RATES_DAILY/json?recent=1')
	puts response['observations'][0]
	return response['observations'][0]
end