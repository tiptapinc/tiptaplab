module Tiptaplab
  @@api = nil

  def self.api
    if @api.nil?
      raise "API connection has not been initialized. Please set one up using the Tiptaplab::Api.new() method."
    else
      @api
    end
  end

  def self.api=(a)
    @api = a
  end
end

%w(
  version
  api
  record
  model/user
  model/brand
).each{|m| require File.dirname(__FILE__) + '/tiptaplab/' + m }
