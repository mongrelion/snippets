require 'sinatra'
require 'appengine-apis/users'
require 'models/snippet'
require 'models/user'

def baseHTML 
  str = "<html>
		<head>
		<script type='text/javascript' src='scripts/shCore.js'></script>
		<script type='text/javascript' src='scripts/shBrushBash.js'></script>
		<script type='text/javascript' src='scripts/shBrushCpp.js'></script>
		<script type='text/javascript' src='scripts/shBrushCSharp.js'></script>
		<script type='text/javascript' src='scripts/shBrushCss.js'></script>
		<script type='text/javascript' src='scripts/shBrushDelphi.js'></script>
		<script type='text/javascript' src='scripts/shBrushDiff.js'></script>
		<script type='text/javascript' src='scripts/shBrushGroovy.js'></script>
		<script type='text/javascript' src='scripts/shBrushJava.js'></script>
		<script type='text/javascript' src='scripts/shBrushJScript.js'></script>
		<script type='text/javascript' src='scripts/shBrushPhp.js'></script>
		<script type='text/javascript' src='scripts/shBrushPlain.js'></script>
		<script type='text/javascript' src='scripts/shBrushPython.js'></script>
		<script type='text/javascript' src='scripts/shBrushRuby.js'></script>
		<script type='text/javascript' src='scripts/shBrushScala.js'></script>
		<script type='text/javascript' src='scripts/shBrushSql.js'></script>
		<script type='text/javascript' src='scripts/shBrushVb.js'></script>
		<script type='text/javascript' src='scripts/shBrushXml.js'></script>
		<link type='text/css' rel='stylesheet' href='styles/shCore.css'/>
		<link type='text/css' rel='stylesheet' href='styles/shThemeDefault.css'/>
		<script type='text/javascript'>
			SyntaxHighlighter.config.clipboardSwf = 'scripts/clipboard.swf';
			SyntaxHighlighter.all();
		</script>
	</head>"
  return str
end

helpers do
	include Rack::Utils
	alias_method :h, :escape_html
end

get '/form/:userID' do
	"<html>
	  <head>
	    <title>DevCO Snippets App</title>
	  </head>
	  <body>
	    <form action='/createSnippet' method='post'>
	      <div><input type='text' name='title' size='80' /></div>
	      <div><textarea name='snippet' rows='20' cols='80' ></textarea></div>
	      <input type='hidden' name='userID' value=#{ params[:userID]} />
	      <input type='submit' value='Save' />
	    </form>
	  </body>
	 </html>
	"
end

post '/createSnippet' do

	# Recuperar los datos que llegan por parámetro:
	title	= params[ :title ]
	code	= params[ :snippet ]
	userID	= params[ :userID ]
	
	# Hacer persistentes los datos que hemos recuperado.
	snippet = Snippet.new( :title => title, :body => code, :user_id => userID )
	snippet.save

	result = "<body>You wrote:<br />
			  <pre class='brush: c-sharp;'>#{h params[ :snippet ]}</pre>
			  </body>
			  </html>"
	return baseHTML() + result
end

get '/list' do
	result = "<body>"
	snippets = Snippet.all
	snippets.each do |snip|
		result += "<p>#{ snip.title.to_s }<br />Posted by #{ User.get( snip.user_id ).name.to_s }<br /> <pre class='brush: c-sharp;'>#{ snip.body.to_s }</pre><br /></p>"
	end
	result += "</html></body>"
	return baseHTML() + result
end

get '/createUser/:name' do
	user = User.new( :name => params[ :name ] )
	user.save
	return "Id generated for user #{ params[ :name ] }:" + user.user_id.to_s
end