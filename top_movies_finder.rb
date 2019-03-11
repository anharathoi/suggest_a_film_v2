require 'csv'
require 'json'

###### Movies database ######
MOVIELENS_MOVIE_DATA = CSV.table('movies.csv')
movies_array = MOVIELENS_MOVIE_DATA.map do |row|
  row.to_h
end
# p movies_array[0]
###### Ratings database ######
MOVIELENS_USER_DATA = CSV.table('ratings.csv')
ratings_array = MOVIELENS_USER_DATA.map do |row|
  row.to_h
end
# p ratings_array

def list_most_rated_movies(user_rating_data, number_of_movies_to_be_listed)
  movie_ids_from_user_inputs =  user_rating_data.map do |user_rating_entry|
    user_rating_entry[:movieid]
  end
  movie_count_db = Hash.new(0)
  movie_ids_from_user_inputs.each do |movie_id|
    movie_count_db[movie_id] += 1
  end
  movies_sorted = movie_count_db.sort_by {|key, value| -value}
  movies_selected = movies_sorted[0...number_of_movies_to_be_listed]
end

top_100_most_rated_movies_id = list_most_rated_movies(ratings_array, 100)
top_20_most_rated_movies_id = list_most_rated_movies(ratings_array, 20)
# p top_100_most_rated_movies
# p top_20_most_rated_movies.length

def make_most_rated_movies_hash_including_movie_title(most_rated_movies_id_array, all_movies_array)
  top_rated_titles = []
  most_rated_movies_id_array.each do |movie|
    movie_id = movie[0]
    all_movies_array.each do |movie_hash|
      # p movie_hash
      if movie_id == movie_hash[:movieid]
        my_movie_hash = {
            movieid: movie_hash[:movieid],
            title: movie_hash[:title],
            number_of_times_rated: movie[1]
          }
        top_rated_titles << my_movie_hash
      end
    end
  end
  top_rated_titles
end

top_20_most_rated_movies = make_most_rated_movies_hash_including_movie_title(top_20_most_rated_movies_id, movies_array)
p top_20_most_rated_movies


# used the following code to write to file for later use
# File.open('./most_rated_movies.json', "w") do |file|
#   file.write(top_rated_movies.to_json)
# end