# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Creating Admin Account...'

User.create(
  username: 'admin',
  email: 'admin@fake.com',
  password_digest: BCrypt::Password.create('password'),
  is_admin: true
)

puts 'Admin Account Created.'

puts 'Seeding Users...'

100.times do
  User.create(
    username: Faker::Internet.unique.username,
    email: Faker::Internet.unique.email,
    password_digest: BCrypt::Password.create('password')
  )
end

puts 'Seeding Users done.'

puts 'Seeding Slangs...'

user_slangs = User.all

user_slangs.each do |user_slang|
  Slang.create(
    user_id: user_slang.id,
    word: Faker::Hipster.word,
    definition: Faker::TvShows::SiliconValley.quote,
    is_approved: [true, false].sample
  )

  Slang.create(
    user_id: user_slang.id,
    word: Faker::Hipster.word,
    definition: Faker::TvShows::SiliconValley.quote,
    is_approved: [true, false].sample
  )
end

puts 'Seeding Slangs done.'