class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy

=begin - Sobrescrita de attr_accessor :email do método setter
  def email=(valor)
    if valor.respond_to?(:downcase)
      write_attribute(:email, valor.downcase)
      # Pode também ser usado self[:email] = email.downcase
    else
      super
    end
  end
=end

  # É executado primeiro na ordem de prioridade do callback.
  # É chamado para toda operação de salvamento, seja em INSERT ou UPDATE.
  # Aqui foi passado um bloco de linha como parâmetro do callback.
  before_save { self.email = email.downcase }

  # É executado após before_save, apenas para operação de INSERT.
  # Aqui foi passado a referência para um méthodo em vez de um bloco, o que é preferível no Rails.
  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password, length: { minimum: 6 }

  def self.new_remember_token # Poderia ser declarado como User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s) # to_s inserido para garantir que um token nil seja aceito em caso de algum erro.
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
