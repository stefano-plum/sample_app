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
  username = "#{first_name}#{last_name}"
  username.gsub("'", "")if username.include? "'"
  name = "#{first_name} #{last_name}"
  puts "#{n+1} #{username}"
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

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end


# Create following ralationships.
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }