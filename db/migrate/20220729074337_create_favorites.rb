class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :post_image_id

      t.timestamps
    end
  end
  
  def change
    rename_column :favorites, :remember_post_image, :remember_book
  end
  
end
