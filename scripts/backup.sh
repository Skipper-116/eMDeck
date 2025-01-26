#!/bin/bash
echo "Backing up MySQL databases..."

# Run the backup processes in parallel
docker exec mysql /usr/bin/mysqldump -u root -p${MYSQL_ROOT_PASSWORD} emr_db >./dumps/emr_db.sql &
docker exec mysql /usr/bin/mysqldump -u root -p${MYSQL_ROOT_PASSWORD} dde_db >./dumps/dde_db.sql &

# Wait for all background processes to complete
wait

# Compress the backup files in parallel
gzip ./dumps/emr_db.sql &
gzip ./dumps/dde_db.sql &

# Wait for all background processes to complete
wait

echo "Backup complete!"
