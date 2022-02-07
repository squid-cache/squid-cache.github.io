Describe EliezerCroitoru/Certbot here.

Link to certbot integration with squid:
[](https://community.letsencrypt.org/t/squid-reverse-proxy-ssl/69625/6)

Crontab example:

    0 */12 * * *    certbot certonly --standalone --preferred-challenges http --http-01-port 5555 --deploy-hook 'systemctl reload squid' --domains example.org,www.example.org,www1.example.org
