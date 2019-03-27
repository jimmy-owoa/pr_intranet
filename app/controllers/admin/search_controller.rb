class Admin::SearchController < AdminController
    
    def search
      search = params[:term].present? ? params[:term] : nil
      if search
        result = Searchkick.search search, index_name: [General::User, News::Post, General::Menu], match: :word
        @users = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/user"}.compact
        @posts = result.with_hit.map{|a| a[0] if a[1]["_type"] == "news/post"}.compact
        @menus = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/menu"}.compact
      else
        @users = General::User.all
        @posts = News::Post.all
        @menus = General::Menu.all
      end
    end
end