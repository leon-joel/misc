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
  embedded_in :person, :inverse_of => :addresses
end

class Email
  include Mongoid::Document
  field :address
  embedded_in :person, :inverse_of => :email
end