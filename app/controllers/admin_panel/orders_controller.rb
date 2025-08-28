module AdminPanel
  class OrdersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_order, only: [ :show, :update_status, :destroy ]

    def index
      @orders = Order.all

      # Filtrage par statut si spécifié
      if params[:status].present? && params[:status] != "all"
        @orders = @orders.where(status: Order.statuses[params[:status]])
      end

      # Tri par date de création (plus récent en premier)
      @orders = @orders.order(created_at: :desc)

      # Pagination avec Kaminari si disponible, sinon pagination simple
      if defined?(Kaminari)
        @orders = @orders.page(params[:page]).per(25)
      else
        # Pagination simple sans gem
        page = (params[:page] || 1).to_i
        per_page = 25
        offset = (page - 1) * per_page

        total_count = @orders.count
        @orders = @orders.limit(per_page).offset(offset)

        # Ajouter des méthodes pour simuler Kaminari
        @orders.define_singleton_method(:current_page) { page }
        @orders.define_singleton_method(:total_pages) { (total_count.to_f / per_page).ceil }
        @orders.define_singleton_method(:total_count) { total_count }
        @orders.define_singleton_method(:prev_page) { page > 1 ? page - 1 : nil }
        @orders.define_singleton_method(:next_page) { page < (total_count.to_f / per_page).ceil ? page + 1 : nil }
      end

      # Statistiques pour les badges
      @stats = {
        total: Order.count,
        pending: Order.where(status: 0).count,
        confirmed: Order.where(status: 1).count,
        shipped: Order.where(status: 2).count,
        delivered: Order.where(status: 3).count,
        cancelled: Order.where(status: 4).count
      }
    end

    def show
      # Détails d'une commande spécifique
    end

    def update_status
      new_status = params[:new_status]

      if Order.statuses.keys.include?(new_status)
        @order.update(status: Order.statuses[new_status])
        redirect_to admin_panel_orders_path, notice: "Statut de la commande ##{@order.id} mis à jour avec succès."
      else
        redirect_to admin_panel_orders_path, alert: "Statut invalide."
      end
    end

    def destroy
      order_id = @order.id
      @order.destroy
      redirect_to admin_panel_orders_path, notice: "Commande ##{order_id} supprimée avec succès."
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
  end
end
