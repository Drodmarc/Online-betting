class CreateBarangays < ActiveRecord::Migration[6.1]
  def change
    create_table :barangays do |t|
      t.string :code
      t.string :name
      t.belongs_to :city
      t.timestamps
    end
  end
end
