# encoding: utf-8
# (c) 2009-2011 metaminded UG, all rights reserved

<<-CREATE_SQL
  create table meta_type_properties (
    id                serial NOT NULL PRIMARY KEY,
    sid               character varying,
    label             character varying not null,
    property_type_sid character varying not null,
    required          boolean not null default false,
    system            boolean not null default false,
    dimension         character varying null default null,
    default_value     character varying null default null,
    created_at        timestamp without time zone,
    updated_at        timestamp without time zone
  );
CREATE_SQL

class MetaTypeProperty < ActiveRecord::Base

  attr_accessible :sid, :label, :property_type_sid, :default_value, :required, :dimension, :choices

  # Associations
  has_many :meta_type_members
  has_many :meta_types, :through => :meta_type_members

  # Validations
  validates_presence_of :label
  validates_presence_of :property_type_sid
  validates_inclusion_of :property_type_sid, in: MetaTypes::MetaPropertyType.sids
  validates_format_of :sid, with: /\A[a-z][a-z_0-9]*\Z/
  validates_exclusion_of :sid, in: %w{alias and begin break case class def defined?
    do else elsif end ensure false for if in module next nil not or redo rescue retry
    return self super then true undef unless until when while yield},
    message: "is a ruby keyword, please don't use that."
  validates_exclusion_of :sid, in: MetaTypes::MetaProperties.instance_methods.map(&:to_s),
    message: "overrides core functionality, please don't use that."

  scope :ordered, order("meta_type_members.position asc")

  def name() "#{label} (#{property_type_sid}) " end

  def property_type
    MetaTypes::MetaPropertyType[property_type_sid]
  end

  def set_position_for!(meta_type, pos)
    meta_type_member = meta_type_members.where(meta_type_id: meta_type.id).first
    meta_type_member.position = pos
    meta_type_member.save!
  end

  def get_position_for(meta_type)
    meta_type_member = meta_type_members.where(meta_type_id: meta_type.id).first
    meta_type_member.position
  end

  def type
    {integer: :numeric}[property_type_sid.to_sym] || property_type_sid.to_sym
  end

  def number?
    %w{integer float}.member? property_type_sid
  end

  def limit() nil end

  delegate :cast, :parse, to: :property_type

  class << self
    def [](sid) find_by_sid(sid); end
  end
end

