#!/usr/bin/env bash


setupEnvrionment () {
    printf '===========================Setup the environment=============================='

    cd ..
    sudo apt-get update
    sudo apt-get install software-properties-common
    sudo add-apt-repository -y ppa:certbot/certbot
    sudo apt-get update
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
    sudo apt-get install -y nodejs npm nginx python-certbot-nginx build-essential
}

setupApp () {
    printf '===========================Setup the Application =============================='
    git clone -b ch-tests-156145809 https://github.com/Thegaijin/reacipe.git
    cd reacipe
    npm install
}


configureNginx () {
    printf '================================= Configure nginx =============================='

    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default
    server {
        server_name thegaijin.xyz www.thegaijin.xyz;
        location / {
            proxy_pass http://127.0.0.1:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_redirect off;
        }
    }
    EOF'

    sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo systemctl status nginx
    sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
}

configureCertbort () {
    sudo certbot --nginx
}

startApp () {
    npm start
}

run () {
    setupEnvrionment
    setupApp
    configureNginx
    configureCertbort
    startApp
}

run