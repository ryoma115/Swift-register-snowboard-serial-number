# やりたいこと
* 一ヶ月で作る
* できればアーキテクチュアを学びながらやりたい
* しっかり設計から考える

# 概要
スノーボードのシリアルナンバーを登録できるアプリを作成したい。盗難防止や紛失・盗難対策などにつながる。
最初はとてもシンプルな機能をつける

# 機能
* ユーザー登録
 * 名前入力
 * メールアドレス登録
 * ニックネーム登録
* マイボード登録機能
 * メーカー入力
 * シリアルナンバー入力
 * ボード写真登録
* マイボード一覧
* ボード検索機能
* 紛失サイン
* 見つけましたボタン(その詳細をメールで通知させる)



# URL

# 作成の背景
最近スノボがとても人気になりつつあり私もスノボによく行っていますが、人気がある一方で盗難や転売が増加している。それを踏まえて登録しておくことで自分のものということを証明できたり、中古で購入する際も調べて盗品ではないことを確認してから購入できることがこのアプリで可能にすることができる。


# 特に力を入れた点
共同開発を意識して、storyboardの分割を行った。その際、storyboardReference・tabBarControllerを用いてtabBarを設置した

# 使用技術・環境
* Xcode(13.2.1)
* DB(Firebaseのfirestore)
* [github](https://github.com/ryoma115/Swift-register-snowboard-serial-number)

#リリース時　準備するもの
- [x] アプリアイコン(120x120,152x152,167x167,1024x1024)
- [ ] Apple Developer Programへの参加
- [ ] App Store プレビュー(iPhone5.5インチ用,iPhone6.5インチ用,iPad Pro 12.9インチ用（第2世代/第3世代))
- [x]プライバシーポリシー[こちらから](https://sites.google.com/view/registert-snow-boads/%E3%83%9B%E3%83%BC%E3%83%A0)
- [x]問い合わせフォーム　[こちらから](https://docs.google.com/forms/d/e/1FAIpQLSdhMZGYWvfVfK-My6JZXqWKeVzkf0v67qM0WxY-_A53t9Byvg/viewform?usp=sf_link)

# 注意点
* GIDSignIn.sharedInstance()?.を入力時、GoogleSignInのバージョンが5.0.1以下の場合エラー表示になる場合があった  
解決方法　pod install時　バージョン５以上を指定する(pod 'GoogleSignIn', '~> 5.0')  
* UIButtonを用い写真の設定画面を実装しようとしたが、imagePickerControllerからのUIButton.imageView.imageで変更を試みたがうまく反映されなかった  
解決方法　UIImageにtapViewを用いて、imagePickerControllerでUIimage.imageで実装できた。  
* .getDocumentsおよび.addSnapshotListener使用する際、whereFieldとorderByを併用し用途するとデータ所得ができなくなるバグ？使用？があった  
解決方法 そのため、データ所得後に新たに制約で並べ直す必要があった
* カスタムセルを使用する際、cell = tableView.dequeueReusableCell...にダウンキャスト(as! or as?)が必要な場合がある。今回はダウンキャストしなかった際、読み込みができていなかった。
# 今後行いたいこと

# 自己紹介
