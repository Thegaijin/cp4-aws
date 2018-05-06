#!/usr/bin/env bash

 echo get out of cp-aws directory
 cd ..

 echo updating ubuntu repositories
 sudo apt-get update

 echo adding python3.6 repository
 sudo add-apt-repository -y ppa:deadsnakes/ppa

 echo updating ubuntu repositories
 sudo apt-get update

 echo install python3.6
 sudo apt-get install -y python3.6

 echo make python3.6 as default for python3
 sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
 sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 10
 sudo update-alternatives --config -y python3

 echo install gunicorn, pip and nginx
 sudo apt-get install -y python3-pip nginx gunicorn

 echo installing virtualenv
 sudo pip3 install virtualenv

 echo creating the virtual environment
 sudo virtualenv -p python3 env

 echo activating the virtual environment
 source env/bin/activate

 echo Cloning the project repo
 git clone -b api_defence https://github.com/Thegaijin/RecipeAPI.git

 echo Entering the project folder
 cd RecipeAPI

 echo installing all the project requirements
 sudo pip3 install -r requirements.txt

 echo start nginx
 sudo systemctl start nginx
 sudo systemctl status nginx

echo copy nginx configurations into the sites available folder
sudo cp /home/ubuntu/cp4-aws/recipe /etc/nginx/sites-available/

echo remove default nginx config
sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo Create symlink to sites=enabled
sudo ln -s /etc/nginx/sites-available/recipe /etc/nginx/sites-enabled/

echo restart nginx
sudo systemctl restart nginx
sudo systemctl status nginx

echo Loading environment variables
export SECRET_KEY='wqrtaeysurid6lr7'
export FLASK_CONFIG=development
export DATABASE_URL='postgresql://thegaijin:12345678@cp3-db-instance.cjfdylbgjjyu.us-west-2.rds.amazonaws.com:5432/recipe_db'

echo start the app
gunicorn manage:app
