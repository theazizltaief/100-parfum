module Api
  module V1
    class SearchController < ApplicationController
      include Rails.application.routes.url_helpers

      def index
        query = params[:query].to_s.strip.downcase
        results = {
          perfumes: [],
          brands: []
        }

        if query.present?
          # Recherche de parfums
          perfumes = Parfum.includes(:variants, image_attachment: :blob)
                           .where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
                           .limit(10)
          results[:perfumes] = perfumes.map do |parfum|
            {
              id: parfum.id,
              name: parfum.name,
              image_url: parfum.image.attached? ? url_for(parfum.image) : nil,
              description: parfum.description,
              category: parfum.category,
              fragrance_class: parfum.fragrance_class,
              disponible: parfum.disponible,
              variants: parfum.variants.map { |v| { size: v.size, price: v.price } },
              min_price: parfum.variants.minimum(:price) || 0
            }
          end

          # Recherche de marques
          brands = Brand.includes(image_attachment: :blob)
                        .where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
                        .limit(5)
          results[:brands] = brands.map do |brand|
            {
              id: brand.id,
              name: brand.name,
              image_url: brand.image.attached? ? url_for(brand.image) : nil,
              description: brand.description
            }
          end
        end

        render json: results
      rescue StandardError => e
        render json: { error: "Erreur lors de la recherche: #{e.message}" }, status: :internal_server_error
      end
    end
  end
end
