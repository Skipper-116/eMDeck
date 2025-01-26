#!/bin/bash
echo "Restoring MySQL databases..."

# Uncompress the backup files in parallel we can use pv to show progress
pv ./dumps/emr_db.sql.gz | gunzip | docker exec -i mysql /usr/bin/mysql -u root -p${MYSQL_ROOT_PASSWORD} emr_db &
pv ./dumps/dde_db.sql.gz | gunzip | docker exec -i mysql /usr/bin/mysql -u root -p${MYSQL_ROOT_PASSWORD} dde_db &

# Wait for all background processes to complete
wait

echo "Restore complete!"
