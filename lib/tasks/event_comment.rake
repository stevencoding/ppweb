# encoding: utf-8

namespace :db do
  desc "Filling in blank commentable_type column with Event in comments table"
  task :comment => :environment do
    Comment.all.each do |c|
      c.commentable_type = "Event"
      c.save
    end
  end
end

