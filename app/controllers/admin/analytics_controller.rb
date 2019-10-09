module Admin
  class AnalyticsController < AdminController
    def index
      @events = Ahoy::Event.all
      @posts = []
      News::Post.all.each do |post|
        post_count = Ahoy::Event.where_props(id: post.id).count
        @posts << { title: post.title, category: post.terms.categories.first, count: post_count }
      end
      @post_visit = Ahoy::Event.where_event("Post Model", controller: "frontend/posts").count
    end
  end
end
