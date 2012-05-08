# encoding: utf-8

# (c) 2012 metaminded UG, all rights reserved

<<-CREATE_SQL
  create table meta_type_members (
    id            serial PRIMARY KEY,
    meta_type_id  integer references meta_types(id),
    meta_type_property_id integer references meta_type_properties(id),
    position      integer,
    created_at    timestamp without time zone,
    updated_at    timestamp without time zone
  );
CREATE_SQL

class MetaTypeMember < ActiveRecord::Base

  attr_accessible :position

  belongs_to :meta_type
  belongs_to :meta_type_property

end

