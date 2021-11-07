class UsersDatatable < ApplicationDatatable
  delegate :admin_user_path, to: :@view
  delegate :edit_admin_user_path, to: :@view
  delegate :mail_to, to: :@view

  include ApplicationHelper

  private

  def data
    users.map do |user|
      links = []
      links << link_to('Ver', admin_user_path(user), class: 'btn btn-success btn-sm')
      links << link_to('Editar', edit_admin_user_path(user), class: 'btn btn-warning btn-sm')

      {
        name: user.name,
        lastname: "#{user.last_name} #{user.last_name2}",
        email: mail_to(user.email),
        annexed: user.annexed,
        active: user.active ? 'Sí' : 'No',
        actions: links.join(' ')
      }
    end
  end

  def count
    General::User.count
  end

  def total_entries
    users.total_count
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    if params[:approved] == 'true' || params[:approved] == 'false'
      aprov = ActiveModel::Type::Boolean.new.cast(params[:approved])
      users = General::User.active_filter(aprov).order(created_at: :desc)
    else
      users = General::User.order(created_at: :desc)
    end

    users = users.page(page).per(per_page)

    if params[:search][:value].length > 2
      variables = [
        'name',
        'last_name',
        'last_name2',
        "CONCAT(name,' ',last_name)",
        "CONCAT(name,' ',last_name,' ',last_name2)",
        "CONCAT(last_name,' ',last_name2)"
      ]
      queries = []

      variables.each do |var|
        queries << "#{var} LIKE '%#{params[:search][:value]}%'"
      end

      query_where = queries.join(' OR ')
      users = users.where(query_where)
    end

    users
  end

  def columns
    %w(name lastname email annexed actions)
  end
end