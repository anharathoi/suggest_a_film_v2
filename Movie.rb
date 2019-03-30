require 'pg'
require 'csv'

# DATABASE connection
connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')

# # Create movie table
connection.exec("DROP TABLE IF EXISTS movies")
connection.exec( "CREATE TABLE MOVIES(id INTEGER PRIMARY KEY, title TEXT, genres TEXT ARRAY)")

################## ALL movies ######################
ALL_MOVIES = CSV.read('./movies.csv', {headers: true, header_converters: :symbol})
movie_instances = []

ALL_MOVIES.each do |lines|
  id = lines[:movieid].to_i
  title = lines[:title]
  genres = lines[:genres].split('|')

  # movie_instance = Movie.new(id, title, genres)

  title = title.include?("'") ? title.gsub("'", "/'") : title
  # p title

  connection.exec "INSERT INTO Movies (id, title, genres) VALUES(#{id}, '#{connection.escape_string(title)}', '{#{genres.join(',')}}')"
  
end
