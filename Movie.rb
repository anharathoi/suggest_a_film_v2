require 'pg'
require 'csv'

class Movie
  attr_accessor :id, :title, :genres
  def initialize(id, title, genres)
    @id = id
    @title = title
    @genres = genres
    @number_of_times_rated = 0
  end
end

# DATABASE connection
# connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')

# # Create movie table
# connection.exec("DROP TABLE IF EXISTS movies")
# connection.exec( "CREATE TABLE MOVIES(id INTEGER PRIMARY KEY, title TEXT, number_of_times_rated INTEGER, genres TEXT ARRAY)")

################## ALL movies ######################
ALL_MOVIES = CSV.read('./movies.csv', {headers: true, header_converters: :symbol})
movie_instances = []

ALL_MOVIES.each do |lines|
  id = lines[:movieid].to_i
  title = lines[:title]
  genres = lines[:genres].split('|')
  number_of_times_rated = 0

  # p lines
  # p title
  # p genres
  # movie_instance = Movie.new(id, title, genres)

  # title = title.include?("'") ? title.gsub("'", "/'") : title
  # p titlerub

  # connection.exec "INSERT INTO Movies VALUES(#{id}, '#{connection.escape_string(title)}', #{number_of_times_rated}, '{#{genres.join(',')}}')"
  
  # movie_instances << movie_instance
  # id == 2 ? movie_instances : next # for test purposes
end

# p movie_instances[0].genres
