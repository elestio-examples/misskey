#set env vars
set -o allexport; source .env; set +o allexport;

mkdir -p ./storage
mkdir -p ./storage/misskey
mkdir -p ./storage/misskey/.config
chown -R 1000:1000 ./storage
mkdir -p ./storage/files
chmod -R 777 ./storage/files

apt install jq -y

cat <<EOT > ./storage/misskey/.config/default.yml
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Misskey configuration
#━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

#   ┌─────┐
#───┘ URL └─────────────────────────────────────────────────────

# Final accessible URL seen by a user.
url: https://${DOMAIN}

# ONCE YOU HAVE STARTED THE INSTANCE, DO NOT CHANGE THE
# URL SETTINGS AFTER THAT!

#   ┌───────────────────────┐
#───┘ Port and TLS settings └───────────────────────────────────

#
# Misskey requires a reverse proxy to support HTTPS connections.
#
#                 +----- https://example.tld/ ------------+
#   +------+      |+-------------+      +----------------+|
#   | User | ---> || Proxy (443) | ---> | Misskey (3000) ||
#   +------+      |+-------------+      +----------------+|
#                 +---------------------------------------+
#
#   You need to set up a reverse proxy. (e.g. nginx)
#   An encrypted connection with HTTPS is highly recommended
#   because tokens may be transferred in GET requests.

# The port that your Misskey server should listen on.
port: 3000

#   ┌──────────────────────────┐
#───┘ PostgreSQL configuration └────────────────────────────────

db:
  host: db
  port: 5432

  # Database name
  db: misskey

  # Auth
  user: ${POSTGRES_USER}
  pass: ${POSTGRES_PASSWORD}

  # Whether disable Caching queries
  #disableCache: true

  # Extra Connection options
  #extra:
  #  ssl: true

dbReplications: false

# You can configure any number of replicas here
#dbSlaves:
#  -
#    host:
#    port:
#    db:
#    user:
#    pass:
#  -
#    host:
#    port:
#    db:
#    user:
#    pass:

#   ┌─────────────────────┐
#───┘ Redis configuration └─────────────────────────────────────

redis:
  host: redis
  port: 6379
  #family: 0  # 0=Both, 4=IPv4, 6=IPv6
  #pass: example-pass
  #prefix: example-prefix
  #db: 1

#redisForPubsub:
#  host: redis
#  port: 6379
#  #family: 0  # 0=Both, 4=IPv4, 6=IPv6
#  #pass: example-pass
#  #prefix: example-prefix
#  #db: 1

#redisForJobQueue:
#  host: redis
#  port: 6379
#  #family: 0  # 0=Both, 4=IPv4, 6=IPv6
#  #pass: example-pass
#  #prefix: example-prefix
#  #db: 1

#redisForTimelines:
#  host: redis
#  port: 6379
#  #family: 0  # 0=Both, 4=IPv4, 6=IPv6
#  #pass: example-pass
#  #prefix: example-prefix
#  #db: 1

#   ┌───────────────────────────┐
#───┘ MeiliSearch configuration └─────────────────────────────

# You can set scope to local (default value) or global
# (include notes from remote).

#meilisearch:
#  host: meilisearch
#  port: 7700
#  apiKey: ''
#  ssl: true
#  index: ''
#  scope: local

#   ┌───────────────┐
#───┘ ID generation └───────────────────────────────────────────

# You can select the ID generation method.
# You don't usually need to change this setting, but you can
# change it according to your preferences.

# Available methods:
# aid ... Short, Millisecond accuracy
# aidx ... Millisecond accuracy
# meid ... Similar to ObjectID, Millisecond accuracy
# ulid ... Millisecond accuracy
# objectid ... This is left for backward compatibility

# ONCE YOU HAVE STARTED THE INSTANCE, DO NOT CHANGE THE
# ID SETTINGS AFTER THAT!

id: "aidx"

#   ┌─────────────────────┐
#───┘ Other configuration └─────────────────────────────────────

# Whether disable HSTS
#disableHsts: true

# Number of worker processes
#clusterLimit: 1

# Job concurrency per worker
# deliverJobConcurrency: 128
# inboxJobConcurrency: 16

# Job rate limiter
# deliverJobPerSec: 128
# inboxJobPerSec: 32

# Job attempts
# deliverJobMaxAttempts: 12
# inboxJobMaxAttempts: 8

# IP address family used for outgoing request (ipv4, ipv6 or dual)
#outgoingAddressFamily: ipv4

# Proxy for HTTP/HTTPS
#proxy: http://127.0.0.1:3128

proxyBypassHosts:
  - api.deepl.com
  - api-free.deepl.com
  - www.recaptcha.net
  - hcaptcha.com
  - challenges.cloudflare.com

# Proxy for SMTP/SMTPS
#proxySmtp: http://127.0.0.1:3128   # use HTTP/1.1 CONNECT
#proxySmtp: socks4://127.0.0.1:1080 # use SOCKS4
#proxySmtp: socks5://127.0.0.1:1080 # use SOCKS5

# Media Proxy
#mediaProxy: https://example.com/proxy

# Proxy remote files (default: true)
proxyRemoteFiles: true

# Sign to ActivityPub GET request (default: true)
signToActivityPubGet: true
# For security reasons, uploading attachments from the intranet is prohibited,
# but exceptions can be made from the following settings. Default value is "undefined".
# Read changelog to learn more (Improvements of 12.90.0 (2021/09/04)).
#allowedPrivateNetworks: [
#  '127.0.0.1/32'
#]

# Upload or download file size limits (bytes)
#maxFileSize: 262144000
EOT

cat <<EOT > ./storage/servers.json
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

# sed -i "s~URL_TO_CHANGE~${DOMAIN}~g" ./misskey/.config/default.yml
# sed -i "s~DB_USER_TO_CHANGE~${POSTGRES_USER}~g" ./misskey/.config/default.yml
# sed -i "s~DB_PASSWORD_TO_CHANGE~${POSTGRES_PASSWORD}~g" ./misskey/.config/default.yml

docker-compose run --rm web pnpm run init

