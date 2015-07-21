# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Account.create(first_name: "Example",
               last_name: "User",
               email: "example@railstutorial.org",
               telephone: "41683229083",
               password: "foobar",
               password_confirmation: "foobar")