class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :reverse_relationships

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

  def feed
    Micropost.where("user_id = ?", id)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed: other_user)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end

end
