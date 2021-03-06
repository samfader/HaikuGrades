$LOAD_PATH << '.'

require 'hapi-client'
require 'csv'
require 'highline/import'
require 'yaml'
require_relative 'full_grade'
require_relative 'partial_grade'
require_relative 'class_export'

# Authentication information for testing
# USERNAME = 'andrew'
# PASSWORD = 'test1234'

def authentication
  file_join = File.join('config', 'authentication.yml')
	# path can be either from root or for debugging from the curent class
	if File.exists?(file_join)
		return YAML.load(File.read(file_join))
	else
		raise StandardError, 'Cannot find configuration file.  Please make sure you have edited authentication.yml.'
	end
end
    
input_domain = authentication[0]['domain']
input_apikey = authentication[0]['api_key']

puts "#{input_apikey}"

puts 'What is your Haiku Learning username?'
input_username = gets.chomp

input_password = ask('What is your Haiku Learning password? ' + "\n") { |q| q.echo = false }

# Right now it seems that Hapi Client is unable to handle this properly, since it will still create a 
# client even if the API key/domain name is wrong, then will fail below.
begin
  client = HapiClient::Client.new(api_key: input_apikey,
                                  base_endpoint: "https://#{input_domain}", debug: 'true')
rescue AuthenticationFailed
  puts "You entered an incorrect API key or domain name - please try again!"
end

begin
  session = client.login_as(username: input_username,
                            password: input_password)
rescue
  abort 'You entered an incorrect username, password, API key, or domain name - please re-run the program and try again!' if session.nil?
end

puts 'Would you like a list of your classes exported to csv? (y/n)'
export = gets.chomp
if export == 'y'
  ClassExport.class_list(client)
else
  puts ''
end

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