class Brand < ApplicationRecord
    has_many :parfums, dependent: :destroy
    has_one_attached :image
    validates :name, presence: true, uniqueness: true
end
