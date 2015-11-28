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
