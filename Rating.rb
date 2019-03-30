require 'pg'
require 'csv'

# DATABASE connection
connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')

# # Create ratings table
connection.exec("DROP TABLE IF EXISTS ratings")
connection.exec("CREATE TABLE RATINGS(id SERIAL PRIMARY KEY, movie_id INT REFERENCES movies, user_id INT REFERENCES users, movie_rating DECIMAL)")

all_rating_entries = []

ALL_RATINGS = CSV.read('./ratings.csv', {headers: true, header_converters: :symbol})
# rating_id(pk) movie_id(fk) user_id(fk)


ALL_RATINGS.each_with_index do |lines, i|
  # find movie_id from movie sqldb
  # p lines
  user_id = lines[:userid].to_i
  movie_id = lines[:movieid].to_i
  movie_rating = lines[:rating].to_f

  connection.exec("INSERT INTO ratings (id, movie_id, user_id, movie_rating) VALUES
  (DEFAULT,(SELECT id FROM movies WHERE id=#{movie_id}),(SELECT id FROM users WHERE id=#{user_id}), #{movie_rating})")
end


