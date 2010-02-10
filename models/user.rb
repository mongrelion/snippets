require 'dm-core'

DataMapper.setup( :default, "appengine://auto")

class User
	include DataMapper::Resource
	property :user_id, Serial
	property :name, String
end