class AddProfileToLinks < ActiveRecord::Migration[5.2]
  def change
    add_reference :general_links, :profile
  end
end
