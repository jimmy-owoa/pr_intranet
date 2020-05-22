module Admin
  class SearchController < AdminController
    def search
      search = params[:term].present? ? params[:term] : nil
      if search
        result = Searchkick.search search, index_name: [General::User, News::Post, General::Menu, General::Benefit, Media::Gallery, Survey::Survey], match: :word
        @users = result.with_hit.map { |a| a[0] if a[1]["_index"].include?("general_users") }.compact.paginate(:page => params[:page], :per_page => 18)
        @posts = result.with_hit.map { |a| a[0] if a[1]["_index"].include?("news_posts") }.compact.paginate(:page => params[:page], :per_page => 18)
        @menus = result.with_hit.map { |a| a[0] if a[1]["_index"].include?("general_menus") }.compact.paginate(:page => params[:page], :per_page => 18)
        @benefits = result.with_hit.map { |a| a[0] if a[1]["_index"].include?("general_benefits") }.compact.paginate(:page => params[:page], :per_page => 18)
        @galleries = result.with_hit.map { |a| a[0] if a[1]["_index"].include?("media_galleries") }.compact.paginate(:page => params[:page], :per_page => 18)
        @surveys = result.with_hit.map { |a| a[0] if a[1]["_index"].include?("survey_surveys") }.compact.paginate(:page => params[:page], :per_page => 18)
      else
        @users = General::User.paginate(:page => params[:page], :per_page => 10)
        @posts = News::Post.paginate(:page => params[:page], :per_page => 10)
        @menus = General::Menu.paginate(:page => params[:page], :per_page => 10)
        @benefits = General::Benefit.paginate(:page => params[:page], :per_page => 10)
        @galleries = Media::Gallery.paginate(:page => params[:page], :per_page => 10)
        @surveys = Survey::Survey.paginate(:page => params[:page], :per_page => 10)
      end
    end
  end
end
