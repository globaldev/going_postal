# The GoingPostal mixin provides classes with postcode formatting and validation
# methods. If the class has a #country_code method, the country_code argument on
# the provided methods becomes optional. If the class also has one of #postcode,
# #post_code, #zipcode, #zip_code, or #zip, the string argument on the provided
# methods becomes optional.
# 
#   class Address
#     include GoingPostal
#     attr_accessor :number, :street, :city, :postcode, :country_code
#     
#     def initialize(number, street, :city, postcode, country_code="GB")
#       self.number = number
#       self.street = street
#       self.city = city
#       self.postcode = postcode
#       self.country_code = country_code
#     end
#     
#     def postcode=(value)
#       @postcode = format_postcode(value)
#     end
#     
#     def valid?
#       number && street && city && postcode_valid?
#     end
#   end
# 
# The methods can also be called directly on the GoingPostal module.
# 
#   GoingPostal.postcode?("sl41eg", "GB")      #=> "SL4 1EG"
#   GoingPostal.postcode?("200378001", "US")   #=> "20037-8001"
# 
# Currently supported countries are United Kingdom (GB, UK), United States
# (US), Canada (CA), Australia (AU), New Zeland (NZ), South Africa (ZA), The
# Netherlands (NL), Sweden (SE), Belgium (BE), Austria (AT), Norway (NO),
# Germany (DE), Luxembourg (LU), Denmark (DE), France (FR) and Romania (RO).
# 
# Ireland (IE) as well as 60+ other countries that do not use postcodes
# - see GoingPostal::COUNTRIES_WITHOUT_POSTCODES - are supported insomuch as,
# these countires don't use postcodes, so "" or nil are considered valid.
# 
# Currently unsupported countries will be formatted by simply stripping leading
# and trailing whitespace, and any input will be considered valid.
# 

require "set"

