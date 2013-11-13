class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets

  def tweet(status)
    tweet = tweets.create!(:status => status)
    jobId = TweetWorker.perform_async(tweet.id)
  end

  def tweet_later(status, time)
    tweet = tweets.create!(:status => status)
    time_to_post = Time.now + time
    jobID = TweetWorker.perform_at(time_to_post, tweet.id)
  end
end
