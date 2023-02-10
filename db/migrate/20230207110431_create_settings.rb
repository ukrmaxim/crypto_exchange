class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :title, index: { unique: true, name: 'unique_setting_title' }
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
