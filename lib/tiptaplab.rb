module Tiptaplab
end

%w(
  version
  api
  user
  brand
).each{|m| require File.dirname(__FILE__) + '/tiptaplab/' + m }
