# coding: utf-8

Factory.define :bookmark, :class => Bookmark do |f|
  f.url 'http://twitter.com/bojovs'
  f.title 'bojovs::twitter'
  f.note 'bojovsのTwitter'
  f.private false
end

Factory.define :comment, :class => Comment do |f|
  f.body 'コメント本文'
  f.score 0
end

Factory.define :entry, :class => Entry do |f|
  f.url 'http://twitter.com/bojovs'
  f.title 'bojovs (bojovs) on Twitter'
end

Factory.define :tag, :class => Tag do |f|
  f.user_id BSON::ObjectId.from_string("aaaaaaaaaaaaaaaaaaaaaaaa")
  f.name 'tag'
  f.phonetic_name 'phonetic_tag'
  f.about 'about'
end

Factory.define :user, :class => User do |f|
  f.email 'bojovs@gmail.com'
  f.password 'svojob'
  f.name 'Koji Shinba'
  f.screen_name 'bojovs'
  f.language 'ja'
  f.url 'http://twitter.com/bojovs'
  f.bio 'hello'
end

Factory.define :user2, :class => User do |f|
  f.email 'bojovs2@gmail.com'
  f.password 'bojovs2'
  f.name 'Koji Shinba 2'
  f.screen_name 'bojovs2'
  f.language 'ja'
  f.url 'http://twitter.com/bojovs2'
  f.bio 'hello'
end
