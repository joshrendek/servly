class AddNameAndNotesToGroups < ActiveRecord::Migration
  def self.up
    add_column :groups, :name, :string
    add_column :groups, :notes, :text
  end

  def self.down
    remove_column :groups, :notes
    remove_column :groups, :name
  end
end
