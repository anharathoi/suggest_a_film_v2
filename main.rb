require 'csv'
require 'json'

class Movie
  attr_accessor :id, :title
  def initialize(id, title)
    @id = id
    @title = title
    @genres = []
    @number_of_times_rated = 0
  end
end

class User
  def initialize(id)
    @id = id
  end
end


################### ALL movies ######################
ALL_MOVIES = CSV.read('./movies.csv', {headers: true, header_converters: :symbol})

movie_instances = []

ALL_MOVIES.each do |lines|
  movie_instance = Movie.new(lines[:movieid], lines[:title])
  # p lines[:title]
  movie_instances << movie_instance
end

################### Top rated movies ######################
MOST_RATED = File.read('./most_rated_movies.json')
top_rated_100_movies = JSON.parse(MOST_RATED, {:symbolize_names => true})

# p top_rated_100_movies.class
# top_rated_100_movies.each_with_index do |item, i|
#   # puts """
#   # =============== #{i+1} ===================
#   # Movie ID: #{item[:movieid]}
#   # Title: #{item[:title]}
#   # Number of times rated: #{item[:number_of_times_rated]}
#   # ==========================================
#   # """
# end

# p movie_instances

p movie_instances[0].title