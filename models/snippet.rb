require 'dm-core'

DataMapper.setup( :default, "appengine://auto")

class Snippet
	include DataMapper::Resource
	property :snippet_id, 		Serial
	property :title, 		String
	property :code, 		Text
	property :lang,			String
	property :insert_date,		Time, :default => lambda { |r, p| Time.now }
	property :user_nickname, 	Integer
end
