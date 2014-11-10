module GoingPostal
  class Postcode

    COUNTRIES_WITHOUT_POSTCODES = [
      'AO', # Angola
      'AG', # Antigua and Barbuda
      'AN', # Netherlands Antilles
      'AW', # Aruba
      'BS', # Bahamas
      'BZ', # Belize
      'BJ', # Benin
      'BW', # Botswana
      'BF', # Burkina Faso
      'BI', # Burundi
      'CI', # Côte d’Ivoire
      'CD', # Congo, the Democratic Republic of the
      'CG', # Congo (Brazzaville)
      'CM', # Cameroon
      'CF', # Central African Republic
      'CW', # Curaçao
      'KM', # Comoros
      'CK', # Cook Islands
      'DJ', # Djibouti
      'DM', # Dominica
      'GQ', # Equatorial Guinea
      'ER', # Eritrea
      'FJ', # Fiji
      'GM', # Gambia
      'GH', # Ghana
      'GD', # Grenada
      'GN', # Guinea
      'GY', # Guyana
      'HK', # Hong Kong
      'IE', # Ireland
      'KI', # Kiribati
      'KP', # North Korea
      'MO', # Macau
      'MW', # Malawi
      'ML', # Mali
      'MR', # Mauritania
      'MU', # Mauritius
      'MS', # Montserrat
      'NA', # Namibia
      'NR', # Nauru
      'NU', # Niue
      'PA', # Panama
      'QA', # Qatar
      'RW', # Rwanda
      'KN', # Saint Kitts and Nevis
      'LC', # Saint Lucia
      'ST', # Sao Tome and Principe
      'SC', # Seychelles
      'SL', # Sierra Leone
      'SB', # Solomon Islands
      'SO', # Somalia
      'SR', # Suriname
      'SX', # Sint Maarten
      'SY', # Syria
      'TF', # French Southern and Antarctic Territories
      'TK', # Tokelau
      'TL', # East Timor
      'TO', # Tonga
      'TT', # Trinidad and Tobago
      'TV', # Tuvalu
      'TZ', # Tanzania
      'UG', # Uganda
      'AE', # United Arab Emirates
      'VU', # Vanuatu
      'YE', # Yemen
      'ZW'  # Zimbabwe
    ]

    def self.not_required?(country_code)
      COUNTRIES_WITHOUT_POSTCODES.include?(country_code.to_s.upcase)
    end

    def self.required?(country_code)
      !not_required?(country_code)
    end

  end
end