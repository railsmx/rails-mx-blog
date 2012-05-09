#
# The itiel gem is work in progress, this was just a test
#
# In order to run it, the itiel and different database connector
# gems must be on the Gemfile.
#
# Then, you can just
#
#     bundle exec ruby itiel/posts.rb
#
require 'itiel'

# Loads the Rails environment
require ::File.expand_path('../../config/environment',  __FILE__)


# Create an extractor with a custom SQL script
@posts = Itiel::Extractor::CustomSQL.new
@posts.connection = :legacy
@posts.script = <<-EOS
            SELECT posts.title, posts.content, posts.created_at,
              users.email, users.login FROM posts
              LEFT JOIN users ON
                posts.user_id = users.id;
            EOS

# Some of the emails must be mapped to a different thing
@mapper = Itiel::Transformation::MapValues.new(
    { :email => {
      "david@crowdint.com" => "david.padilla@crowdint.com",
      "chalofa@gmail.com" => "gonzalo.fernandez@crowdint.com"
    } }
)

# Loader
@csv = Itiel::Loader::CSVFile.new 'posts.csv', false

# Set up the stream flow
@posts.next_step  = @mapper
@mapper.next_step = @csv

# Start
@posts.start

# Process the result
# TODO: There should be a way to create a step on Itiel
# that receives a block of Ruby code and does this task:
#
CSV.foreach('posts.csv', headers: true) do |row|
  author = User.find_or_create_by_email(row['email'], row['login'])
  post = Post.new
  post.title = row['title']
  post.body = row['content']
  post.published_at = row['created_at']
  post.author = author
  post.regenerate_permalink
  post.save!

  post.publish!
end
