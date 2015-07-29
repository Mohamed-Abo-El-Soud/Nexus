# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Account.create!(first_name: "Example",
              last_name: "User",
              email: "example@railstutorial.org",
              telephone: "41683229083",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now)
               

99.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  Account.create!(first_name: first_name,
                last_name: last_name,
                email: email,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

accounts = Account.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.word
  content = Faker::Lorem.sentence(5)
  accounts.each { |account| account.messages.create!(reciever_id: 0, title: title, content: content) }
end