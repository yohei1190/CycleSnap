# CycleSnap
<img src="./Docs/Logos/logo.PNG" width="500">

Cycle Snapは、写真で簡単に小さな変化を記録できるアプリです。
// App Store Link...


## アプリを作った背景
私の座右の銘は「水滴穿石」です。日常の習慣をコツコツと続けることで、小さな変化が積み重なり、大きな目標に向かって前進することができると信じています。
しかし、習慣を続けることは簡単ではありません。その理由の一つとして、習慣による成果や変化が目に見えにくいことが原因ではないかと考えています。

そこで、この「Cycle Snap」アプリを開発しました。
習慣の成果を写真として残し、その変化を一目で確認できることで、習慣を続けるモチベーションを保つ手助けをすることが目的です。
このアプリで、多くの方々の習慣を続けるお手伝いができれば幸いです。

## 使用技術
Swift、SwiftUI、Realm、Swift Package Manager

## 環境
macOS 13.6

Xcode 14.3 (Swift 5.8)

Swift Package Manager

## 構成
言語: Swift

UIの実装: SwiftUI

アーキテクチャ: MVVM

ブランチモデル: GitHub flow

## スクリーンショット

  ### ライトモード
  
  |カテゴリー一覧画面|写真一覧タブ|写真詳細シート|
  |:--:|:--:|:--:|
  |<img src="./Docs/ScreenShots/カテゴリー一覧.PNG" width="207">|<img src="./Docs/ScreenShots/写真一覧タブ.PNG" width="207">|<img src="./Docs/ScreenShots/写真詳細シート.PNG" width="207">| 
  |カテゴリーは自由に並べ替えが可能です|写真は新しい順、古い順に並べ替えが可能です。|左右スワイプで隣の写真に移動できます。|
  
  |カメラ撮影画面|写真比較タブ|
  |:--:|:--:|
  |<img src="./Docs/ScreenShots/カメラ撮影画面.PNG" width="207">|<img src="./Docs/ScreenShots/写真比較タブ.PNG" width="207">|
  |前回の写真をoverlayしながら撮影することで、同じアングルから撮影できます。透明度はスライダーで調整が可能です。|最新の写真と最古の写真をoverlayで重ねながら比較することができます。透明度はスライダーで調整が可能です。|
  