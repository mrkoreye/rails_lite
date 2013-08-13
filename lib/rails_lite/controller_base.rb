require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @route_params = route_params
  end

  def session
    @session ||= Session.new(@req)
  end
  
  def params
    @params ||= Params.new(@req, @route_params)
  end

  def already_rendered?
    @already_rendered ||= false
  end

  def redirect_to(url)
    @res.status = 302
    @res["location"] = url
    @already_rendered = true
    
    @session.store_session(@res)
    @res
  end

  def render_content(body, content_type)
    @res.body = body
    @res.content_type = content_type
    @already_rendered = true
    self.session.store_session(@res)
    @res
  end

  def render(action_name)
    controller_name = self.class.to_s.underscore
    erb_template = ERB.new(File.read(
      "views/#{controller_name}/#{action_name}.html.erb")
      )
    b = binding
    render_content(erb_template.result(b), 'text/html')
  end

  def invoke_action(action_name)
    self.send(action_name)
    render(action_name) unless already_rendered?
  end
end
