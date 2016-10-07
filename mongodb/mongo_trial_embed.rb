# http://babie.hatenablog.com/entry/20100812/1281576103

require 'mongoid'

mongoid_config_file = File.expand_path('mongoid.yml', File.dirname(__FILE__))
puts mongoid_config_file
Mongoid.load!(mongoid_config_file, :development)  # 設定ファイルの読み込み


class Person
  include Mongoid::Document
  field :first_name
  field :middle_initial
  field :last_name
  embeds_one :email
  embeds_many :addresses
end

class Address
  include Mongoid::Document
  field :street
  field :post_code
  field :state

  # inverse_of についての解説: http://shoken.hatenablog.com/entry/2015/07/14/095211
  embedded_in :person, :inverse_of => :addresses
end

class Email
  include Mongoid::Document
  field :address

  # inverse_of についての解説: http://shoken.hatenablog.com/entry/2015/07/14/095211
  embedded_in :person, :inverse_of => :email
end


Person.destroy_all   # people コレクションを全削除 ※同上（だと思う）

person = Person.new(:first_name => "Dudley")
person.save

person = Person.first
p person

puts "personにadressをembedして、一括でsaveする"
person = Person.new(:first_name => "Secondary")
address = Address.new(:street => "Upper Street")
person.addresses << address
person.addresses << Address.new(:street => "Lower Street")
person.save # address.save でも同様の結果になる
person = Person.where(first_name: "Secondary").first
p person
p person.addresses

puts "adressesというコレクションは存在しない"
addresses = Address.all.to_a
p addresses

puts "既存ドキュメントにemailをembedする"
email = Email.new(:address => "second@moore.com")
person.email = email
email.save

person = Person.where(first_name: "Secondary").first
p person
p person.email


puts "親ドキュメントの属性とembeddedドキュメントの属性を同時に変更してsave"
person.middle_initial = 'J'
person.last_name = "Ichiro"

person.email.address = "second2@ore.com"
person.save
p person.email

puts "配列の先頭要素の値だけを変更"
address = person.addresses.first
address.street = "Canondale Street"
address.state = "NJ"
address.save
p person.addresses


puts "ルートドキュメントから子要素達を変更して、一括SAVE。※1ドキュメントなのでatomicな処理となる"
person.middle_initial = "JJ"
person.addresses.last.post_code = "987654"
person.email.address = "jj@rate.com"
person.save

person = Person.where(first_name: "Secondary").first
p person
p person.addresses
p person.email

puts "子要素削除"
person.email.destroy
person = Person.where(first_name: "Secondary").first
p person
p person.addresses
p person.email    # -> nil

puts "子要素配列の要素を削除"
person.addresses.first.destroy
person = Person.where(first_name: "Secondary").first
p person
p person.addresses
p person.email
