require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params.merge(@req.params)
    @already_built_response = false
    # @params.merge!(@req.params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    check_if_rendered
    @res['Location'] = url
    @res.status = 302
    self.session.store_session(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    check_if_rendered
    @res.write(content)
    @res['Content-Type'] = content_type
    self.session.store_session(@res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    template = ERB.new(File.read(path))
    template_eval = template.result(binding)
    content_type = "text/html"
    render_content(template_eval, content_type)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end

  private
  def check_if_rendered
    raise Exception if already_built_response?
  end
end

