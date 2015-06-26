class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :slack_id, null: false, default: ""
  		t.string :name, null: false, default: ""
  		t.integer :wins
  		t.integer :played
  	end
  end
end
