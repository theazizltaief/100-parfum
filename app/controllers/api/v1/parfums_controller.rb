# app/controllers/api/v1/parfums_controller.rb
module Api
  module V1
    class ParfumsController < ApplicationController
      include Rails.application.routes.url_helpers

      def index
        parfums = Parfum.includes(:brand, image_attachment: :blob).all
        render json: parfums.map { |parfum|
          parfum.as_json(include: { brand: { only: [ :id, :name ] } })
                .merge(
                  image_url: parfum.image.attached? ? url_for(parfum.image) : nil,
                  disponible: parfum.disponible # AJOUTÉ : Inclure le statut de disponibilité
                )
        }
      end

      def show
        parfum = Parfum.includes(:brand, image_attachment: :blob).find_by(id: params[:id])
        if parfum
          render json: parfum
            .as_json(include: { brand: { only: [ :id, :name ] } })
            .merge(
              image_url: parfum.image.attached? ? url_for(parfum.image) : nil,
              disponible: parfum.disponible # AJOUTÉ : Inclure le statut de disponibilité
            )
        else
          render json: { error: "Parfum not found" }, status: :not_found
        end
      end
    end
  end
end
