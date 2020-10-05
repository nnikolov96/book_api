class AddRatingToBook < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        add_column :books, :average_rating, :decimal, precision: 2, scale: 1, default: 0.0
        Book.find_each do |book|
          return unless book.reviews.present?
          book.average_rating = book.reviews.average(:rating).round(1)
          book.save!
        end
      end

      dir.down do
        remove_column :books, :average_rating
      end
    end
  end
end
