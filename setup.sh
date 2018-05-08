#!/usr/bin/env bash

 echo ===============get out of cp-aws directory=====================
 cd ..

 echo ==================updating ubuntu repositories==================
 sudo apt-get update

 echo ==================adding python3.6 repository==================
 sudo add-apt-repository -y ppa:deadsnakes/ppa

 echo ==================updating ubuntu repositories==================
 sudo apt-get update

 echo ========================install python3.6========================
 sudo apt-get install -y python3.6

 echo ============make python3.6 as default for python3===============
 sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
 sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 10
 sudo update-alternatives --config -y python3

 echo ===============install gunicorn, pip and nginx==================
 sudo apt-get install -y python3-pip nginx python3.6-gdbm

 echo ==================installing virtualenv========================
 pip3 install virtualenv

 echo ===============creating the virtual environment===============
 virtualenv -p python3 env

 echo ============activating the virtual environment===============
 source env/bin/activate

 echo ==================Cloning the project repo=====================
 git clone -b api_defence https://github.com/Thegaijin/RecipeAPI.git

 echo ==================Entering the project folder==================
 cd RecipeAPI

 echo ============installing all the project requirements============
 pip3 install -r requirements.txt

 echo ========================start nginx===========================
 sudo systemctl start nginx
 sudo systemctl status nginx


echo ========================configure nginx========================
sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/recipe
server {
listen 80;
    location / {
        proxy_pass http://127.0.0.1:8000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF'

echo ==================remove default nginx config==================
sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo ===============Create symlink to sites=enabled==================
sudo ln -s /etc/nginx/sites-available/recipe /etc/nginx/sites-enabled/

echo =====================restart nginx==============================
sudo systemctl restart nginx
sudo systemctl status nginx

echo ==================create app systemd service=====================
sudo bash -c 'cat <<EOF > /etc/systemd/system/recipe.service
[Unit]
Description=gunicorn instance to serve recipe
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/RecipeAPI
Environment="PATH=/home/ubuntu/env/bin"
ExecStart=/home/ubuntu/env/bin/gunicorn --access-logfile RecipeAPI.manage:app

[Install]
WantedBy=multi-user.target
EOF'

# echo ======Creating script to start env and load environment variables on instance reboot ===============
# sudo cat <<EOF > /home/ubuntu/startenv.sh
# #!/usr/bin/env bash

# source env/bin/activate
# source /home/ubuntu/.env
# EOF

# echo ================== convert to executable =====================
# chmod +x startenv.sh


# echo ==================create systemd service to start virtualenv =====================
# sudo bash -c 'cat <<EOF > /etc/systemd/system/recipe.service
# [Unit]
# Description=Start virtualenv and load environment variables on reboot
# After=network.target
# [Service]
# User=ubuntu
# Group=www-data
# WorkingDirectory=/home/ubuntu
# ExecStart=/home/ubuntu/startenv.sh
# RemainAfterExit=true
# [Install]
# WantedBy=multi-user.target
# EOF'

echo ========================Start the service========================
sudo systemctl start recipe
sudo systemctl enable recipe

echo ===========================Create .env file=====================
sudo cat <<EOF > /home/ubuntu/\.env
export SECRET_KEY='wqrtaeysurid6lr7'
export FLASK_CONFIG=development
export DATABASE_URL='postgresql://thegaijin:12345678@cp3-db-instance.cjfdylbgjjyu.us-west-2.rds.amazonaws.com:5432/recipe_db'
EOF

echo ==================Loading environment variables==================
source /home/ubuntu/.env

===========================echo start the app========================
gunicorn manage:app
