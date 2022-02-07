class RemoveGroupCategoriesIdFromGroup < ActiveRecord::Migration[5.2]
  def change
    safety_assured { remove_column :groups, :group_categories_id }
  end
end
