# Btcbox

BtcboxのAPIを操作する用のライブラリ

[APIドキュメント](https://www.btcbox.co.jp/help/api.html)



## Installation

rubygemsにはまだ登録してないんで

```bash

gem install specific_install
gem specific_install -l "https://github.com/blue1st/btcbox.git"
```
## Usage

### APIキー

やりたいことに応じて必要なAPIキーをあらかじめ取得しておく。

ログイン後に「財産センター」内の「APIキーの取得」ページから取得できる。

[Btcbox > APIキーの取得]("https://www.btcbox.co.jp/api/secret/keys/")

|API|概要|APIキー|
|:---|:---|:---|
|Ticker|売り気配・買い気配・24時間での出来高など|不要|
|Depth|注文量|不要|
|Orders|オーダーブック|不要|
|Blance|アカウントの情報|読み出しのみ|
|Wallet|口座のアドレス|読み出しのみ|
|Trade List|注文一覧|読み出しのみ|
|Trade View|注文の詳細|読み出しのみ|
|Trade Cancel|注文のキャンセル|読み書き|
|Trade Add|注文の追加|読み書き|


```
require 'btcbox'

btc = Btcbox::Client.new("PUBLIC_KEY", "SECRET_KEY")

p btc.ticker("btc")
#=> {"high"=>44678, "low"=>43304, "buy"=>43399, "sell"=>43586, "last"=>43597, "vol"=>3144.1311} 

p btc.depth("ltc")
#=> {"asks"=>[[1100, 50], [1098, 30.523], [1027, 199.798], [1008, 85], [1000, 740.859], ...

p btc.orders("doge")
#=> [{"date"=>"1448008069", "price"=>0.0152, "amount"=>2017801.4164, "tid"=>"7536", "type"=>"sell"}, {"date"=>"1448008071", "price"=>0.0152, "amount"=>1440112.6136, "tid"=>"7537", "type"=>"sell"}, {"date"=>"1448018096", "price"=>0.0158, "amount"=>45818, "tid"=>"7538", "type"=>"buy"}, ... 

```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/btcbox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
