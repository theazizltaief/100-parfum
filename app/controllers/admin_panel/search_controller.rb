module AdminPanel
     class SearchController < ApplicationController
       before_action :authenticate_admin!
       include ActionView::Helpers::NumberHelper # Ajout pour utiliser number_to_currency

       def index
         @query = params[:q]&.downcase
         if @query.present?
           @results = {
             parfums: Parfum.includes(:brand, :image_attachment, :variants)
                           .where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{@query}%", "%#{@query}%")
                           .limit(10),
             brands: Brand.includes(:image_attachment)
                          .where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{@query}%", "%#{@query}%")
                          .limit(5),
             orders: Order.where("LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR phone LIKE ?", "%#{@query}%", "%#{@query}%", "%#{@query}%").limit(10)
           }
           @total_results = @results.values.sum(&:count)

           if request.xhr? || request.format.json?
             render json: {
               total: @total_results,
               query: @query,
               parfums: @results[:parfums].map { |p| {
                 id: p.id,
                 name: p.name,
                 brand: p.brand&.name || "Sans marque",
                 url: admin_panel_parfum_path(p)
               } },
               brands: @results[:brands].map { |b| {
                 id: b.id,
                 name: b.name,
                 parfums_count: b.parfums.count,
                 url: admin_panel_brand_path(b)
               } },
               orders: @results[:orders].map { |o| {
                 id: o.id,
                 customer_name: o.full_name || "#{o.first_name} #{o.last_name}".strip,
                 total: number_to_currency(o.total || 0, unit: "TND", separator: ",", delimiter: " ", format: "%n %u"),
                 url: admin_panel_order_path(o)
               } }
             }
           else
             render :index
           end
         else
           render json: { total: 0, query: "", parfums: [], brands: [], orders: [] }, status: :ok
         end
       rescue StandardError => e
         Rails.logger.error "Erreur dans SearchController: #{e.message}\n#{e.backtrace.join("\n")}"
         render json: { error: "Erreur interne" }, status: :internal_server_error
       end
     end
end
