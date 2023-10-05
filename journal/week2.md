# Terraform Beginner Bootcamp 2023 - Week 2 :hear_no_evil:

## Working with Ruby

### Bundler

Bundler is a tool that manages gem dependencies for your ruby application. It takes a gemfile as input and installs all the gems listed in the gemfile.

### Install Gems

You need to create a Gemfile and add the gems you want to install. For example:

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you can run `bundle install` to install all the gems listed in the Gemfile.

A Gemfile.lock file will be created after running `bundle install`. This file is used to ensure that the same gems are installed on all machines. It also ensures that the same versions of the gems are installed.

### Run Ruby Scripts in the context of Bundler

You can run ruby scripts in the context of bundler by using the `bundle exec` command. For example:

```rb
bundle exec ruby app.rb
```

### Sinatra

Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort. It is a lightweight framework that allows you to create web applications without having to deal with the complexity of Rails.

[Sinatra](https://sinatrarb.com/)

[Getting Started with Sinatra](https://www.sitepoint.com/just-do-it-learn-sinatra-i/)

## Terratowns Mock Webserver

### Running the webserver

We can run the webserver by running the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for the webserver is in the `server.rb` file.
