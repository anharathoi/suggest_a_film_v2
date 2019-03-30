require 'pg'
require 'json'
require 'pry'

# # DATABASE connection
connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')

scores = {}
connection.exec "select * from ratings" do |data|
  data.each do |row|
    scores["#{row["user_id"]}"] = {}
# {"id"=>"7768", "movie_id"=>"81591", "user_id"=>"48", "movie_rating"=>"4.0"}
# {"id"=>"7769", "movie_id"=>"81845", "user_id"=>"48", "movie_rating"=>"3.5"}

# binding.pry
  end
end

# p ratings
# p scores

puts "BEGINNING QUERY TIME: #{Time.now}"
scores.map do |k,v|
  connection.exec "select * from ratings" do |data|
    data.each do |row|
      k != row["user_id"] ? next : v["#{row["movie_id"]}"] = row["movie_rating"].to_f
    end
  end
  # binding.pry
end
# p scores
File.open('./all_movies.json', "w") do |file|
  file.write(scores.to_json)
end
puts "END QUERY TIME: #{Time.now}"