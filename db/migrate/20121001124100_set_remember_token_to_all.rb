class SetRememberTokenToAll < ActiveRecord::Migration
  def up
  	User.all.each { |user| user.save(validate: false) }
  end

  def down
  end
end
