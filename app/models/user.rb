class User < ApplicationRecord
  rolify
  include Devise::JWT::RevocationStrategies::Allowlist

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
         :validatable, :trackable, :jwt_authenticatable, jwt_revocation_strategy: self

  # associations
  has_one_attached :avatar

  # validations
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :avatar, content_type: ['image/png', 'image/jpeg'], size: { less_than: 10.megabytes }
end
