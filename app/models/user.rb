class User < ApplicationRecord
    VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    VALID_USERNAME_REGEX = /\A[a-z0-9_]{4,16}\z/i
    before_save :to_dwcase
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: true
    validates :username, presence: true, length: { maximum: 50 },
            format: { with: VALID_USERNAME_REGEX } ,uniqueness: true
            
    # Password
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    # Preguntar porque en el tutorial no valida el password_confirmation, vale la pena validarlo?
    validates :password_confirmation, presence: true, length: { minimum: 6 }
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    private
    
        def to_dwcase
            email.downcase!
            username.downcase!
        end
end

