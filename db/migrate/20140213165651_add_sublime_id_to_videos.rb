class AddSublimeIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :sublime_id, :string
  end
end
