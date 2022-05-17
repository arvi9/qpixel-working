#!/bin/bash

# Give database chance to finish creation
sleep 15

# If not created yet
if [ ! -f "/db-created" ]; then
    rails db:create
    rails db:schema:load
    rails r db/scripts/create_tags_path_view.rb
    rails db:migrate
    rails db:migrate RAILS_ENV=development

    rails db:seed
    echo '--First Seed Done --'
    rails r docker/create_admin_and_community.rb
    touch /db-created
    echo '--Touch db created --'
fi

echo '--Second Seed Done --'
# If this isn't done again, there is a 500 error on the first page about posts
rails db:seed
echo '--Starting App port 0 --'
# defaults to port 3000
rails server -b 0.0.0.0
