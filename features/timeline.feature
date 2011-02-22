# language: ja

#フィーチャ: タイムラインにブックマークを表示する
#  ユーザーとして
#  ブックマークをタイムラインに表示したい。
#  なぜなら、フォローしたユーザーのブックマークがまとめて見れるから。
#
#  シナリオ: bojovsがhogeをフォローしていると、ホーム画面でhogeのブックマークが見られる
#    前提    以下のユーザーがいる
#          | bojovs |
#          | hoge   |
#          | fuga   |
#    かつ    以下のユーザーごとのブックマークがある
#          | ユーザー | タイトル      | URL                  | created_at                              |
#          | bojovs  | ブックマーク1 | http://example.com/1 | Tue Feb 13 2011 07:29:54 GMT+0900 (JST) |
#          | hoge    | ブックマーク2 | http://example.com/2 | Tue Feb 13 2011 07:29:55 GMT+0900 (JST) |
#          | fuga    | ブックマーク3 | http://example.com/3 | Tue Feb 13 2011 07:29:56 GMT+0900 (JST) |
#          | hoge    | ブックマーク4 | http://example.com/4 | Tue Feb 13 2011 07:29:57 GMT+0900 (JST) |
#    かつ    "bojovs"としてログインしている
#    かつ    "bojovs"が"hoge"をフォローしている
#    もし    "ホーム"ページを表示している
#    ならば  以下のブックマークが表示されていること
#          | hoge    | ブックマーク4 | http://example.com/4 | Tue Feb 13 2011 07:29:57 GMT+0900 (JST) |
#          | hoge    | ブックマーク2 | http://example.com/2 | Tue Feb 13 2011 07:29:55 GMT+0900 (JST) |
