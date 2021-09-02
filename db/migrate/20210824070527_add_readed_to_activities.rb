class AddReadedToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :readed, :boolean, default: false
  end
end
