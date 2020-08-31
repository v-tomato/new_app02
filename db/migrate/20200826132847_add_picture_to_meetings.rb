class AddPictureToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :picture, :string
  end
end
