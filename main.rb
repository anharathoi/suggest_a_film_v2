require 'pg'
require 'colorize'
require 'pearson'
require 'json'
require 'pry'

# # DATABASE connection
connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')
# JSON file_load
json_file = File.read('all_movies.json')
scores = JSON.parse(json_file)

# get top 100 movies from the db
top_movies = []
connection.exec "select movie_id, count(*) from ratings group by movie_id order by count DESC" do |result|
  result.each do |row|
    top_movies.length >= 100 ? break : top_movies << row
  end
end
# puts top_movies

top_movies.each do |movie_hash|
  connection.exec "select title from movies where movies.id=#{movie_hash["movie_id"]}" do |res|
    res.each do |movie_row|
      movie_hash["title"] = movie_row["title"]
    end
  end
  top_movies
end


def generate_random_movie(movie_list)
  movie = movie_list[rand(100)]
end


# prompt user, add user to the db
print "Are you an existing user?Please answer y/n: "
response = gets.chomp.downcase

while response != "y" && response != "n"
  puts "Please enter y or n"
  response = gets.chomp.downcase
end
if response == "y"
  puts "Please enter you user_id"
  user_id = gets.chomp.to_i
  current_user_ratings = scores.select{ |k, v| k == user_id.to_s}
  # binding.pry
end
if response == "n"
  user_id = connection.exec("INSERT INTO users VALUES (DEFAULT) returning id")
  puts "Your your id is #{user_id[0]["id"]}"
  user_id = user_id[0]["id"]
  current_user_ratings = {
    "#{user_id}" => {}
  }
  scores["#{user_id}"] = {}
end
# p current_user_ratings

# generate 5 random movies to rate
3.times do
  movie_to_rate = generate_random_movie(top_movies)
  # p movie_to_rate
  puts "Please rate #{movie_to_rate["title"].blue}"
  movie_rating = gets.chomp.to_f
  current_user_ratings["#{user_id}"][movie_to_rate["movie_id"]] = movie_rating
  # binding.pry
  # insert rating to the ratings table in database
  connection.exec("INSERT INTO ratings (id, movie_id, user_id, movie_rating) VALUES
    (DEFAULT,(SELECT id FROM movies WHERE id=#{movie_to_rate["movie_id"]}),(SELECT id FROM users WHERE id=#{user_id}), #{movie_rating})")
end

File.open('./all_movies.json', "w") do |file|
  file.write(JSON.pretty_generate(scores))
end

scores_after_adding_new_user_rating = JSON.parse(json_file)
recommendations = Pearson.recommendations(scores_after_adding_new_user_rating, "#{user_id}")
puts "Here are some movie recommendations for you: "
recommendations.each do |item|
  connection.exec("select title from movies where id=#{item[0].to_i}") do |result|
    result.each do |movie|
      puts "#{movie["title"].blue}"
    end
  end
end
# [["3851", 5.0], ["5477", 5.0], ["95858", 5.0]]
# increase number_of_times_rated in the movie table in db
# create hash for the movie ratings

# compare and share result
# clients.select{|key, hash| hash["client_id"] == "2180" }
# #=> [["orange", {"client_id"=>"2180"}]]
