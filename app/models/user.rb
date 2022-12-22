  class User < ApplicationRecord
    # Constants
    VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    VALID_USERNAME_REGEX = /\A[a-z0-9_-]{0,50}\z/i

    # Micropost association
    has_many :microposts, dependent: :destroy

    # Before actions 
    before_save :to_dwcase
    before_create :create_activation_digest

    # Password
    has_secure_password
    
    # Validations
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, 
    format: { with: VALID_EMAIL_REGEX }, 
    uniqueness: true
    validates :username, presence: true, length: { maximum: 50 },
    format: { with: VALID_USERNAME_REGEX } ,uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    
    attr_accessor :remember_token, :activation_token, :reset_token

    class << self

        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                          BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        def new_token
            SecureRandom.urlsafe_base64
        end
        
    end

    # Remembers a user in the database for use in persisten sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end

    def authenticated?(attribute, token)
      digest = self.send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

    # Returns a session token to prevent session hijacking
    # We reuse the remember digest for convenience. 
    def session_token
        remember_digest || remember
    end

    # Activates an account.
    def activate
      update_columns(activated: true, activated_at: Time.zone.now)
    end

    # Sends activation email.
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    def create_reset_digest
      self.reset_token = User.new_token
      update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
    end
    
    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end
  
    def feed 
      Micropost.where("user_id = ?", id)
    end

    private

        def to_dwcase
            self.email.downcase!
            self.username.downcase!
        end

        def create_activation_digest
          self.activation_token = User.new_token
          self.activation_digest = User.digest(activation_token)
        end
end

