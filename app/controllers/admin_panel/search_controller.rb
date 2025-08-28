module AdminPanel
  class SearchController < ApplicationController
    before_action :authenticate_admin!

    def index
      @query = params[:q]&.strip
      @results = {}

      if @query.present? && @query.length >= 2
        # Recherche dans les parfums
        @results[:parfums] = Parfum.joins(:brand)
                                   .where("parfums.name ILIKE ? OR parfums.description ILIKE ? OR brands.name ILIKE ?",
                                         "%#{@query}%", "%#{@query}%", "%#{@query}%")
                                   .includes(:brand)
                                   .limit(10)

        # Recherche dans les marques
        @results[:brands] = Brand.where("name ILIKE ? OR description ILIKE ?",
                                       "%#{@query}%", "%#{@query}%")
                                 .limit(10)

        # Recherche dans les commandes
        @results[:orders] = Order.where("first_name ILIKE ? OR last_name ILIKE ? OR phone ILIKE ? OR CAST(id AS TEXT) ILIKE ?",
                                       "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%")
                                 .order(created_at: :desc)
                                 .limit(10)

        # Compter les résultats totaux
        @total_results = @results.values.sum(&:count)
      else
        @total_results = 0
      end

      # Si c'est une requête AJAX, retourner du JSON
      if request.xhr?
        render json: {
          query: @query,
          total: @total_results,
          parfums: @results[:parfums]&.map { |p| parfum_result(p) } || [],
          brands: @results[:brands]&.map { |b| brand_result(b) } || [],
          orders: @results[:orders]&.map { |o| order_result(o) } || []
        }
      end
    end

    private

    def parfum_result(parfum)
      {
        id: parfum.id,
        name: parfum.name,
        brand: parfum.brand&.name,
        price: parfum.prix,
        available: parfum.disponible,
        url: admin_panel_parfum_path(parfum),
        image_url: parfum.image.attached? ? url_for(parfum.image.variant(resize_to_limit: [ 50, 50 ])) : nil
      }
    end

    def brand_result(brand)
      {
        id: brand.id,
        name: brand.name,
        parfums_count: brand.parfums.count,
        url: admin_panel_brand_path(brand),
        image_url: brand.image.attached? ? url_for(brand.image.variant(resize_to_limit: [ 50, 50 ])) : nil
      }
    end

    def order_result(order)
      {
        id: order.id,
        customer_name: order.full_name,
        phone: order.phone,
        total: order.formatted_total,
        status: order.status_name,
        date: order.created_at.strftime("%d/%m/%Y"),
        url: admin_panel_order_path(order)
      }
    end
  end
end
