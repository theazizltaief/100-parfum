class Category < ApplicationRecord
  has_many :parfums, dependent: :destroy
end
