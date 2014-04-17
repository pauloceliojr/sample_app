class User < ActiveRecord::Base
  #def email=(valor)
    #if valor.respond_to?(:downcase)
      #write_attribute(:email, valor.downcase)
      ## Pode também ser usado self[:email] = email.downcase
    #else
      #super
    #end
  #end

  before_save { self.email = self.email.downcase }

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, length: { minimum: 6 }
end
