module AdminPanel
  class ParfumsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_parfum, only: [ :show, :edit, :update, :destroy, :update_image ]
    before_action :set_brands, only: [ :new, :edit, :create, :update ]

    def index
      @parfums = Parfum.includes(:brand).all
    end

    def show
    end

    def new
      @parfum = Parfum.new
      @parfum.variants.build # Prépare un variant vide pour le formulaire
    end

    def create
      @parfum = Parfum.new(parfum_params)
      @brands = Brand.all

      respond_to do |format|
        if @parfum.save
          format.turbo_stream do
            redirect_to admin_panel_parfums_path, notice: "Parfum créé avec succès"
          end
          format.html { redirect_to admin_panel_parfums_path, notice: "Parfum créé avec succès" }
        else
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("parfum_form", partial: "form", locals: { parfum: @parfum, brands: @brands }),
                   status: :unprocessable_entity
          end
          format.html { render :new }
        end
      end
    end

    def edit
      @parfum = Parfum.find(params[:id])
    end

    def update
      @parfum = Parfum.find(params[:id])
      respond_to do |format|
        if @parfum.update(parfum_params)
          format.turbo_stream do
            redirect_to admin_panel_parfums_path, notice: "Parfum mis à jour avec succès."
          end
          format.html { redirect_to admin_panel_parfums_path, notice: "Parfum mis à jour avec succès." }
        else
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("parfum_form", partial: "form", locals: { parfum: @parfum, brands: @brands }),
                   status: :unprocessable_entity
          end
          format.html { render :edit }
        end
      end
    end

    def destroy
      @parfum = Parfum.find(params[:id])
      @parfum.destroy

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(dom_id(@parfum))
        end
        format.html do
          redirect_to admin_panel_parfums_path, notice: "Parfum supprimé avec succès."
        end
      end
    end

    def update_image
      @parfum = Parfum.find(params[:id])

      if params[:parfum].present? && params[:parfum][:image].present?
        if @parfum.update(image_params)
          redirect_to admin_panel_parfum_path(@parfum), notice: "Image importée avec succès."
        else
          render :show, alert: "Erreur lors de l’importation de l’image."
        end
      else
        redirect_to admin_panel_parfum_path(@parfum), alert: "Veuillez sélectionner une image avant de cliquer sur Importer."
      end
    end

    private

    def set_parfum
      @parfum = Parfum.find(params[:id])
    end

    def set_brands
      @brands = Brand.all.order(:name) # Trié par nom pour affichage dans le select
    end

    def image_params
      params.require(:parfum).permit(:image)
    end

    def parfum_params
      params.require(:parfum).permit(
        :name, :description, :brand_id, :image, :remove_image, :category, :fragrance_class, :disponible,
        variants_attributes: [ :id, :size, :price, :_destroy ] # Pour gérer les variants nested
      )
    end
  end
end
