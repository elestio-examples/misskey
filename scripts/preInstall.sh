#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./files
chmod -R 777 ./files

cat <<EOT > ./servers.json
{
    "Servers": {
        "1": {
            "Name": "local",
            "Group": "Servers",
            "Host": "172.17.0.1",
            "Port": 8073,
            "MaintenanceDB": "postgres",
            "SSLMode": "prefer",
            "Username": "postgres",
            "PassFile": "/pgpass"
        }
    }
}
EOT

sed -i "s~URL_TO_CHANGE~${DOMAIN}~g" ./misskey/.config/default.yml
sed -i "s~DB_USER_TO_CHANGE~${POSTGRES_USER}~g" ./misskey/.config/default.yml
sed -i "s~DB_PASSWORD_TO_CHANGE~${POSTGRES_PASSWORD}~g" ./misskey/.config/default.yml

docker-compose run --rm web pnpm run init

