require 'rubygems'
require 'pg'
require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?


# Function to retrieve contact info
def get_contacts
  contacts_hash = {}
  # this line establishes a connection to the database
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')
  # executes sql code
  # passes a string of sql to the address database
  db.exec( "select first, last, age, gender, dtgd, phone from contacts") do |result|
    result.each do |row|
      contact = row["first"]
      contacts_hash[contact] = row
    end
  end
  return contacts_hash
  # returns a hash of hashes...of hashes. 3D hashes!!
end

get_contacts
binding.pry

# This should list all the contact info
# get '/' do

# end