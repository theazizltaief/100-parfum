# app/controllers/api/v1/brands_controller.rb
module Api
  module V1
    class BrandsController < ApplicationController
      include Rails.application.routes.url_helpers

      def index
        brands = Brand.includes(:parfums, image_attachment: :blob).all
        render json: brands.map { |brand|
          {
            id: brand.id,
            name: brand.name,
            image_url: brand.image.attached? ? url_for(brand.image) : nil,
            parfums: brand.parfums.map { |parfum|
              {
                id: parfum.id,
                name: parfum.name,
                prix: parfum.prix,
                description: parfum.description,
                category: parfum.category,
                fragrance_class: parfum.fragrance_class,
                image_url: parfum.image.attached? ? url_for(parfum.image) : nil,
                disponible: parfum.disponible # AJOUTÉ : Inclure le statut de disponibilité
              }
            }
          }
        }
      end

      def only_brands
        brands = Brand.includes(image_attachment: :blob).all
        render json: brands.map { |brand|
          {
            id: brand.id,
            name: brand.name,
            image_url: brand.image.attached? ? url_for(brand.image) : nil
          }
        }
      end

      def show
        brand = Brand.includes(:parfums, image_attachment: :blob).find(params[:id])
        render json: {
          id: brand.id,
          name: brand.name,
          image_url: brand.image.attached? ? url_for(brand.image) : nil,
          parfums: brand.parfums.map { |parfum|
            {
              id: parfum.id,
              name: parfum.name,
              prix: parfum.prix,
              description: parfum.description,
              category: parfum.category,
              fragrance_class: parfum.fragrance_class,
              image_url: parfum.image.attached? ? url_for(parfum.image) : nil,
              disponible: parfum.disponible # AJOUTÉ : Inclure le statut de disponibilité
            }
          }
        }
      end
    end
  end
end
