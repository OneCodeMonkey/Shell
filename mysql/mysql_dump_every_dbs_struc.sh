TIMESTAMP=$(date +"%F")
BACKUP_DIR="./sql_only_structure/"
MYSQL_USER=$1
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD=$2
MYSQL_HOST=$3
MYSQLDUMP=/usr/bin/mysqldump

mkdir -p "$BACKUP_DIR"

if [ -z "$MYSQL_HOST" ]
then
    MYSQL_HOST="127.0.0.1"
fi

databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema)"`

for loop in 5 4 3 2 1
do
    echo "will begin dumping in $loop s..."
    sleep 1
done

count=0;
for db in $databases; do
    echo "dumping database: $db..."
    $MYSQLDUMP --force --opt --no-data --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $db > "$BACKUP_DIR/$db.sql"
    count=`expr $count + 1`
    echo "dumping database $db completed!"
done
echo "finished dumping $count databases."