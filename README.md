# Installation Instructions from Git

* Install RVM on your local machine and install jruby (1.7 or later)
* Clone Servly from github and go into the direction and `bundle install`
* Edit the config/database.yml and set the production section to match your MySQL credentials 
* Run `warble` and you'll get a servly3.war 
* Ghetto db setup: Run `RAILS_ENV=production rake db:migrate`
* Deploy the war to ElasticBeanstalk/Tomcat/Jetty, etc

# Installation instructions via war 

* Download the .war file from the Downloads section
* Unpack and edit the database config and run the migrations
