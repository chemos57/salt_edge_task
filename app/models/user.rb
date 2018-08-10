class User < ApplicationRecord
  validates_uniqueness_of :email
  validates_format_of :email,:with => Devise::email_regexp
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :customers
end
