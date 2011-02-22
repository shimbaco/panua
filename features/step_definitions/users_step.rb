# coding: utf-8

前提 /^ユーザー名が"([^"]*)"、メールアドレスが"([^"]*)"のユーザーがいる$/ do |screen_name, email|
  Factory.create(:user, :screen_name => screen_name, :email => email)
end

前提 /^以下のユーザーがいる$/ do |table|
  table.raw.each do |row|
    screen_name = row.first
    When %Q[ユーザー名が"#{screen_name}"、メールアドレスが"#{screen_name}@example.com"のユーザーがいる]
  end
end

かつ /^"([^"]*)"としてログインしている$/ do |screen_name|
  Given %Q["ログイン"ページを表示している]
  When  %Q["ユーザー名またはメールアドレス"に"#{screen_name}"と入力する]
  And   %Q["パスワード"に"svojob"と入力する]
  And   %Q["ログイン"ボタンをクリックする]
end

かつ /^以下のユーザーごとのブックマークがある$/ do |table|
  table.rows.each do |screen_name, title, url, created_at|
    user = User.where(:screen_name => screen_name).first
    user.bookmarks.create(:title => title, :url => url, :created_at => created_at)
  end
end

かつ /^"([^"]*)"が"([^"]*)"をフォローしている$/ do |screen_name1, screen_name2|
  user1 = User.where(:screen_name => screen_name1).first
  user2 = User.where(:screen_name => screen_name2).first
  user1.following << user2
end