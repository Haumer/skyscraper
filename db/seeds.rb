# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Job.all.each do |e|
  e.destroy
end

Job.create(
  title: "Something",
  search_id: 1,
  salary: "10.000",
  location: "london",
  company: "Someone")

Job.create(
  title: "Something",
  search_id: 1,
  salary: "10.000",
  location: "london",
  company: "Someone")
