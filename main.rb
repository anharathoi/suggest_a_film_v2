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
  attr_accessor :id
  def initialize(id)
    @id = id
  end
end

class Rating
  def initialize(user, movie)
    @user = user
    @movie = movie
    @id = "#{user.id}_#{movie.id}"
  end
end


################### ALL movies ######################
ALL_MOVIES = CSV.read('./movies.csv', {headers: true, header_converters: :symbol})

movie_instances = []

ALL_MOVIES.each do |lines|
  movie_instance = Movie.new(lines[:movieid], lines[:title])
  # p lines
  movie_instances << movie_instance
end
# p movie_instances
################### ALL users and ratings ######################
ALL_USERS = CSV.read('./ratings.csv', {headers: true, header_converters: :symbol})

all_user_entries = []
all_rating_entries = []

ALL_USERS.each do |lines|
  # saves all the users from the ratings db
  all_user_entries << lines[:userid]

  # saves all the entries of ratings
  all_rating_entries << lines
end

unique_user_ids = all_user_entries.uniq

######## All user instances ########
unique_user_instances = unique_user_ids.map do |user_id|
   User.new(user_id)
end
# p unique_users_instances.length
# p unique_user_instances[0].id

######## All rating instances ########
# at the moment it's taking about a minute
# p all_rating_entries.length
# begin_time = Time.now
# puts "================================="
# puts "begin #{begin_time}"

rating_instances = all_rating_entries.map do |rating_entries|
  begin_time = Time.now
  # find the user instance
  user_id = rating_entries[:userid]
  user_instance = unique_user_instances.detect {|user_instance| user_instance.id == user_id}

  # find the movie instance
  movie_id = rating_entries[:movieid]
  movie_instance = movie_instances.detect {|movie_instance| movie_instance.id == movie_id}
  # Rating.new
  Rating.new(user_instance, movie_instance)
end
end_time = Time.now
# puts "================================="
# puts "end #{end_time}"
# puts "================================="
# # p rating_instances[0..10]
# puts "time taken fo rating instances = #{(end_time - begin_time)}"

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

# p movie_instances[0].title
# p movie_instances[1].title