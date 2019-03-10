require 'csv'
require 'json'

###### Movies database ######
movies_table = CSV.table('movies.csv')

movies_array = movies_table.map do |row|
  row.to_h
end

# puts movies_array[0..2] # each data looks like this => {:movieid=>2, :title=>"Jumanji (1995)", :genres=>"Adventure|Children|Fantasy"}


###### Ratings database ######
ratings_table = CSV.table('ratings.csv')

ratings_array = ratings_table.map do |row|
  row.to_h
end
# p ratings_array # each data loooks like this => {:userid=>1, :movieid=>1343, :rating=>2.0, :timestamp=>1260759131}

##### Top rated movies #####
# go through the ratings array and make an array of movie_ids so that the movie_ids rated the most times can be counted
movie_count_array = []
ratings_array.each do |k|
  movie_count_array << k[:movieid]
end
puts movie_count_array.sort!
# sort and make a hash {movieid: title, times_rated: count}


######  make hash of user with movie ratings ######
# all_ratings = {
#   user_id1: {
#     movieid: rating,
#     movieid: rating,
#   },
#   user_id2: {
#     movieid: rating,
#     movieid: rating,
#   }
#   user_id3: {
#     movieid: rating,
#     movieid: rating,
#   }
# }
# Pearson.recommendations(combined_hash, '5000')
# 5000 is the user input hash