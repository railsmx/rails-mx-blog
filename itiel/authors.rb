require 'itiel'

require ::File.expand_path('../../config/environment',  __FILE__)

@authors = Itiel::Extractor::CustomSQL.new
@authors.connection = :legacy
@authors.script = <<-EOS
                SELECT DISTINCT users.email, users.login AS name FROM posts
                  LEFT JOIN users ON
                    posts.user_id = users.id;
                EOS

@mapper = Itiel::Transformation::MapValues.new(
    { :email => {
      "david@crowdint.com" => "david.padilla@crowdint.com",
      "chalofa@gmail.com" => "gonzalo.fernandez@crowdint.com"
    } }
)

@csv = Itiel::Loader::CSVFile.new 'authors.csv', false

@authors.next_step = @mapper
@mapper.next_step = @csv

@authors.start

CSV.foreach 'authors.csv', headers: true do |row|
  user = User.find_or_create_by_email row['email'], :name => row['name']
end
