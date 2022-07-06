module Api::V1
    class ExpenseReportCategoriesController < ApiController
      # include Rails.application.routes.url_helpers

      def subcategories
        subcategories = ExpenseReport::Subcategory.all
        render json: subcategories, status: :ok
      end
    end
  end
    