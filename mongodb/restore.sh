HOST=$1
PORT=$2
MONGODB_DBNAME=$3
PATH=$4

sudo mongorestpre -h "$HOST:$PORT" -d $MONGODB_DBNAME --dir $PATH
