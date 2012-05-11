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

# Ruby script to create Post and User models
# with the data extracted from the legacy database
@script = Itiel::Scripting::RubyScript.new do |row|
  author = User.find_or_create_by_email(row[:email], row[:login])
  post = Post.new(
    :title        => row[:title],
    :body         => row[:content],
    :published_at => row[:created_at],
    :author       => author
  )
  post.regenerate_permalink
  post.save!

  post.publish!
end

# Loader
@csv = Itiel::Loader::CSVFile.new 'posts.csv', false

# Set up the stream flow
@posts >> @mapper >> @script >> @csv

# Start
@posts.start
