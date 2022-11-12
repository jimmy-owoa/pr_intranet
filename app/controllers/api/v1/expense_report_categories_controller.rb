module Api::V1
    class ExpenseReportCategoriesController < ApiController
      # include Rails.application.routes.url_helpers
      def categories
        categories = ExpenseReport::Category.all
        render json: categories, status: :ok
      end
    end
  end
    