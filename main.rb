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
  db.exec("select first, last, age, gender, dtgd, phone from contacts") do |result|
    result.each do |row|
      contact = row["first"]
      contacts_hash[contact] = row
    end
  end
  db.close
  return contacts_hash
  # returns a hash of hashes...of hashes. 3D hashes!!
  # example:
  # {"max"=>
  #  {"first"=>"max",
  #   "last"=>"coulter",
  #   "age"=>"28",
  #   "gender"=>"m",
  #   "dtgd"=>"f",
  #   "phone"=>"434-604-4401"},
  #   "david"=>
  #   {"first"=>"david",
  #   "last"=>"fischer",
  #   "age"=>"30",
  #   "gender"=>"m",
  #   "gender"=>"m",
  #   "dtgd"=>"t",
  #   "phone"=>"555-555-5555"}}
end

# get_contacts
# binding.pry

# This should list all the contacts
get '/' do
  @contacts = get_contacts
  erb :contacts
end

# This should show a single contact with contact info
get '/contact/:name' do
  @name = params[:name]
  @contacts = get_contacts
  @first = @contacts[@name]["first"]
  @last = @contacts[@name]["last"]
  @age = @contacts[@name]["age"]
  @gender = @contacts[@name]["gender"]
  @dtgd = @contacts[@name]["dtgd"]
  @phone = @contacts[@name]["phone"]
  erb :contact
end

# This page should have a form to add a new contact, which will POST to /new_contact
get '/new_contact' do
  erb :new_contact
end

# This should create a new contact and add to the database
post '/new_contact' do
  @first = params[:first]
  @last = params[:last]
  @age = params[:age]
  @gender = params[:gender]
  @dtgd = params[:dtgd]
  @phone = params[:phone]

  sql_age = @age.to_i

  if @dtgd == "yes"
    sql_dtgd = true
  else
    sql_dtgd = false
  end

  # database connection
  db = PG.connect(:dbname => 'address_book', :host => 'localhost')

  # string of sql to be passed to the address database
  sql = "insert into contacts (first, last, age, gender, dtgd, phone) values ('#{@first}', '#{@last}', #{sql_age}, '#{@gender}', #{sql_dtgd}, '#{@phone}')"
  db.exec(sql)
  db.close

  redirect to("/contact/#{@first}")
end

