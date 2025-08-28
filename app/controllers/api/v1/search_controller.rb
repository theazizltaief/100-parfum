# app/controllers/api/v1/search_controller.rb
module Api
  module V1
    class SearchController < ApplicationController
      include Rails.application.routes.url_helpers # Nécessaire pour rails_blob_url

      def index
        query = params[:query].to_s.strip.downcase
        results = {
          perfumes: [],
          brands: []
        }

        if query.present?
          # Recherche de parfums
          perfumes = Parfum.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
                           .limit(10) # Limitez le nombre de résultats pour la performance

          results[:perfumes] = perfumes.map do |parfum|
            {
              id: parfum.id,
              name: parfum.name,
              # CHANGÉ : Utilisation de rails_blob_url pour l'image Active Storage
              image_url: parfum.image.attached? ? rails_blob_url(parfum.image, only_path: true) : nil,
              description: parfum.description,
              category: parfum.category,
              fragrance_class: parfum.fragrance_class,
              prix: parfum.prix,
              disponible: parfum.disponible
            }
          end

          # Recherche de marques
          brands = Brand.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
                        .limit(5) # Limitez le nombre de résultats pour les marques

          results[:brands] = brands.map do |brand|
            {
              id: brand.id,
              name: brand.name,
              # CHANGÉ : Utilisation de rails_blob_url pour l'image Active Storage
              image_url: brand.image.attached? ? rails_blob_url(brand.image, only_path: true) : nil,
              description: brand.description
            }
          end
        end

        render json: results
      end
    end
  end
end
