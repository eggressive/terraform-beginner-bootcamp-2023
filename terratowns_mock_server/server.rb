require 'sinatra'
require 'json'
require 'pry'
require 'active_model'

$home = {}

# This is a ruby class that represents the data that we want to store in our database
# It also has validations that ensure the data is valid before we try to save it
# This is a simple example, but in a real app, this would be a model from your database
# and the validations would be more complex
class Home
  # ActiveModel::Validations is a module that provides a lot of useful validations and a part of Ruby on Rails
  # See: https://api.rubyonrails.org/classes/ActiveModel/Validations.html
  include ActiveModel::Validations

  # This is a macro that defines the attributes that we want to store in our database
  attr_accessor :town, :name, :description, :domain_name, :content_version

  # See https://terratowns.cloud/ for the expected format of the town data
  # This is a macro that defines the validations that we want to perform on the data
  # See: https://api.rubyonrails.org/classes/ActiveModel/Validations/ClassMethods.html#method-i-validates
  validates :town, presence: true, inclusion: { in: [
    'cooker-cove',
    'video-valley',
    'the-nomad-pad',
    'gamers-grotto',
    'melomaniac-mansion'
    ] }
  # visible to the user
  validates :name, presence: true
  validates :description, presence: true
  # we want to lock down the domain name to only be from cloudfront.net
  validates :domain_name, 
    format: { with: /\.cloudfront\.net\z/, message: "domain must be from .cloudfront.net" }
    # uniqueness: true, 

  # content version is an integer
  # we will make sure it is an incrementing integer on the controller
    validates :content_version, numericality: { only_integer: true }
end

# This is a Sinatra app that mocks the TerraTowns API
# We are extending the Sinatra::Base class
class TerraTownsMockServer < Sinatra::Base

  def error code, message
    halt code, {'Content-Type' => 'application/json'}, {err: message}.to_json
  end

  def error_json json
    halt code, {'Content-Type' => 'application/json'}, json
  end

  def ensure_correct_headings
    unless request.env["CONTENT_TYPE"] == "application/json"
      error 415, "expected Content_type header to be application/json"
    end

    unless request.env["HTTP_ACCEPT"] == "application/json"
      error 406, "expected Accept header to be application/json"
    end
  end

  # returns the hardcoded bearer token
  def x_access_code
    '9b49b3fb-b8e9-483c-b703-97ba88eef8e0'
  end

  def x_user_uuid
    'e328f4ab-b99f-421c-84c9-4ccea042c7d1'
  end

  def find_user_by_bearer_token
    auth_header = request.env["HTTP_AUTHORIZATION"]
    # checks if the auth header is nil or if it doesn't start with Bearer
    if auth_header.nil? || !auth_header.start_with?("Bearer ")
      error 401, "a1000 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # checks if the bearer token matches the x_access_code or return error
    code = auth_header.split("Bearer ")[1]
    if code != x_access_code
      error 401, "a1001 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # was there a user_uuid in the params
    if params['user_uuid'].nil?
      error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end

    # checks if the user_uuid matches the x_user_uuid or return error
    unless code == x_access_code && params['user_uuid'] == x_user_uuid
      error 401, "a1003 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
    end
  end

  # CREATE
  post '/api/u/:user_uuid/homes' do
    ensure_correct_headings
    find_user_by_bearer_token
    # puts will print to the console
    puts "# create - POST /api/homes"

    # rescue will catch any errors that occur in the block
    begin
      # sinatra provides a request object that has a body method that will return the body of the request
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # assign the payload data to variables
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]
    town = payload["town"]

    # prints the variables to the console
    puts "name #{name}"
    puts "description #{description}"
    puts "domain_name #{domain_name}"
    puts "content_version #{content_version}"
    puts "town #{town}"

    # create a new instance of the Home class and assign the variables to the attributes
    home = Home.new
    home.town = town
    home.name = name
    home.description = description
    home.domain_name = domain_name
    home.content_version = content_version
    
    # validate the home object
    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    # generate a random uuid and assign it to the $home variable
    uuid = SecureRandom.uuid
    puts "uuid #{uuid}"
    # will mock save the home to the database
    $home = {
      uuid: uuid,
      name: name,
      town: town,
      description: description,
      domain_name: domain_name,
      content_version: content_version
    }

    # return the uuid as json
    return { uuid: uuid }.to_json
  end

  # READ
  get '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# read - GET /api/homes/:uuid"

    # checks for house limit

    content_type :json
    # checks if the uuid in the params matches the uuid in the $home variable
    if params[:uuid] == $home[:uuid]
      return $home.to_json
    else
      error 404, "failed to find home with provided uuid and bearer token"
    end
  end

  # UPDATE
  # similar to the create route
  put '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# update - PUT /api/homes/:uuid"
    begin
      # Parse JSON payload from the request body
      payload = JSON.parse(request.body.read)
    rescue JSON::ParserError
      halt 422, "Malformed JSON"
    end

    # Validate payload data
    name = payload["name"]
    description = payload["description"]
    domain_name = payload["domain_name"]
    content_version = payload["content_version"]

    unless params[:uuid] == $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    home = Home.new
    home.town = $home[:town]
    home.domain_name = $home[:domain_name]
    home.name = name
    home.description = description
    home.content_version = content_version

    unless home.valid?
      error 422, home.errors.messages.to_json
    end

    return { uuid: params[:uuid] }.to_json
  end

  # DELETE
  delete '/api/u/:user_uuid/homes/:uuid' do
    ensure_correct_headings
    find_user_by_bearer_token
    puts "# delete - DELETE /api/homes/:uuid"
    content_type :json

    if params[:uuid] != $home[:uuid]
      error 404, "failed to find home with provided uuid and bearer token"
    end

    # check for 'uuid' correctness ?
    uuid = $home[:uuid]
    $home = {}
    { uuid: uuid }.to_json
  end
end

# This is the command that starts the server
TerraTownsMockServer.run!