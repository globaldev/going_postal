# encoding: utf-8

require "minitest/autorun"
require File.expand_path("../../lib/going_postal", __FILE__)

class GoingPostalTest < MiniTest::Unit::TestCase
  
  def test_required
    assert(GoingPostal.required?("GB"))
    refute(GoingPostal.required?("IE"))
  end
  
  def test_not_required
    refute(GoingPostal.not_required?("GB"))
    assert(GoingPostal.not_required?("IE"))
  end
  
  def test_default_country_code_as_mixin
    gb = Object.new
    class << gb
      include GoingPostal
      def country_code
        "GB"
      end
    end
    
    us = Object.new
    class << us
      include GoingPostal
      def country_code
        "US"
      end
    end
    
    assert(gb.postcode?("SL4 1EG"))
    refute(gb.postcode?("20037-8001"))
    assert_equal("SL4 1EG", gb.format_postcode("sl41eg"))
    assert_nil(gb.format_postcode("20037-8001"))
    
    assert(us.postcode?("20037-8001"))
    refute(us.postcode?("SL4 1EG"))
    assert_equal("20037-8001", us.format_postcode("200378001"))
    assert_nil(us.format_postcode("SL4 1EG"))
  end
  
  def test_default_postcode_as_mixin
    gb = Object.new
    class << gb
      include GoingPostal
      def country_code
        "GB"
      end
      
      def postcode
        "SL4 1EG"
      end
    end
    
    us = Object.new
    class << us
      include GoingPostal
      def country_code
        "US"
      end
      
      def zip
        "20037-8001"
      end
    end
    
    assert_equal("SL4 1EG", gb.format_postcode)
    assert(gb.postcode?)
    
    assert_equal("20037-8001", us.format_postcode)
    assert(us.postcode?)
  end
  
  def test_valid
    assert(GoingPostal.valid?("SL4 1EG", "GB"))
    refute(GoingPostal.valid?("A1", "GB"))
  end
  
  def test_valid_not_available_on_mixin
    obj = Object.new
    class << obj
      include GoingPostal
    end
    
    assert_raises(NoMethodError) {obj.valid?("SL4 1EG", "GB")}
  end
  
  def test_country_code_required_when_no_default
    e1 = assert_raises(ArgumentError) {GoingPostal.format_postcode("sl41eg")}
    assert_equal("wrong number of arguments (1 for 0..2)", e1.message)
    
    e2 = assert_raises(ArgumentError) {GoingPostal.postcode?("20037-8001")}
    assert_equal("wrong number of arguments (1 for 0..2)", e2.message)
  end
  
  def test_postcode_required_when_no_default
    e1 = assert_raises(ArgumentError) {GoingPostal.format_postcode}
    assert_equal("wrong number of arguments (0 for 0..2)", e1.message)
    
    e2 = assert_raises(ArgumentError) {GoingPostal.postcode?}
    assert_equal("wrong number of arguments (0 for 0..2)", e2.message)
  end
  
  def test_too_many_args
    e1 = assert_raises(ArgumentError) {GoingPostal.format_postcode("sl41eg", "GB", "1")}
    assert_equal("wrong number of arguments (3 for 0..2)", e1.message)
    
    e2 = assert_raises(ArgumentError) {GoingPostal.postcode?("sl41eg", "GB", "1")}
    assert_equal("wrong number of arguments (3 for 0..2)", e2.message)
  end
  
  def test_postcode_query_returns_formatted_postcode
    assert_equal("SL4 1EG", GoingPostal.postcode?("sl41eg", "GB"))
  end
  
  def test_format_postcode_aliases
    assert_equal("SL4 1EG", GoingPostal.format_post_code("SL4 1EG", "GB"))
    assert_equal("SL4 1EG", GoingPostal.format_zip("SL4 1EG", "GB"))
    assert_equal("SL4 1EG", GoingPostal.format_zipcode("SL4 1EG", "GB"))
    assert_equal("SL4 1EG", GoingPostal.format_zip_code("SL4 1EG", "GB"))
  end
  
  def test_postcode_query_aliases
    assert(GoingPostal.post_code?("SL4 1EG", "GB"))
    assert(GoingPostal.zip?("SL4 1EG", "GB"))
    assert(GoingPostal.zipcode?("SL4 1EG", "GB"))
    assert(GoingPostal.zip_code?("SL4 1EG", "GB"))
    assert(GoingPostal.valid_postcode?("SL4 1EG", "GB"))
    assert(GoingPostal.valid_post_code?("SL4 1EG", "GB"))
    assert(GoingPostal.valid_zip?("SL4 1EG", "GB"))
    assert(GoingPostal.valid_zipcode?("SL4 1EG", "GB"))
    assert(GoingPostal.valid_zip_code?("SL4 1EG", "GB"))
    assert(GoingPostal.postcode_valid?("SL4 1EG", "GB"))
    assert(GoingPostal.post_code_valid?("SL4 1EG", "GB"))
    assert(GoingPostal.zip_valid?("SL4 1EG", "GB"))
    assert(GoingPostal.zipcode_valid?("SL4 1EG", "GB"))
    assert(GoingPostal.zip_code_valid?("SL4 1EG", "GB"))
  end
  
  def test_gb_format_postcode
    assert_equal("A9 9AA", GoingPostal.format_postcode("A9 9aa", "GB"))
    assert_equal("A9 9AA", GoingPostal.format_postcode("a99aa", "GB"))
    assert_equal("A9 9AA", GoingPostal.format_postcode(" a9 9a a\t", "GB"))
    
    assert_equal("A99 9AA", GoingPostal.format_postcode("a999aa", "GB"))
    assert_equal("A99 9AA", GoingPostal.format_postcode("a 999 AA", "GB"))
    assert_equal("A99 9AA", GoingPostal.format_postcode("A99\n9AA", "GB"))
    
    assert_equal("AA9 9AA", GoingPostal.format_postcode("Aa99aA", "GB"))
    assert_equal("AA9 9AA", GoingPostal.format_postcode("aa99 aa ", "GB"))
    assert_equal("AA9 9AA", GoingPostal.format_postcode("a a 9 9 a a", "GB"))
    
    assert_equal("AA99 9AA", GoingPostal.format_postcode("\taa 99 9 a a", "GB"))
    assert_equal("AA99 9AA", GoingPostal.format_postcode("aa999aa", "GB"))
    assert_equal("AA99 9AA", GoingPostal.format_postcode("AA99 9A A", "GB"))
    
    assert_equal("A9A 9AA", GoingPostal.format_postcode("A9A 9aa", "GB"))
    assert_equal("A9A 9AA", GoingPostal.format_postcode("a 9a9aa ", "GB"))
    assert_equal("A9A 9AA", GoingPostal.format_postcode("a9a9aa", "GB"))
    
    assert_equal("AA9A 9AA", GoingPostal.format_postcode(" a A9A 9AA ", "GB"))
    assert_equal("AA9A 9AA", GoingPostal.format_postcode("a a 9\na 9 a a", "GB"))
    assert_equal("AA9A 9AA", GoingPostal.format_postcode("Aa9a9aa", "GB"))
    
    assert_nil(GoingPostal.format_postcode("A1", "GB"))
  end
  
  def test_gb_postcode_query
    assert(GoingPostal.postcode?("SL4 1EG", "GB"))
    assert(GoingPostal.postcode?("sl41eg", "GB"))
    
    assert(GoingPostal.postcode?("A9A 9AA", "GB"))
    refute(GoingPostal.postcode?("A9I 9AA", "GB"))
    refute(GoingPostal.postcode?("A9L 9AA", "GB"))
    refute(GoingPostal.postcode?("A9O 9AA", "GB"))
    refute(GoingPostal.postcode?("A9Q 9AA", "GB"))
    refute(GoingPostal.postcode?("A9Z 9AA", "GB"))
    
    assert(GoingPostal.postcode?("A0 9AA", "GB"))
    assert(GoingPostal.postcode?("A90 9AA", "GB"))
    refute(GoingPostal.postcode?("A09 9AA", "GB"))
    
    assert(GoingPostal.postcode?("A9 9AA", "GB"))
    assert(GoingPostal.postcode?("A9 9QA", "GB"))
    refute(GoingPostal.postcode?("A9 9IA", "GB"))
    refute(GoingPostal.postcode?("A9 9KA", "GB"))
    refute(GoingPostal.postcode?("A9 9MA", "GB"))
    refute(GoingPostal.postcode?("A9 9OA", "GB"))
  end
  
  def test_ca_format_postcode
    assert_equal("K0H 9Z0", GoingPostal.format_postcode("k0h9z0", "CA"))
    assert_equal("K1A 0B1", GoingPostal.format_postcode("k 1 a 0 b 1", "CA"))
    assert_equal("H0H 0H0", GoingPostal.format_postcode("H0 H0 H0", "CA"))
    
    assert_nil(GoingPostal.format_postcode("12345", "CA"))
  end
  
  def test_ca_postcode_query
    assert(GoingPostal.postcode?("H0H 0H0", "CA"))
    assert(GoingPostal.postcode?("h0 h0 h0", "CA"))
    
    refute(GoingPostal.postcode?("SL4 1EG", "CA"))
  end

  def test_us_format_postcode
    assert_equal("55416", GoingPostal.format_postcode("554-16", "US"))
    assert_equal("20037-8001", GoingPostal.format_postcode("200378001", "US"))
    assert_equal("60612-0344", GoingPostal.format_postcode("60612 0344", "US"))
    assert_equal("19002", GoingPostal.format_postcode("1 9 0 0 2", "US"))
    assert_equal("19002-0052", GoingPostal.format_postcode("1 9 0 0 2 0 0 5 2", "US"))
    
    assert_nil(GoingPostal.format_postcode("1234", "US"))
    assert_nil(GoingPostal.format_postcode("123456", "US"))
    assert_nil(GoingPostal.format_postcode("abcde", "US"))
    assert_nil(GoingPostal.format_postcode("abcde-efgh", "US"))
  end
  
  def test_us_postcode_query
    assert(GoingPostal.postcode?("55416", "US"))
    assert(GoingPostal.postcode?("20037-8001", "US"))
    assert(GoingPostal.postcode?("200 378 001", "US"))
    
    refute(GoingPostal.postcode?("1234", "US"))
    refute(GoingPostal.postcode?("123456", "US"))
    refute(GoingPostal.postcode?("12345-123", "US"))
    refute(GoingPostal.postcode?("12345-12345", "US"))
  end
  
  def test_au_format_postcode
    assert_equal("0123", GoingPostal.format_postcode("0123", "AU"))
    assert_equal("1234", GoingPostal.format_postcode("1 2 3 4", "AU"))
    
    assert_nil(GoingPostal.format_postcode("123", "AU"))
    assert_nil(GoingPostal.format_postcode("12345", "AU"))
    assert_nil(GoingPostal.format_postcode("abcd", "AU"))
  end
  
  def test_au_postcode_query
    assert(GoingPostal.postcode?("0123", "AU"))
    assert(GoingPostal.postcode?(" 0 1 2 3 ", "AU"))
    
    refute(GoingPostal.postcode?("123", "AU"))
    refute(GoingPostal.postcode?("12345", "AU"))
    refute(GoingPostal.postcode?("abcd", "AU"))
  end
  
  def test_nz_format_postcode
    assert_equal("0123", GoingPostal.format_postcode("0123", "NZ"))
    assert_equal("1234", GoingPostal.format_postcode("1 2 3 4", "NZ"))
    
    assert_nil(GoingPostal.format_postcode("123", "NZ"))
    assert_nil(GoingPostal.format_postcode("12345", "NZ"))
    assert_nil(GoingPostal.format_postcode("abcd", "NZ"))
  end
  
  def test_nz_postcode_query
    assert(GoingPostal.postcode?("0123", "NZ"))
    assert(GoingPostal.postcode?(" 0 1 2 3 ", "NZ"))
    
    refute(GoingPostal.postcode?("123", "NZ"))
    refute(GoingPostal.postcode?("12345", "NZ"))
    refute(GoingPostal.postcode?("abcd", "NZ"))
  end
  
  def test_za_format_postcode
    assert_equal("0123", GoingPostal.format_postcode("0123", "ZA"))
    assert_equal("1234", GoingPostal.format_postcode("1 2 3 4", "ZA"))
    
    assert_nil(GoingPostal.format_postcode("123", "ZA"))
    assert_nil(GoingPostal.format_postcode("12345", "ZA"))
    assert_nil(GoingPostal.format_postcode("abcd", "ZA"))
  end
  
  def test_za_postcode_query
    assert(GoingPostal.postcode?("0123", "ZA"))
    assert(GoingPostal.postcode?(" 0 1 2 3 ", "ZA"))
    
    refute(GoingPostal.postcode?("123", "ZA"))
    refute(GoingPostal.postcode?("12345", "ZA"))
    refute(GoingPostal.postcode?("abcd", "ZA"))
  end
  
  def test_non_required_format_postcode # Countries that don't have postcodes
    assert_nil(GoingPostal.format_postcode("A9A 9AA", "IE"))
    assert_nil(GoingPostal.format_postcode("12345", "IE"))
    assert_nil(GoingPostal.format_postcode("1234", "IE"))
    assert_nil(GoingPostal.format_postcode("1234", "AO"))
    assert_nil(GoingPostal.format_postcode("1234", "AG"))
    assert_nil(GoingPostal.format_postcode("1234", "ST"))
  end
  
  def test_ie_postcode_query
    assert(GoingPostal.postcode?(nil, "IE"))
    assert(GoingPostal.postcode?("", "IE"))
    
    refute(GoingPostal.postcode?("A9A 9AA", "IE"))
    refute(GoingPostal.postcode?("12345", "IE"))
    refute(GoingPostal.postcode?("1234", "IE"))
  end
  
  def test_ch_format_postcode
    assert_equal("1234", GoingPostal.format_postcode("1234", "CH"))
    assert_equal("1234", GoingPostal.format_postcode("1 2\t3\r4\n", "CH"))
    
    assert_nil(GoingPostal.format_postcode("123", "CH"))
    assert_nil(GoingPostal.format_postcode("0123", "CH"))
    assert_nil(GoingPostal.format_postcode("12345", "CH"))
    assert_nil(GoingPostal.format_postcode("abcd", "CH"))
  end
  
  def test_ch_postcode_query
    assert(GoingPostal.postcode?("1234", "CH"))
    assert(GoingPostal.postcode?("1 2\t3\r4\n", "CH"))
    
    refute(GoingPostal.postcode?("123", "CH"))
    refute(GoingPostal.postcode?("0123", "CH"))
    refute(GoingPostal.postcode?("12345", "CH"))
    refute(GoingPostal.postcode?("abcd", "CH"))
  end

  def test_dk_format_postcode
    assert_equal("1234", GoingPostal.format_postcode("1234", "DK"))
    assert_equal("1234", GoingPostal.format_postcode("1 2\t3\r4\n", "DK"))

    assert_nil(GoingPostal.format_postcode("123", "DK"))
    assert_nil(GoingPostal.format_postcode("0123", "DK"))
    assert_nil(GoingPostal.format_postcode("12345", "DK"))
    assert_nil(GoingPostal.format_postcode("abcd", "DK"))
  end

  def test_dk_postcode_query
    assert(GoingPostal.postcode?("1234", "DK"))
    assert(GoingPostal.postcode?("1 2\t3\r4\n", "DK"))

    refute(GoingPostal.postcode?("123", "DK"))
    refute(GoingPostal.postcode?("0123", "DK"))
    refute(GoingPostal.postcode?("12345", "DK"))
    refute(GoingPostal.postcode?("abcd", "DK"))
  end

  def test_be_format_postcode
    assert_equal("1234", GoingPostal.format_postcode("1234", "BE"))
    assert_equal("1234", GoingPostal.format_postcode("1 2\t3\r4\n", "BE"))

    assert_nil(GoingPostal.format_postcode("123", "BE"))
    assert_nil(GoingPostal.format_postcode("0123", "BE"))
    assert_nil(GoingPostal.format_postcode("12345", "BE"))
    assert_nil(GoingPostal.format_postcode("abcd", "BE"))
  end

  def test_be_postcode_query
    assert(GoingPostal.postcode?("1234", "BE"))
    assert(GoingPostal.postcode?("1 2\t3\r4\n", "BE"))

    refute(GoingPostal.postcode?("123", "BE"))
    refute(GoingPostal.postcode?("0123", "BE"))
    refute(GoingPostal.postcode?("12345", "BE"))
    refute(GoingPostal.postcode?("abcd", "BE"))
  end

  def test_lu_format_postcode
    assert_equal("1234", GoingPostal.format_postcode("1234", "LU"))
    assert_equal("1234", GoingPostal.format_postcode("1 2\t3\r4\n", "LU"))

    assert_nil(GoingPostal.format_postcode("123", "LU"))
    assert_nil(GoingPostal.format_postcode("0123", "LU"))
    assert_nil(GoingPostal.format_postcode("12345", "LU"))
    assert_nil(GoingPostal.format_postcode("abcd", "LU"))
  end
  
  def test_lu_postcode_query
    assert(GoingPostal.postcode?("1234", "LU"))
    assert(GoingPostal.postcode?("1 2\t3\r4\n", "LU"))

    refute(GoingPostal.postcode?("123", "LU"))
    refute(GoingPostal.postcode?("0123", "LU"))
    refute(GoingPostal.postcode?("12345", "LU"))
    refute(GoingPostal.postcode?("abcd", "LU"))
  end

  def test_at_format_postcode
    assert_equal("1234", GoingPostal.format_postcode("1234", "AT"))
    assert_equal("1234", GoingPostal.format_postcode("1 2\t3\r4\n", "AT"))

    assert_nil(GoingPostal.format_postcode("123", "AT"))
    assert_nil(GoingPostal.format_postcode("0123", "AT"))
    assert_nil(GoingPostal.format_postcode("12345", "AT"))
    assert_nil(GoingPostal.format_postcode("abcd", "AT"))
  end

  def test_at_postcode_query
    assert(GoingPostal.postcode?("1234", "AT"))
    assert(GoingPostal.postcode?("1 2\t3\r4\n", "AT"))

    refute(GoingPostal.postcode?("123", "AT"))
    refute(GoingPostal.postcode?("0123", "AT"))
    refute(GoingPostal.postcode?("12345", "AT"))
    refute(GoingPostal.postcode?("abcd", "AT"))
  end

  def test_no_format_postcode
    assert_equal("1234", GoingPostal.format_postcode("1234", "NO"))
    assert_equal("0034", GoingPostal.format_postcode("0 0\t3\r4\n", "NO"))
    assert_equal("0023", GoingPostal.format_postcode("0023", "NO"))

    assert_nil(GoingPostal.format_postcode("123", "NO"))
    assert_nil(GoingPostal.format_postcode("12345", "NO"))
    assert_nil(GoingPostal.format_postcode("abcd", "NO"))
  end

  def test_no_postcode_query
    assert(GoingPostal.postcode?("1234", "NO"))
    assert(GoingPostal.postcode?("1 2\t3\r4\n", "NO"))
    assert(GoingPostal.postcode?("0123", "NO"))
    assert(GoingPostal.postcode?("0001", "NO"))

    refute(GoingPostal.postcode?("123", "NO"))
    refute(GoingPostal.postcode?("12345", "NO"))
    refute(GoingPostal.postcode?("abcd", "NO"))
  end

  def test_nl_format_postcode
    assert_equal("1234 AB", GoingPostal.format_postcode("1234 AB", "NL"))
    assert_equal("1234 AB", GoingPostal.format_postcode("1234ab", "NL"))

    assert_nil(GoingPostal.format_postcode("1230", "NL"))
    assert_nil(GoingPostal.format_postcode("0123 AB", "NL"))
    assert_nil(GoingPostal.format_postcode("12345", "NL"))
    assert_nil(GoingPostal.format_postcode("abcd", "NL"))
  end

  def test_nl_postcode_query
    assert(GoingPostal.postcode?("1234 AB", "NL"))
    assert(GoingPostal.postcode?("1234ab", "NL"))

    refute(GoingPostal.postcode?("1230", "NL"))
    refute(GoingPostal.postcode?("0123 AB", "NL"))
    refute(GoingPostal.postcode?("12345", "NL"))
    refute(GoingPostal.postcode?("abcd", "NL"))
    refute(GoingPostal.postcode?("1", "NL"))
  end

  def test_pl_format_postcode
    assert_equal("01-234", GoingPostal.format_postcode("01-234", "PL"))
    assert_equal("01-234", GoingPostal.format_postcode("01234", "PL"))
    assert_equal("01-234", GoingPostal.format_postcode("01 - 234", "PL"))
    assert_equal("01-234", GoingPostal.format_postcode("01 -- 234", "PL"))
    assert_equal("01-234", GoingPostal.format_postcode("01 — 234", "PL"))

    assert_nil(GoingPostal.format_postcode("012-34", "PL"))
    assert_nil(GoingPostal.format_postcode("012-345", "PL"))
    assert_nil(GoingPostal.format_postcode("01-2345", "PL"))
    assert_nil(GoingPostal.format_postcode("01-23", "PL"))
    assert_nil(GoingPostal.format_postcode("01-23-4", "PL"))
  end

  def test_pl_postcode_query
    assert(GoingPostal.postcode?("01-234", "PL"))
    assert(GoingPostal.postcode?("01234", "PL"))
    assert(GoingPostal.postcode?("01 - 234", "PL"))
    assert(GoingPostal.postcode?("01 -- 234", "PL"))
    assert(GoingPostal.postcode?("01 — 234", "PL"))

    refute(GoingPostal.postcode?("012-34", "PL"))
    refute(GoingPostal.postcode?("012-345", "PL"))
    refute(GoingPostal.postcode?("01-2345", "PL"))
    refute(GoingPostal.postcode?("01-23", "PL"))
    refute(GoingPostal.postcode?("01-23-4", "PL"))
  end

  def test_de_format_postcode
    assert_equal("12345", GoingPostal.format_postcode("12345", "DE"))
    assert_equal("12345", GoingPostal.format_postcode("1 2\t3\r4\n 5", "DE"))

    assert_nil(GoingPostal.format_postcode("123", "DE"))
    assert_nil(GoingPostal.format_postcode("0123", "DE"))
    assert_nil(GoingPostal.format_postcode("1234", "DE"))
    assert_nil(GoingPostal.format_postcode("abcd", "DE"))
  end

  def test_de_postcode_query
    assert(GoingPostal.postcode?("12345", "DE"))
    assert(GoingPostal.postcode?("01767", "DE"))

    refute(GoingPostal.postcode?("1230", "DE"))
    refute(GoingPostal.postcode?("0123 AB", "DE"))
    refute(GoingPostal.postcode?("145", "DE"))
    refute(GoingPostal.postcode?("abcd", "DE"))
    refute(GoingPostal.postcode?("1", "DE"))
    refute(GoingPostal.postcode?("00000", "DE"))
  end

  def test_fr_format_postcode
    assert_equal("12345", GoingPostal.format_postcode("12345", "FR"))
    assert_equal("12345", GoingPostal.format_postcode("1 2\t3\r4\n 5", "FR"))

    assert_nil(GoingPostal.format_postcode("123", "FR"))
    assert_nil(GoingPostal.format_postcode("0123", "FR"))
    assert_nil(GoingPostal.format_postcode("1234", "FR"))
    assert_nil(GoingPostal.format_postcode("abcd", "FR"))
  end

  def test_fr_postcode_query
    assert(GoingPostal.postcode?("12345", "FR"))
    assert(GoingPostal.postcode?("01767", "FR"))

    refute(GoingPostal.postcode?("1230", "FR"))
    refute(GoingPostal.postcode?("0123 AB", "FR"))
    refute(GoingPostal.postcode?("145", "FR"))
    refute(GoingPostal.postcode?("abcd", "FR"))
    refute(GoingPostal.postcode?("1", "FR"))
    refute(GoingPostal.postcode?("00000", "FR"))
  end

  def test_se_format_postcode
    assert_equal("12345", GoingPostal.format_postcode("12345", "SE"))
    assert_equal("12345", GoingPostal.format_postcode("1 2\t3\r4\n 5", "SE"))

    assert_nil(GoingPostal.format_postcode("123", "SE"))
    assert_nil(GoingPostal.format_postcode("0123", "SE"))
    assert_nil(GoingPostal.format_postcode("1234", "SE"))
    assert_nil(GoingPostal.format_postcode("abcd", "SE"))
  end

  def test_se_postcode_query
    assert(GoingPostal.postcode?("12345", "SE"))

    refute(GoingPostal.postcode?("01767", "SE"))
    refute(GoingPostal.postcode?("1230", "SE"))
    refute(GoingPostal.postcode?("0123 AB", "SE"))
    refute(GoingPostal.postcode?("145", "SE"))
    refute(GoingPostal.postcode?("abcd", "SE"))
    refute(GoingPostal.postcode?("1", "SE"))
    refute(GoingPostal.postcode?("00000", "SE"))
  end

  def test_ro_format_postcode
    assert_equal("123456", GoingPostal.format_postcode("123456", "RO"))
    assert_equal("010011", GoingPostal.format_postcode("0 1\t0\r0\n 11", "RO"))

    assert_nil(GoingPostal.format_postcode("123", "RO"))
    assert_nil(GoingPostal.format_postcode("0123", "RO"))
    assert_nil(GoingPostal.format_postcode("1234", "RO"))
    assert_nil(GoingPostal.format_postcode("abcd", "RO"))
  end

  def test_ro_postcode_query
    assert(GoingPostal.postcode?("123456", "RO"))
    assert(GoingPostal.postcode?("010011", "RO"))

    refute(GoingPostal.postcode?("1230", "RO"))
    refute(GoingPostal.postcode?("0123 AB", "RO"))
    refute(GoingPostal.postcode?("145", "RO"))
    refute(GoingPostal.postcode?("abcd", "RO"))
    refute(GoingPostal.postcode?("1", "RO"))
    refute(GoingPostal.postcode?("00000", "RO"))
  end

  def test_unknown_country_format_postcode_strips_whitespace
    assert_equal("A9A 9AA", GoingPostal.format_postcode(" A9A 9AA ", "AQ"))
    assert_equal("12345-6789", GoingPostal.format_postcode(" 12345-6789 ", "AQ"))
    assert_equal("0123", GoingPostal.format_postcode(" 0123 ", "AQ"))
  end

  def test_unknown_country_postcode_query_always_true
    assert(GoingPostal.postcode?(" A9A 9AA ", "AQ"))
    assert(GoingPostal.postcode?(" 12345-6789 ", "AQ"))
    assert(GoingPostal.postcode?(" 0123 ", "AQ"))
  end
end
