class MetaTypesController < ApplicationController
  cruddler :all

  def index
    @meta_types = MetaType.all
  end
end