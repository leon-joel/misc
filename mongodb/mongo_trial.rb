# https://tech-sketch.jp/2014/03/ruby%E3%81%AEodm-mongoid%E3%82%92%E4%BD%BF%E3%81%84%E3%81%93%E3%81%AA%E3%81%99%E2%91%A0-2.html

require 'mongoid'

mongoid_config_file = File.expand_path('mongoid.yml', File.dirname(__FILE__))
puts mongoid_config_file
Mongoid.load!(mongoid_config_file, :development)  # 設定ファイルの読み込み

class User
  include Mongoid::Document

  field :name, type: String
  field :email, type: String
  field :gender, type: String

  validates :name, presence: true

end

puts "■■■■■ 削除 ■■■■■"

user = User.create(name: "delete soon", email: "delete_soon@example.com")
user.destroy       # 1件削除 ※コールバックも走る（と思う）

User.destroy_all   # usersコレクションを全削除 ※同上（だと思う）


User.create(name: "hoge", email: "hoge@example.com", gender: "male")

user = User.new(name: "fuga", email: "fuga@example.co.jp")  # genderは nil となる
user.save!  # !付きはバリデーション失敗時に例外がthrowされる

User.create! rescue nil  # create! はバリデーションエラー時に Mongoid::Errors::Validations がthrowされる

puts "■■■■■ 検索 ■■■■■"
user = User.where(
    name: "hoge"
).first
p user

p User.criteria   # 空のCriteriaを返す

p User.all        # 同上

p User.all_in(name: "hoge")  # 検索条件付きのCriteriaを返す


# Criteria に .first, .last, .to_a, .each, .map などのメソッドを与えれば、検索結果が返される

users = User.all  # users は criteria
p users.to_a      # to_a で 検索結果を配列化

users.each do |user|
  p user
end

# names = users.map do |user|
#   user.name
# end
# p names

# 上と同じ事をメソッド引数？を使ってシンプルに記述
p users.map(&:name)

puts "_idで検索"
# p User.criteria.find(user._id)  # これもOK
p User.find(user._id)

user = User.find("55555") rescue nil  # これもOK。ただし、見つからなかったら Mongoid::Errors::DocumentNotFound が throw される
p user

puts "■■■■■ 更新 ■■■■■"

user = User.where(name: "hoge").first
p user

user.email = "hogehoge@example.com"
user.save

user = User.where(name: "hoge").first
p user

