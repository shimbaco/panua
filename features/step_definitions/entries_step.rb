# coding: utf-8

ならば /^ウェブページ"([^"]*)"のエントリーを作成する$/ do |url|
  entry = Entry.build(url, 'example')
  entry.save
end