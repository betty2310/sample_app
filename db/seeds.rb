# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(name: "Admin",
             email: "admin@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
User.create!(name: "Huynh Duong",
             email: "huynhduongsh1@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
98.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.org"
  password = "123456"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Generate microposts for a subset of users.
users = User.order(:created_at).take(6)

10.times do
  content = Faker::Lorem.sentence(word_count: 10)
  users.each { |user| user.microposts.create!(content: content) }
end

# Create following relationships.
users = User.all
user = users.find_by(id: 2)
following = users[4..28]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}
