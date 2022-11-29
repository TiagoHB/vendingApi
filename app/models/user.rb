class User < ApplicationRecord
  # attr_accessor :login
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: [ :seller, :buyer ]

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true
  validates :coin5, :coin10, :coin20, :coin50, :coin100, numericality: { only_integer: true }

  has_many :products, foreign_key: 'seller_id', dependent: :destroy
  
  def email_required?
    false
  end


  def jwt_payload
    super
  end

  # def self.find_for_database_authentication warden_condition
  #   conditions = warden_condition.dup
  #   login = conditions.delete(:login)
  #   where(conditions).where(
  #     ["lower(username) = :value OR lower(email) = :value",
  #     { value: login.strip.downcase}]).first
  # end
end
