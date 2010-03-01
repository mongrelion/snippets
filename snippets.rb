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
        @title    = "#dev-co Snippets"
	erb :snippets
end

get '/snippet/new' do
  @user = AppEngine::Users.current_user
  @title    = "Create a new snippet - #dev-co Snippets"
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
	@snippets = Snippet.all( :user_nickname => params[ :username ], :order => [ :insert_date.desc ] )
        @title    = "#{params[ :username ]} snippets - #dev-co Snippets"
	erb :snippets
end

get '/lang/:language' do
        @title    = "#{params[ :language ]} snippets - #dev-co Snippets"
	@snippets = Snippet.all( :lang => params[ :language ], :order => [ :insert_date.desc ] )
	erb :snippets
end

get '/:snippet_id' do
	@snippet = Snippet.get( params[:snippet_id] )
        @title    = "#{@snippet.title} - #dev-co Snippets"
	erb :view_snippet
end
