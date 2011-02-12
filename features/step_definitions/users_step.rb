# coding: utf-8

前提 /^ユーザー名が"([^"]*)"、メールアドレスが"([^"]*)"のユーザーがいる$/ do |screen_name, email|
  Factory.create(:user, :screen_name => screen_name, :email => email)
end