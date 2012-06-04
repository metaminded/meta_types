class Moo < ActiveRecord::Base
  attr_accessible :title
  meta_typed :notes, :notess, untyped: true
end
