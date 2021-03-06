class Micropost < ActiveRecord::Base
  attr_accessible :content#, :user_id
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

	# Ordering the microposts
  default_scope order: 'microposts.created_at DESC'

	# Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
  	# see http://ruby.railstutorial.org/chapters/following-users#sec-a_first_feed_implementation
    followed_user_ids = "SELECT followed_id FROM relationships
                     		 WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
    			user_id: user)
  end

end
