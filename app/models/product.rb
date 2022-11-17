class Product < ApplicationRecord
  belongs_to :seller, class_name: "User"

  validates :productName, :cost, :amountAvailable, :seller, presence: true
  validates :productName, :length => { :minimum => 2 }
  validates :cost, :amountAvailable, numericality: { only_integer: true }
  validate :cost_multiple

  def cost_multiple
    if cost.present? && cost.remainder(5) != 0
      errors.add(:cost, 'Cost value must be multiple of 5.')
    end
  end 
end
