class MetaTypePropertiesController < ApplicationController
  cruddler :all

  def index
    @meta_type_properties = MetaTypeProperty.all
  end
end
