# README

本アプリケーションはポートフォリオ用のアプリケーションです。  
Title:Homo ludens Network(ホモルーデンス ネットワーク)  
概要:新しく趣味を初めようとする人が、既に初めていて自信のある方から少額の謝礼金を支払って教えてもらうサイト  
  
作成の背景:私がカメラ趣味があり、これから始めようと考えている友人にアドバイスを行ったところ、非常に喜ばれたからです。  
教えてくれる方が近くにいればいいですが、ほとんどの場合そうは限らないのでこのようなサイトがあると便利ではないかと思い作成に至りました。  

動作環境URL:http://52.199.59.149/  

＜サーバーサイド＞  
本番環境       AWS  
WEBサーバー    Apache  
データベース    MySQL  
言語	        Ruby  
フレームワーク	  Ruby On Rails  
使用Gem	      devise、refile、refile-mini_magick、bootstrap、view_source_map、  
             annotate、kaminari、better_errors、binding_of_caller、pry-byebug、font-awesome-sass"  
	  
＜フロントエンド＞	  
CSSフレームワーク	  Bootstrap、Sass    
JavaScriptライブラリ	(JQuery、Chart.js)＊現段階では使用していません。将来的に使用予定  
  
<ローカル環境での動作させ方>
1.遊びの新規登録時、カテゴリの選択が必要になります。MySQL環境では、以下のSQLをご利用ください。  
// テストデータ カテゴリ
insert into categories (category_name, created_at, updated_at) values ("インドア","2019-07-20 17:00:00","2019-07-20 17:00:00");  
insert into categories (category_name, created_at, updated_at) values ("アウトドア","2019-07-20 17:00:00","2019-07-20 17:00:00");  
insert into categories (category_name, created_at, updated_at) values ("マリンスポーツ","2019-07-20 17:00:00","2019-07-20 17:00:00");  

2.本システムは消費税計算をDBの値をもとに実施
しております。必ず1件以上の消費税レコードがないとエラーになりますので、以下のSQLをご利用ください
insert into taxes (tax, tax_start_day, tax_finish_day, created_at, updated_at) values (0.08,"2019-07-15 01:00:00","2019-09-30 23:59:59","2019-07-20 17:00:00","2019-07-20 17:00:00");  
insert into taxes (tax, tax_start_day, tax_finish_day, created_at, updated_at) values (0.1,"2019-10-01 00:00:00","2033-10-15 23:59:59","2019-07-20 17:00:00","2019-07-20 17:00:00");  
