class Order < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  validates :items_data, presence: true

  # Syntaxe compatible avec toutes les versions de Rails
  STATUSES = {
    "pending" => 0,
    "confirmed" => 1,
    "shipped" => 2,
    "delivered" => 3,
    "cancelled" => 4
  }.freeze

  validates :status, inclusion: { in: STATUSES.values }

  def self.statuses
    STATUSES
  end

  def status_name
    STATUSES.key(status) || "pending"
  end

  def pending?
    status == 0
  end

  def confirmed?
    status == 1
  end

  def shipped?
    status == 2
  end

  def delivered?
    status == 3
  end

  def cancelled?
    status == 4
  end

  def items
    JSON.parse(items_data) rescue []
  end

  def items=(items_array)
    self.items_data = items_array.to_json
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def formatted_total
    "#{total_amount} TND"
  end
end
