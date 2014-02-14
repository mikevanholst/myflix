namespace :video do
  desc "Finds the most recent video"
  task :latest => :environment do
  video = Video.last
    puts "Most recent video: #{video.title} with #{video.reviews.count} reviews."
  end

  desc "Finds the earliest posted video"
  task :earliest => :environment do
  video = Video.first
    puts "Oldest video: #{video.title} with #{video.reviews.count} reviews."
  end

  desc "Finds the first and last video"
  task :first_and_last => [:earliest, :latest]
end

#call by using rake video:earliest
#from railscasts 66