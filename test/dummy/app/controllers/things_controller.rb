class ThingsController < ApplicationController
  def index
    @things = Thing.all
  end

  def show
    @thing = Thing.find(params[:id])
  end
  alias_method :edit, :show

  def new
    if params[:meta_type]
      @thing = Thing.new(meta_type: MetaType[params[:meta_type]])
    end
  end

  def create
    @thing = Thing.new(params[:thing])
    if @thing.save
      redirect_to things_path()
    else
      render :new
    end
  end

  def update
    @thing = Thing.find(params[:id])
    if @thing.update_attributes(params[:thing])
      redirect_to thing_path(@thing)
    else
      render :edit
    end
  end
end