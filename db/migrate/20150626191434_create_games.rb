class CreateGames < ActiveRecord::Migration
  def change
  	create_table :games do |t|
  		t.string :players, default: ""
  		t.string :hands, default: ""
  		t.string :deck, default: ""
  		t.string :discard, default: ""
  		t.integer :turn, null: false, default: 1
  		t.integer :status, null: false, default: true
  		t.integer :winner_id

  		t.timestamps
  	end
  end
end
