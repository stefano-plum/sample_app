class User < ApplicationRecord
    VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

    before_save :email_to_dwcase
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX }, 
            uniqueness: true
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }
    # Preguntar porque en el tutorial no valida el password_confirmation, vale la pena validarlo?
    validates :password_confirmation, presence: true, length: { minimum: 6 }
    
    def email_to_dwcase
        email.downcase!
    end
end