module GoingPostal
  COUNTRIES_WITHOUT_POSTCODES = Set[
    "AO", # Angola
    "AG", # Antigua and Barbuda
    "AN", # Netherlands Antilles
    "AW", # Aruba
    "BS", # Bahamas
    "BZ", # Belize
    "BJ", # Benin
    "BW", # Botswana
    "BF", # Burkina Faso
    "BI", # Burundi
    "CI", # Côte d’Ivoire
    "CD", # Congo, the Democratic Republic of the
    "CG", # Congo (Brazzaville)
    "CM", # Cameroon
    "CF", # Central African Republic
    "CW", # Curaçao
    "KM", # Comoros
    "CK", # Cook Islands
    "DJ", # Djibouti
    "DM", # Dominica
    "GQ", # Equatorial Guinea
    "ER", # Eritrea
    "FJ", # Fiji
    "GM", # Gambia
    "GH", # Ghana
    "GD", # Grenada
    "GN", # Guinea
    "GY", # Guyana
    "HK", # Hong Kong
    "IE", # Ireland
    "KI", # Kiribati
    "KP", # North Korea
    "MO", # Macau
    "MW", # Malawi
    "ML", # Mali
    "MR", # Mauritania
    "MU", # Mauritius
    "MS", # Montserrat
    "NA", # Namibia
    "NR", # Nauru
    "NU", # Niue
    "PA", # Panama
    "QA", # Qatar
    "RW", # Rwanda
    "KN", # Saint Kitts and Nevis
    "LC", # Saint Lucia
    "ST", # Sao Tome and Principe
    "SC", # Seychelles
    "SL", # Sierra Leone
    "SB", # Solomon Islands
    "SO", # Somalia
    "SR", # Suriname
    "SX", # Sint Maarten
    "SY", # Syria
    "TF", # French Southern and Antarctic Territories
    "TK", # Tokelau
    "TL", # East Timor
    "TO", # Tonga
    "TT", # Trinidad and Tobago
    "TV", # Tuvalu
    "TZ", # Tanzania
    "UG", # Uganda
    "AE", # United Arab Emirates
    "VU", # Vanuatu
    "YE", # Yemen
    "ZW"  # Zimbabwe
  ]
  
  # :section: Checking Postcode Requirements
  
  # :call-seq: GoingPostal.not_required?(country_code) -> bool
  # 
  # Returns true if the country spcified by the two letter country code
  # country_code argument does not require postcodes, false otherwise.
  # 
  def self.not_required?(country_code)
    COUNTRIES_WITHOUT_POSTCODES.include?(country_code.to_s.upcase)
  end
  
  # :call-seq: GoingPostal.not_required?(country_code) -> bool
  # 
  # Returns true if the country spcified by the two letter country code
  # country_code argument requires postcodes, false otherwise.
  # 
  def self.required?(country_code)
    !not_required?(country_code)
  end
  
  extend self
  
  # :section: Validation
  
  # :call-seq: postcode?([string[, country_code]]) -> formatted_str or false
  # 
  # Returns a formatted postcode as a string if string is a valid postcode,
  # false otherwise.
  # 
  # If calling this method on the GoingPostal module the country_code argument
  # is required and should be a two letter country code.
  # 
  # If the GoingPostal module has been mixed in to a class, and the class has
  # a #country_code method, the country_code argument is optional, defaulting
  # to the value returned by #country_code. If the class also has a #postcode,
  # #post_code, #zipcode, #zip_code, or #zip method, the string argument becomes
  # optional.
  # 
  # Postcodes for unknown countries will always be considered valid, the return
  # value will consist of the input stripped of leading and trailing whitespace.
  # 
  # For countries without postcodes, "" will be returned from in input of "" or
  # nil, false otherwise.
  # 
  def postcode?(*args)
    string, country_code = get_args_for_format_postcode(args)
    if GoingPostal.not_required?(country_code)
      string.nil? || string.to_s.empty? ? "" : false
    else
      format_postcode(string, country_code) || false
    end
  end
  alias post_code? postcode?
  alias zip? postcode?
  alias zipcode? postcode?
  alias zip_code? postcode?
  alias valid_postcode? postcode?
  alias valid_post_code? postcode?
  alias valid_zip? postcode?
  alias valid_zipcode? postcode?
  alias valid_zip_code? postcode?
  alias postcode_valid? postcode?
  alias post_code_valid? postcode?
  alias zip_valid? postcode?
  alias zipcode_valid? postcode?
  alias zip_code_valid? postcode?
  
  # :call-seq: self.valid?([string[, country_code]]) -> formatted_string or false
  # 
  # Alias for #postcode?
  #--
  # this is just here to trick rdoc, the class alias below will overwrite this
  # empty method.
  #++
  def self.valid?; end
  
  class << self
    alias valid? postcode?
  end
  
  # :section: Formatting
  
  # :call-seq: format_postcode([string[, country_code]]) -> formatted_str or nil
  # 
  # Returns a formatted postcode as a string if string is a valid postcode, nil
  # otherwise.
  # 
  # If calling this method on the GoingPostal module the country_code argument
  # is required and should be a two letter country code.
  # 
  # If the GoingPostal module has been mixed in to a class, and the class has
  # a #country_code method, the country_code argument is optional, defaulting
  # to the value returned by #country_code. If the class also has a #postcode,
  # #post_code, #zipcode, #zip_code, or #zip method, the string argument becomes
  # optional.
  # 
  # Postcodes for unknown countries will simply be stripped of leading and
  # trailing whitespace.
  # 
  # Countries without postcodes will always return nil.
  #--
  # The magic is done calling a formatting method for each country. If no such
  # method exists a default method is called stripping the leading and trailing
  # whitespace.
  #++
  def format_postcode(*args)
    string, country_code = get_args_for_format_postcode(args)
    method = if GoingPostal.not_required?(country_code)
      :format_non_postcode
    else
      :"format_#{country_code.to_s.downcase}_postcode"
    end
    respond_to?(method) ? __send__(method, string) : string.to_s.strip
  end
  alias format_post_code format_postcode
  alias format_zip format_postcode
  alias format_zipcode format_postcode
  alias format_zip_code format_postcode
  
  # :stopdoc:
  
  def format_non_postcode(string)
    nil
  end
  # backwards compatibility, no need to alias other non-postcode countries
  alias format_ie_postcode format_non_postcode
  
  def format_gb_postcode(string)
    out_code = string.to_s.upcase.delete(" \t\r\n")
    in_code = out_code.slice!(-3, 3)
    if out_code =~ /^[A-Z]{1,2}([1-9][0-9A-HJKMNPR-Y]?|0[A-HJKMNPR-Y]?)$/ &&
      in_code =~ /^[0-9][A-HJLNP-Z]{2}$/
      [out_code, in_code].join(" ")
    end
  end
  alias format_uk_postcode format_gb_postcode
  
  def format_ca_postcode(string)
    forward_sort_area = string.to_s.upcase.delete(" \t\r\n")
    local_delivery_unit = forward_sort_area.slice!(-3, 3)
    if forward_sort_area =~ /^[A-CEGHJK-NPR-TVXY][0-9][A-CEGHJK-NPR-TV-Z]$/ &&
      local_delivery_unit =~ /[0-9][A-CEGHJK-NPR-TV-Z][0-9]/
      [forward_sort_area, local_delivery_unit].join(" ")
    end
  end
  
  def format_au_postcode(string)
    string = string.to_s.delete(" \t\r\n")
    string if string =~ /^[0-9]{4}$/
  end
  alias format_nz_postcode format_au_postcode
  alias format_za_postcode format_au_postcode
  
  def format_us_zipcode(string)
    zip = string.to_s.delete("- \t\r\n")
    plus_four = zip.slice!(5, 4)
    plus_four = nil if plus_four && plus_four.empty?
    if zip =~ /^[0-9]{5}$/ && (plus_four.nil? || plus_four =~ /^[0-9]{4}$/)
      [zip, plus_four].compact.join("-")
    end
  end
  alias format_us_postcode format_us_zipcode
  
  def format_ch_postcode(string)
    string = string.to_s.delete(" \t\r\n")
    string if string =~ /^[1-9][0-9]{3}$/
  end

  def format_dk_postcode(string)
    format_ch_postcode(string)
  end
  
  def format_be_postcode(string)
    format_ch_postcode(string)
  end

  def format_lu_postcode(string)
    format_ch_postcode(string)
  end

  def format_at_postcode(string)
    format_ch_postcode(string)
  end

  def format_nl_postcode(string)
    string = string.to_s.upcase.delete(" \t\r\n")
    string.insert(4, " ") if string.length >= 4
    string if string =~ /^[1-9][0-9]{3} (S[BCE-RT-Z]|[A-RT-Z][A-Z])$/
  end

  def format_pl_postcode(string)
    match = /^(\d\d)[^\w]*(\d\d\d)$/.match(string)
    match.captures.join("-") if match && match[1] && match[2]
  end

  def format_de_postcode(string)
    string = string.to_s.upcase.delete(" \t\r\n")
    string if string =~ /^([0]{1}[1-9]{1}|[1-9]{1}[0-9]{1})[0-9]{3}$/
  end

  def format_se_postcode(string)
    string = string.to_s.upcase.delete(" \t\r\n")
    string if string =~ /^[1-9]{1}[0-9]{4}$/
  end

  def format_no_postcode(string)
    string = string.to_s.upcase.delete(" \t\r\n")
    string if string =~ /^[0-9]{4}$/
  end

  def format_fr_postcode(string)
    format_de_postcode(string)
  end
  
  def format_ro_postcode(string)
    string = string.to_s.delete(" \t\r\n")
    string if string =~ /^[0-9]{6}$/
  end

  private
  
  def get_args_for_format_postcode(args)
    case args.length
    when 2
      args
    when 0
      [postcode_for_format_postcode, country_code_for_format_postcode]
    when 1
      args << country_code_for_format_postcode
    else
      message = "wrong number of arguments (#{args.length} for 0..2)"
      raise ArgumentError, message, caller(2)
    end
  end
  
  def country_code_for_format_postcode
    if respond_to?(:country_code)
      country_code
    else
      raise ArgumentError, "wrong number of arguments (1 for 0..2)", caller(3)
    end
  end
  
  POSTCODE_ALIASES = [:postcode, :post_code, :zipcode, :zip_code, :zip]
  def postcode_for_format_postcode
    if ali = POSTCODE_ALIASES.find {|a| respond_to?(a)}
      send(ali)
    else
      raise ArgumentError, "wrong number of arguments (0 for 0..2)", caller(3)
    end
  end
  
end
