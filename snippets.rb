require 'sinatra'
require 'dm-core'
require 'appengine-apis/users'
require 'models/snippet'

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
		<a href='/snippets/new'>Create a new snippet</a><br />
		<a href='/snippets'>List all snippets</a><br />
	</head>"
  return str
end

helpers do
	include Rack::Utils
	alias_method :h, :escape_html
end

get '/' do
  return baseHTML()
end

get '/snippets/new' do
  user = AppEngine::Users.current_user
  if user
	"<html>
	  <head>
	    <title>DevCO Snippets App</title>
	    <p><b> #{ user.nickname  }</b>, start typing your code =)</p><br />
	  </head>
	  <body>
	    <form action='/snippets/new' method='post'>
	      <div><select name='lang'>
                     <option value='bash'>Bash/Shell</option>
		     <option value='csharp'>C#</option>
		     <option value='css'>CSS</option>
                     <option value='js'>JavaScript</option>
		     <option value='java'>Java</option>
		     <option value='php'>PHP</option>
                     <option value='text'>Plain Text</option>
		     <option value='py'>Python</option>
		     <option value='ruby'>Ruby/Ruby on Rails</option>
		     <option value='sql'>SQL</option>
		   </select>
	      </div>
	      <div><input type='text' name='title' size='80' /></div>
	      <div><textarea name='code' rows='20' cols='70' ></textarea></div>
	      <input type='hidden' name='user_nickname' value=#{ user.nickname } />
	      <input type='submit' value='Save' />
	    </form>
	  </body>
	 </html>
	"
  else
    redirect AppEngine::Users.create_login_url( '/' )
  end
end

post '/snippets/new' do

	# Recuperar los datos que llegan por parátro:
	title		= params[ :title ]
	code		= params[ :code ]
	lang		= params[ :lang ]
	user_nickname	= params[ :user_nickname ]
	
	# Hacer persistentes los datos que hemos recuperado.
	snippet = Snippet.new( :title => title, :code => code, :lang => lang, :user_nickname => user_nickname )
	snippet.save

	result = "<body>You wrote:<br />
			  <pre class='brush: c-sharp;'>#{h params[ :code ]}</pre><br />
			  <p>Lang: #{ snippet.lang }</p><br />
			  </body>
			  </html>"
	return baseHTML() + result
end

get '/snippets' do
	result = "<body>"
	snippets = Snippet.all
	snippets.each do |snip|
		result += "<p>#{ snip.title.to_s }<br />Posted by #{ snip.user_nickname.to_s }<br /> <pre class='brush: #{ snip.lang.to_s };'>#{ snip.code.to_s }</pre><br /></p>"
	end
	result += "</body></html>"
	return baseHTML() + result
end
