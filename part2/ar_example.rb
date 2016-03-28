require 'active_record'

ActiveRecord::Base.establish_connection adapter: "sqlite3",
                                        database: "dbfile"

class Duck < ActiveRecord::Base
  validate do
    errors.add(:base, "Illigal duck name.") unless name[0] == 'D'
  end
end

# 注意：DBをちゃんと作っていないので以下は動かない


my_duck = Duck.new
my_duck.name = "Donald"
my_duck.valid?
my_duck.save!


duck_from_database = Duck.first
duck_from_database.name
duck_from_database.delete