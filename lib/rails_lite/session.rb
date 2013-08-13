require 'json'
require 'webrick'
require 'debugger'

class Session
  def initialize(req)
    req.cookies.each do |cookie| 
      if cookie.name == '_rails_lite_app' 
        @cookie = JSON.parse(cookie.value)
      end
    end
    @cookie = {} if @cookie.nil?
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    json = JSON.generate(@cookie)
    cookie = WEBrick::Cookie.new('_rails_lite_app', json)
    res.cookies << cookie
  end
end
