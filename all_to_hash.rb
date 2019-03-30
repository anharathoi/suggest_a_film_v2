require 'pg'
require 'json'
require 'pry'

# # DATABASE connection
connection = PG::Connection.open(:dbname => 'movie_project', :user => 'athoi')

scores = {}
connection.exec "select * from ratings" do |data|
  data.each do |row|
    scores["#{row["user_id"]}"] = {}
  end
end

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
  file.write(JSON.pretty_generate(scores))
end
puts "END QUERY TIME: #{Time.now}"