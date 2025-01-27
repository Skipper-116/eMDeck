#!/bin/bash

echo "Migrating the EMR API Rails application..."
# in the container, we have the ./bin/update_art_metadata.sh developemt script that will update the metadata and run migrations
docker exec emr /bin/bash -c "./bin/update_art_metadata.sh development"

echo "Migrating the DDE Rails application..."
docker exec dde /bin/bash -c "bundle exec rake db:migrate"

echo "Migration complete!"
