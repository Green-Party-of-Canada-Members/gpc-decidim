#!/bin/bash

echo -e "\e[33mChecking database status..."

cd /app

if [ -z "$SIDEKIQ_WORKER" ]; then
	if bin/rails db:migrate; then
	  echo -e "\e[32mDatabase migrations up to date."
	else
		if [ "$RAILS_ENV" == "development" ]; then
		  echo -e "\e[31mMigration failed. Installing database"
		  echo -e "\e[31mInstalling development gems..."
			bundle install
		  echo -e "\e[31mCreating database"
		  bin/rails db:create
		  echo -e "\e[33mInstalling the schema..."
		  bin/rails db:schema:load
		  echo -e "\e[32mDatabase just created so let's seed some data..."
		  SEED=true bin/rails db:seed
		else
			echo -e "\e[31mMigration failed. Aborting in $RAILS_ENV mode."
			exit 1
		fi
	fi

	bundle exec puma -C config/puma.rb
else
	bundle exec sidekiq -C config/sidekiq.yml
fi