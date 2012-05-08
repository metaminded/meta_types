module MetaTypes::ActiveRecordAddons

  module ClassMethods
    def meta_typed(nam, hstore=nil)
      hstore ||= "#{nam}_hstore"
      raise "No column named '#{hstore}' found." unless attribute_names.member? hstore
      vnam = "@_meta_properties_#{nam}"
      belongs_to :meta_type

      define_method nam do
        return nil unless meta_type
        m = instance_variable_get(vnam)
        m ||= instance_variable_set(vnam, MetaTypes::MetaProperties.new(self, hstore))
      end
      
      define_method "#{nam}_values=" do |hash|
        ppp = self.send nam
        hash.each do |k,v|
          ppp.send "#{k}=", v
        end
      end
    end
  end

  class << self
    def included(by)
      by.send :extend, MetaTypes::ActiveRecordAddons::ClassMethods
    end
  end

end

ActiveRecord::Base.send :include, MetaTypes::ActiveRecordAddons