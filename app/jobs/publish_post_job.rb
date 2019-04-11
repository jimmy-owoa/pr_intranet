class PublishPostJob < ApplicationJob
  queue_as :publish_post

  def perform(*args)
    # Do something later
    puts "I am busy mailing newsletter."
  end
end
