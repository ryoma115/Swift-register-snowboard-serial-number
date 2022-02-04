# 達成したいこと
* 一ヶ月で作る
* できればアーキテクチュアを学びながらやりたい
* しっかり設計から考える

# 作成の背景
最近スノボがとても人気になりつつあり私もスノボによく行っていますが、人気がある一方で盗難や転売が増加している。それを踏まえて登録しておくことで自分のものということを証明できたり、中古で購入する際も調べて盗品ではないことを確認してから購入できることがこのアプリで可能にすることができる。
[参考資料](https://rakusnow.com/sunobotounann-7486)

# 概要
スノーボードのシリアルナンバーを登録できるアプリを作成したい。盗難防止や紛失・盗難対策などにつながる。
最初はとてもシンプルな機能をつける

# 機能
* ログイン
  * Firebaseを用いたGoogle認証
  * メールアドレス取得
* マイページ
  * 紛失ボタン(ONにすることでsearchで見つけられた場合、知らせてくれる)
  * マイボード一覧(複数スノボを持つ人もいることを考え、tableviewを使用)
  * データベース情報取得
* マイボード登録
  * データベースに追加(Firebase firestore)
  * メーカー・シリアルナンバーで同じデータができないよう制御(一つのメーカーでそれぞれシリアルナンバーは一つだけ)
  * 写真をURL化するため一度storageにいれてそこからアクセス
* search (調べる)
  * 発見ボタン(緊急連絡先が登録されてた場合、知らせることができる)<br>(紛失ボタンONに限る)
  * 緊急連絡先や個人情報の流出を考え、シリアルナンバー完全一致のみに制御
* 緊急連絡先設定
  * ボードのデータとは別で管理
  * 発見された時のみに使われる
# URL

# 特に力を入れた点
* デザインを既存のアプリの良いところ積極的に取り入れ、自然に使いやすいアプリを実装した。
* 共同開発を意識して、storyboardの分割を行った。その際、storyboardReference・tabBarControllerを用いてtabBarを設置した

# 使用技術・環境
* Xcode(13.2.1)
* DB(Firebaseのfirestore)
* [github](https://github.com/ryoma115/Swift-register-snowboard-serial-number)

# リリース時　準備するもの
- [x] アプリアイコン(120x120,152x152,167x167,1024x1024)
- [ ] Apple Developer Programへの参加
- [ ] App Store プレビュー(iPhone5.5インチ用,iPhone6.5インチ用,iPad Pro 12.9インチ用（第2世代/第3世代))
- [x] プライバシーポリシー[こちらから](https://sites.google.com/view/registert-snow-boads/%E3%83%9B%E3%83%BC%E3%83%A0)
- [x] 問い合わせフォーム　[こちらから](https://docs.google.com/forms/d/e/1FAIpQLSdhMZGYWvfVfK-My6JZXqWKeVzkf0v67qM0WxY-_A53t9Byvg/viewform?usp=sf_link)

# 注意点
* GIDSignIn.sharedInstance()?.を入力時、GoogleSignInのバージョンが5.0.1以下の場合エラー表示になる場合があった  
解決方法　pod install時　バージョン５以上を指定する(pod 'GoogleSignIn', '~> 5.0')  
* UIButtonを用い写真の設定画面を実装しようとしたが、imagePickerControllerからのUIButton.imageView.imageで変更を試みたがうまく反映されなかった  
解決方法　UIImageにtapViewを用いて、imagePickerControllerでUIimage.imageで実装できた。  
* .getDocumentsおよび.addSnapshotListener使用する際、whereFieldとorderByを併用し用途するとデータ所得ができなくなるバグ？使用？があった  
解決方法 そのため、データ所得後に新たに制約で並べ直す必要があった
* カスタムセルを使用する際、cell = tableView.dequeueReusableCell...にダウンキャスト(as! or as?)が必要な場合がある。今回はダウンキャストしなかった際、読み込みができていなかった。
# 今後行いたいこと
* 今回はfirebaseAuthがviewControllerに残ってしまったので通信とviewを完全に分けることができていなかった。次はしっかり分けられるように設計を考え実行したい。
* また、実務で学ぶ経験が一番成長へ近道だと思うのでオファーがかかるように情報発信や応募を積極的に行う。
* デザインを考え、一般ユーザーが心地良いアプリの実現を目指したい。(UI・UXの向上 )
# 自己紹介
私は、19歳の学生です。今、主にプログラミングとNFTに興味を持ち勉強しています。また、海外にも興味があります。とにかく興味を持つことが多く最近は一回はなんでも挑戦することをテーマにして毎日奮闘しています。<br>[twitter](https://twitter.com/ryoma2003115)
