require 'pg'
require 'csv'

class User
  attr_accessor :id
  def initialize(id)
    @id = id
  end
end

# DATABASE connection
connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')

# Create user table
# connection.exec("DROP TABLE IF EXISTS users")
# connection.exec("CREATE TABLE users(id INTEGER PRIMARY KEY)")


ALL_USERS = CSV.read('./ratings.csv', {headers: true, header_converters: :symbol})

all_user_entries = []

ALL_USERS.each do |lines|
  # saves all the users from the ratings db
  id = lines[:userid]
  all_user_entries << id
end

unique_user_ids = all_user_entries.uniq

######## All user instances ########
unique_user_instances = unique_user_ids.map do |user_id|
  connection.exec "INSERT INTO users VALUES(#{user_id})"
  #  User.new(user_id)
end