module AdminPanel
  class BrandsController < ApplicationController
    include ActionView::RecordIdentifier
    before_action :authenticate_admin!
    before_action :set_brand, only: [ :show, :edit, :update, :destroy ]

    def index
      @brands = Brand.all.order(:name)
    end

    def show
      @brand = Brand.find(params[:id])
      @parfums = @brand.parfums
    end


    def new
     @brand = Brand.new
     @redirect_to = params[:redirect_to]
    end


    def create
      @brand = Brand.new(brand_params)
      if @brand.save
        redirect_path = params[:redirect_to].presence || admin_panel_brands_path
        redirect_to redirect_path, notice: "Marque créée avec succès."
      else
        render :new
      end
    end


    def edit
    end

    def update
      if @brand.update(brand_params)
        redirect_to admin_panel_brands_path, notice: "Marque mise à jour."
      else
        render :edit
      end
    end

    def update
     @brand.image.purge if params[:brand][:remove_image] == "1"
     if @brand.update(brand_params)
         redirect_to admin_panel_brands_path, notice: "Marque mise à jour."
     else
       render :edit
     end
    end


    def destroy
      @brand = Brand.find(params[:id])
      @brand.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(dom_id(@brand))
        end
        format.html { redirect_to admin_panel_brands_path, notice: "Marque supprimée avec succès" }
      end
    end




    private

    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name, :image)
    end
  end
end
