require 'active_record'
require 'active_support/core_ext/string/strip'

ActiveRecord::Base.establish_connection adapter: "sqlite3",
                                        database: "dbfile"

ActiveRecord::Base.connection.create_table :tasks do |t|
  t.string  :description
  t.boolean :completed
end



class Task < ActiveRecord::Base; end

task = Task.new
task.description = 'ガレージの掃除'
task.completed = true
task.save





puts task.description
puts task.completed?