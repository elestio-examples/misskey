#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 60s;

target=$(docker-compose port web 3000)

# Create account
curl http://${target}/api/admin/accounts/create \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw '{"username":"admin","password":"'${ADMIN_PASSWORD}'"}'

# Login

login=$(curl http://${target}/api/signin \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw '{"username":"admin","password":"'${ADMIN_PASSWORD}'"}')

  access_token=$(echo $login | jq -r '.i' )

# Change smtp

curl http://${target}/api/admin/update-meta \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw '{"enableEmail":true,"email":"'${FROM_EMAIL}'","smtpSecure":false,"smtpHost":"172.17.0.1","smtpPort":25,"smtpUser":null,"smtpPass":null,"i":"'${access_token}'"}'


# Add email

curl http://${target}/api/i/update-email \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw '{"password":"'${ADMIN_PASSWORD}'","token":null,"email":"'${ADMIN_EMAIL}'","i":"'${access_token}'"}'

# Configure admin

curl http://${target}/api/admin/update-meta \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'pragma: no-cache' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw '{"name":"My instance","shortName":null,"description":null,"maintainerName":"admin","maintainerEmail":"'${ADMIN_EMAIL}'","repositoryUrl":"https://github.com/misskey-dev/misskey","impressumUrl":null,"pinnedUsers":[""],"cacheRemoteFiles":false,"cacheRemoteSensitiveFiles":true,"enableServiceWorker":false,"swPublicKey":null,"swPrivateKey":null,"enableFanoutTimeline":true,"enableFanoutTimelineDbFallback":true,"perLocalUserUserTimelineCacheMax":300,"perRemoteUserUserTimelineCacheMax":100,"perUserHomeTimelineCacheMax":300,"perUserListTimelineCacheMax":300,"notesPerOneAd":0,"i":"'${access_token}'"}'