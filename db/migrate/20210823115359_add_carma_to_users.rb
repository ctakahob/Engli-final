class AddCarmaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :carma, :integer, default: 0
  end
end
