class User < ApplicationRecord

    VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    VALID_USERNAME_REGEX = /\A[a-z0-9_-]{0,50}\z/i
    attr_accessor :remember_token
    before_save :to_dwcase
    # Password
    has_secure_password
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: true
    validates :username, presence: true, length: { maximum: 50 },
            format: { with: VALID_USERNAME_REGEX } ,uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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

    def authenticated?(remember_token)
        if remember_digest.nil?
            return false
        else 
            BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
        end
    end

    # Returns a session token to prevent session hijacking
    # We reuse the remember digest for convenience. 
    def session_token
        remember_digest || remember
    end
    private
    
        def to_dwcase
            self.email.downcase!
            self.username.downcase!
        end
end

