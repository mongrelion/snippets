require 'dm-core'

#DataMapper.setup( :default, "mysql://root:sysadmin@localhost/test" )
DataMapper.setup( :default, "appengine://auto")

class User
	include DataMapper::Resource
	property :user_id, Serial
	property :name, String
end

#DataMapper.auto_migrate!
