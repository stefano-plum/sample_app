# Create a main sample user.
User.create!(name: "Example User",
             username: "ExampleUser",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# Generate a bunch of additional users.

99.times do |n|
  Faker::Config.locale = :en
  first_name = Faker::Name.first_name
  last_name  = Faker::Name.last_name
  name = "#{first_name} #{last_name}"
  username = "#{first_name}#{last_name}"
  puts username
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               username: username,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end