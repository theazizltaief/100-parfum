class Variant < ApplicationRecord
  belongs_to :parfum
  validates :size, presence: { message: "La contenance est obligatoire" }, uniqueness: { scope: :parfum_id, message: "Cette contenance existe déjà pour ce parfum" }
  validates :price, presence: { message: "Le prix est obligatoire" }, numericality: { greater_than: 0, message: "Doit être supérieur à 0" }, allow_nil: false
end
