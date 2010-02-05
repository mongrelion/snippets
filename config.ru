require 'appengine-rack'

AppEngine::Rack.configure_app(
	:application => 'dev-co-snippets',
	:version => 1 )
	
require 'snippets'

run Sinatra::Application