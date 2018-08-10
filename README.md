# README

This an implementation of Salt Edge test task

In order to run locally this app, you can simply clone it from this github repo.
You might need to generate a public/private RSA key pair which you can do following:
openssl genrsa -out private.pem 2048
openssl rsa -pubout -in private.pem -out public.pem

and then replace the existing files, which i've added to the repo. Obviously you must have 
an Salt Edge account to use your app and secret keys.

Then run `bundle install`

After that run `bundle exec figaro install` and put into your config/application.yml file 
your API credentials in that manner
salt_edge_app_id : 
salt_edge_secret: 

After that your app will be operational and ready to test
Good testing...)

