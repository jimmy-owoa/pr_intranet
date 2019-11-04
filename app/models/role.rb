class Role < ApplicationRecord
  has_and_belongs_to_many :general_users, :join_table => :general_users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
