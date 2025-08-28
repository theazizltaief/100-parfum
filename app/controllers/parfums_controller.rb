class ParfumsController < ApplicationController
  def index
    @parfums = Parfum.all
  end

  def show
    @parfum = Parfum.find(params[:id])
  end

  def new
    @parfum = Parfum.new
  end


private

def parfum_params
    params.require(:parfum).permit(:nom, :description, :prix, :image, :genre, :brand_id)
end
end
