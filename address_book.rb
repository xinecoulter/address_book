# use this code to create an address book in sinatra
# create an input form
# add a person
# list people
require 'pg'
require 'pry'

puts "Hey gurl"

# get all the inputs
# put them in the string
# make it work

# this establishes a connection to the database
# db = PG.connect(:dbname => 'address_book',
#   :host => 'localhost')
# executing sql code
# passing a string of sql to the database

# insert into database
db = PG.connect(:dbname => 'address_book',
  :host => 'localhost')

puts "what's your name girl?"
name = gets.chomp
sql = "insert into contacts (first) values ('#{name}')"
db.exec(sql)
sql = "select first, age from contacts"
db.exec(sql) do |result|
  result.each do |row|
    puts row
  end
end
# db.close
db.close

# reads from database
# db = PG.connect(:dbname => 'address_book',
#   :host => 'localhost')
# sql = "select first, age from contacts"
# db.exec(sql) do |result|
#   result.each do |row|
#     puts row
#   end
# end
# db.close