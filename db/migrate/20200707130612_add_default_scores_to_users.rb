class AddDefaultScoresToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :best_score, :integer, default: 0
    change_column :users, :actual_score, :integer, default: 0
  end
end
