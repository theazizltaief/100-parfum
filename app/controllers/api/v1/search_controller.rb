module Api
  module V1
    class SearchController < ApplicationController
      include Rails.application.routes.url_helpers
      include ActionView::Helpers::NumberHelper

      def default_url_options
        @default_options ||= begin
          options = Rails.application.config.action_controller.default_url_options || {}
          options[:host] ||= "localhost"
          options[:port] ||= 3000
          options
        end
      end

      def index
        query = params[:query].to_s.strip.downcase
        results = {
          perfumes: [],
          brands: []
        }

        if query.present?
          perfumes = Parfum.includes(:variants, :image_attachment)
                          .where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
                          .limit(10)

          results[:perfumes] = perfumes.map do |parfum|
            valid_variants = parfum.variants.present? ? parfum.variants.select { |v| v.price && v.price > 0 } : [ { price: 0, size: "N/A" } ]
            default_variant = valid_variants.first || { price: 0, size: "N/A" }

            {
              id: parfum.id,
              name: parfum.name,
              image_url: parfum.image.attached? ? rails_blob_url(parfum.image.variant(resize_to_limit: [ 50, 50 ]), only_path: true) : "https://via.placeholder.com/50x50?text=P",
              description: parfum.description || "",
              url: "/vitrine/parfums/#{parfum.id}", # URL statique
              variants: valid_variants.map { |v| { size: v.size || "N/A", price: v.price || 0 } }
            }
          end

          brands = Brand.includes(:image_attachment)
                       .where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
                       .limit(5)

          results[:brands] = brands.map do |brand|
            {
              id: brand.id,
              name: brand.name,
              image_url: brand.image.attached? ? rails_blob_url(brand.image.variant(resize_to_limit: [ 50, 50 ]), only_path: true) : "https://via.placeholder.com/50x50?text=M",
              description: brand.description || "",
              url: "/vitrine/brands/#{brand.id}" # URL statique
            }
          end
        end

        render json: results
      rescue StandardError => e
        Rails.logger.error "Erreur dans Api::V1::SearchController: #{e.message}\n#{e.backtrace.join("\n")}"
        render json: { error: "Erreur interne lors de la recherche" }, status: :internal_server_error
      end
    end
  end
end
