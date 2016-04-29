class CreateJoinTableFilmBook < ActiveRecord::Migration
  def change
    create_join_table :films, :books do |t|
      # t.index [:film_id, :book_id]
      # t.index [:book_id, :film_id]
    end
  end
end
