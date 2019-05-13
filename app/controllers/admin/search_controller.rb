module Admin
  class SearchController < AdminController
    def search
      search = params[:term].present? ? params[:term] : nil
      if search
        result = Searchkick.search search, index_name: [General::User, News::Post, General::Menu], match: :word
        @users = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/user"}.compact.paginate(:page => params[:page], :per_page => 18)
        @posts = result.with_hit.map{|a| a[0] if a[1]["_type"] == "news/post"}.compact.paginate(:page => params[:page], :per_page => 18)
        @menus = result.with_hit.map{|a| a[0] if a[1]["_type"] == "general/menu"}.compact.paginate(:page => params[:page], :per_page => 18)
      else
        @users = General::User.paginate(:page => params[:page], :per_page => 10)
        @posts = News::Post.paginate(:page => params[:page], :per_page => 10)
        @menus = General::Menu.paginate(:page => params[:page], :per_page => 10)
      end
    end
  end
end