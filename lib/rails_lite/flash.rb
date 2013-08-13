require 'json'
require 'webrick'
require 'debugger'

class Flash
  def initialize(req)
    req.cookies.each do |cookie| 
      if cookie.name == '_rails_lite_app_flash' 
        @old = JSON.parse(cookie.value)
      end
    end
    @old = {} if @old.nil?
    @new = {}
  end

  def [](key)
    return @new[key] unless @new[key].nil?
    @old[key.to_s]
  end

  def []=(key, val)
    @new[key.to_s] = val
  end

  def store_flash(res)
    json = JSON.generate(@new)
    cookie = WEBrick::Cookie.new('_rails_lite_app_flash', json)
    res.cookies << cookie
  end
   
end
