#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./files
chmod -R 777 ./files

sed -i "s~URL_TO_CHANGE~${DOMAIN}~g" ./misskey/.config/default.yml
sed -i "s~DB_USER_TO_CHANGE~${POSTGRES_USER}~g" ./misskey/.config/default.yml
sed -i "s~DB_PASSWORD_TO_CHANGE~${POSTGRES_PASSWORD}~g" ./misskey/.config/default.yml

docker-compose run --rm web pnpm run init