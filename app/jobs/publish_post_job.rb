class PublishPostJob < ApplicationJob
  queue_as :publish_post

  def perform(*args)
    posts =  publish_posts
    publish_posts.each do |post|
      post.update_attributes(status: 'Publicado')
    end
    puts 'did job publish programed posts'
  end

  def publish_posts
    News::Post.where(
      "DATE_FORMAT(published_at, '%d/%m/%Y %H:%M') = ? AND status = ?", Time.now.strftime("%d/%m/%Y %H:%M"), 'Programado'
    )
  end
end
