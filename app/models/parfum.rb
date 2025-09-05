class Parfum < ApplicationRecord
  belongs_to :brand
  has_many :variants, dependent: :destroy
  accepts_nested_attributes_for :variants, allow_destroy: true, reject_if: :all_blank  # Pour nested forms

  has_one_attached :image
  validates :name, presence: { message: "Le nom est obligatoire" }
  validates :variants, presence: true
  validates :brand_id, presence: { message: "La marque est obligatoire" }
  validates :description, presence: { message: "La description est obligatoire" },
                         length: { minimum: 5, message: "Minimum 5 caractères" }
  validates :category, presence: { message: "La catégorie est obligatoire" }
  validates :fragrance_class, presence: { message: "Le type de parfum est obligatoire" }
  enum :category, { homme: 0, femme: 1, unisexe: 2 }, prefix: true
  enum :fragrance_class, { designer: 0, niche: 1, collection_privee: 2 }, prefix: true
  attr_accessor :remove_image

  before_save :purge_image_if_requested



  private

  def purge_image_if_requested
    image.purge if remove_image == "1"
  end
end
