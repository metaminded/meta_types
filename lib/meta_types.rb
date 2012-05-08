require "meta_types/engine"

module MetaTypes

end

Dir[File.join(File.dirname(__FILE__), 'meta_types', '*.rb')].each do |fn|
  require fn
end