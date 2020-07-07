class AddScoresToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :best_score, :integer
    add_column :users, :actual_score, :integer
  end
end
