Monsoon Gem
=======================

Monsoon is a MongoDB backup tool that allows you to take backups and store them in Amazon S3.


Usage
-----

To install:

    gem install monsoon

To Configure:

    Monsoon.configure do |config|
      config.bucket = "mongo_backups"
      config.key = "my_super_secret_aws_key"
      config.secret = "my_super_secret_aws_secret"
      config.mongo_uri = "mongodb://user:password@test.mongohq.com:10036/add_development"
    end

To use:

    Monsoon.perform


Requirements
----

`mongodump` must be installed on the system and available from anywhere on in the console.

The gem also utilizes `tar` to compress the back so this, too, must be accessible form the command line.
  
Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).

