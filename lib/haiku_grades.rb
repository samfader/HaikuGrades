$LOAD_PATH << '.'

require 'hapi-client'
require 'csv'
require 'highline/import'
require 'yaml'
require_relative 'full_grade'
require_relative 'partial_grade'
require_relative 'class_export'

# Authentication information
# API_KEY = '05378d310dc85a492df2200be254be7f'
# DOMAIN = 'no-real-data.haikulearning.com'
# USERNAME = 'andrew'
# PASSWORD = 'test1234'

# Commenting out for testing purposes
# puts "Enter your domain URL without www or https://
# (for example, test.haikulearning.com)"
# input_domain = gets.chomp

# puts "What is your API key?"
# input_apikey = gets.chomp

class HaikuGrades
  
attr_writer :config

		def initialize
			# path can be either from root or for debugging from the curent class
			if File.exists?('../../config/authentication.yml')
				@config = YAML.load(File.open('../../config/authentication.yml'))
			elsif File.exists?('./config/authentication.yml')
				@config = YAML.load(File.open('./config/authentication.yml'))
			else
				raise StandardError, 'Cannot find configuration file.  Please make sure you have edited authentication.yml.'
			end
		end
    
input_domain = @config['haikugrades']['domain']
input_apikey = @config['haikugrades']['api_key']

puts 'What is your Haiku Learning username?'
input_username = gets.chomp

input_password = ask('What is your Haiku Learning password? ' + "\n") { |q| q.echo = false }

begin
  # Instantiate a client using the information above
  client = HapiClient::Client.new(api_key: input_apikey,
                                  base_endpoint: "https://#{input_domain}", debug: 'true')
rescue
  raise 'You entered an incorrect API key or domain name - please try again!'
end

begin
  # Login as a single user
  session = client.login_as(username: input_username,
                            password: input_password)
rescue
  raise 'You entered an incorrect username or password - please try again!' if session.nil?
end

puts 'Would you like a list of your classes exported to csv? (y/n)'
export = gets.chomp
if export == 'y'
  ClassExport.class_list(client)
else
  puts ''
end

# Ask user which class they want grades for
puts "Your classes are: " + "\n"
client.user.eclasses_teaching['items'].each do |eclass|
  puts "#{eclass['name']}" + " : #{eclass['id']} (id)"
end

puts ""
puts "Please enter the id of the class whose grade entries you'd like exported to CSV.  If you'd like all classes, simply type 'all', without the single quotation marks."
class_selection = gets.chomp

if class_selection == 'all'
  FullGrade.full_list(client)
else
  PartialGrade.partial_list(class_selection, client)
end

puts 'Ran successfully.'
end