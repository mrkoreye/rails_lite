require 'uri'
require 'active_support/core_ext'

class Params
  def initialize(req, route_params = {})
    #return nil if req.query_string.nil? && req.body.nil?
    @params = {}
    @params.merge!(route_params)
    parse_www_encoded_form(req.query_string) unless req.query_string.nil?
    parse_www_encoded_form(req.body) unless req.body.nil?
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    query = URI.decode_www_form(www_encoded_form)
    query.each do |(k, val)| 
      key_array = parse_key(k)
    
      @params.deep_merge!(dig_deeper(key_array, val))
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
  
  def dig_deeper(key_array, val)
    return {} if key_array.empty?
    hash = {}
    if (key_array.length == 1)
      hash[key_array.shift] = val 
    else
      hash[key_array.shift] = dig_deeper(key_array, val)
    end
    
    hash
  end
  
end

