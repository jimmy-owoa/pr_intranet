class PublishPostJob < ApplicationJob
  queue_as :publish_post

  def perform(*args)
    # Do something later
  end
end
