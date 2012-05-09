class Thing < ActiveRecord::Base
  attr_accessible :name, :meta_type, :meta_type_id

  meta_typed :properties

end
