class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      unless ActiveRecord::Base.connection.table_exists?('merchants')
        t.string :name

        t.timestamps
      end
    end
  end
end
