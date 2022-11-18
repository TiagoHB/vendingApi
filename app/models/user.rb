class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: [ :seller, :buyer ]

  validates :deposit, :role, presence: true
  validates :coin5, :coin10, :coin20, :coin50, :coin100, numericality: { only_integer: true }

  has_many :products

  def jwt_payload
    super
  end
end
