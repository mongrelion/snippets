require 'dm-core'

#DataMapper.setup( :default, "mysql://root:sysadmin@localhost/test" )
DataMapper.setup( :default, "appengine://auto")

class Snippet
	include DataMapper::Resource
	property :snippet_id, 	Serial
	property :title, 		String
	property :body, 		Text
	property :insert_date,	Time, :default => lambda { |r, p| Time.now }
	property :user_id, 		Integer
end

#DataMapper.auto_migrate!
