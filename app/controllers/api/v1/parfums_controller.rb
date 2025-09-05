# app/controllers/api/v1/parfums_controller.rb
module Api
  module V1
    class ParfumsController < ApplicationController
      include Rails.application.routes.url_helpers

      def index
        parfums = Parfum.includes(:brand, :variants, image_attachment: :blob).all
        render json: parfums.map { |parfum|
          parfum.as_json(only: [ :id, :name, :description, :category, :fragrance_class, :disponible ], include: {
            brand: { only: [ :id, :name ] },
            variants: { only: [ :size, :price ] }
          }).merge(
            image_url: parfum.image.attached? ? url_for(parfum.image) : nil
          )
        }
      end

      def show
        parfum = Parfum.includes(:brand, :variants, image_attachment: :blob).find_by(id: params[:id])
        if parfum
          render json: parfum.as_json(only: [ :id, :name, :description, :category, :fragrance_class, :disponible ], include: {
            brand: { only: [ :id, :name ] },
            variants: { only: [ :size, :price ] }
          }).merge(
            image_url: parfum.image.attached? ? url_for(parfum.image) : nil
          )
        else
          render json: { error: "Parfum not found" }, status: :not_found
        end
      end
    end
  end
end
