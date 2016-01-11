class User < ActiveRecord::Base
	has_many :posts, dependent: :destroy

	has_many :relationships, foreign_key: :follower_id #NYCDA Blog people following user
	has_many :followed, through: :relationships, source: :followed

	has_many :reverse_relationships, foreign_key: :followed_id, class_name: 'Relationship'
	has_many :followers, through: :reverse_relationships, source: :follower
end

class Post < ActiveRecord::Base
	belongs_to :user
	validates_length_of :body, maximum:150
end

class Relationship < ActiveRecord::Base
	belongs_to :followed, class_name: 'User'
	belongs_to :follower, class_name: 'User' # Getting method errors for follower :(
end