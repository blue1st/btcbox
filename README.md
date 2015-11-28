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


オブジェクト生成時に必要に応じてAPIキーをつっこんでおく。

第一引数でコインの種類を指定（デフォルトはBitCoin）、あとはAPIに応じて指定する感じ。

```Ruby
require 'btcbox'

btc = Btcbox::Client.new(PUBLIC_KEY,  SECRET_KEY)

btc.ticker(["btc"|"ltc"|"doge"])

btc.depth(["btc"|"ltc"|"doge"])

btc.orders(["btc"|"ltc"|"doge"])

btc.balance()

btc.wallet(["btc"|"ltc"|"doge"])

btc.trade_list(["btc"|"ltc"|"doge"], [since], ["open"|"all"] )
#第二引数としてunixtimeを入れると、その時点以降の一覧となる
#第三引数は"open"を指定すると未完了の注文のみ、"all"だと完了したものやキャンセルしたものを含めた一覧が返る

btc.trade_view(["btc"|"ltc"|"doge"], id)
#第二引数にtrade_listなどで取得したidを指定する

btc.trade_cancel(["btc"|"ltc"|"doge"], id)
#第二引数にtrade_listなどで取得したidを指定する

btc.trade_add(["btc"|"ltc"|"doge"], amount, price, ["buy"|"sell"])
#第二引数に個数、第三引数価格、第四引数に売買のいずれかを指定する
```

みたいな感じ。

戻り値の子細は公式のドキュメントを見るとよい。

[Btcbox > API]("https=>//www.btcbox.co.jp/help/api.html")


## Contributing

1. Fork it ( https://github.com/[my-github-username]/btcbox/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
