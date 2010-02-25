require 'sinatra'
require 'dm-core'
require 'appengine-apis/users'
require 'models/snippet'

helpers do
	include Rack::Utils
	alias_method :h, :escape_html
end

get '/' do
	@snippets = Snippet.all( :order => [ :insert_date.desc ] )
	erb :snippets
end

get '/snippet/new' do
  @user = AppEngine::Users.current_user
  if @user
    erb :new_snippet
  else
    redirect AppEngine::Users.create_login_url( '/' )
  end
end

post '/snippet/new' do

	title		= params[ :title ]
	code		= params[ :code ]
	lang		= params[ :lang ]
	user_nickname	= params[ :user_nickname ]
	
	snippet = Snippet.new( :title => title, :code => code, :lang => lang, :user_nickname => user_nickname )
	snippet.save

	redirect '/'

end

get '/user/:username' do
	@snippets = Snippet.all( :user_nickname => params[ :username ] )
	erb :snippets
end

get '/lang/:language' do
	@snippets = Snippet.all( :lang => params[ :language ] )
	erb :snippets
end