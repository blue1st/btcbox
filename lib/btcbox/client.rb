require 'net/http'
require 'uri'
require 'openssl'
require 'time'

module Btcbox
  class Client 
    def initialize (public_key, secret_key, api_url = "https://www.btcbox.co.jp/api/v1")
      @public_key = public_key 
      @secret_key = secret_key
      @api_url = api_url
    end

    def fetch_api(uri_str, params = {}, method = "GET",limit = 10)
      uri = URI.parse(uri_str)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true if uri.port == 443
      raise ArgumentError, 'HTTP redirect too deep' if limit == 0

      res = nil
      case method
      when "GET"
        res = https.get(uri.request_uri+"?"+URI.encode_www_form(params))
      when "POST"
        res = https.post(uri.request_uri, URI.encode_www_form(params))
      else
        raise ArgumentError, 'unknown method'
      end

      case res
      when Net::HTTPSuccess
        res.body
      when Net::HTTPRedirection
        fetch_api(res["location"], params, method, limit - 1)
      else
        res.value
      end
    end

    def auth(params = {})
      params["key"] = @public_key

      params["nonce"] = Time.now.to_i

      algo = OpenSSL::Digest.new('sha256')
      key = Digest::MD5.hexdigest(@secret_key)
      data = URI.encode_www_form(params)
      params["signature"] = OpenSSL::HMAC.hexdigest(algo, key, data)

      params
    end

    def ticker (coin = "btc")
      params = {coin:coin}
      res = fetch_api("#{@api_url}/ticker", params)
    end

    def depth (coin = "btc")
      params = {coin:coin}
      res = fetch_api("#{@api_url}/depth", params)
    end

    def orders (coin = "btc")
      params = {coin:coin}
      res = fetch_api("#{@api_url}/orders", params)
    end


    # ReadOnly

    def balance(coin = "btc")
      params = {coin:coin}
      params = auth(params)
      res = fetch_api("#{@api_url}/balance", params, "POST")
    end

    def wallet (coin = "btc")
      params = {coin:coin}
      params = auth(params)
      res = fetch_api("#{@api_url}/wallet", params, "POST")
    end

    # 発注
    # since: unixtimeで
    # type: open=現在受付中, all=完了含む
    def trade_list (coin = "btc", since = 0, type = "open")
      params = {coin:coin, since:since, type:type}
      params = auth(params)
      res = fetch_api("#{@api_url}/trade_list", params, "POST")
    end

    # 個別の売買について id必須
    def trade_view (coin = "btc", id)
      params = {coin:coin, id:id}
      params = auth(params)
      res = fetch_api("#{@api_url}/trade_view", params, "POST")
    end


    # Full

    def trade_cancel (coin = "btc", id)
      params = {coin:coin, id:id}
      params = auth(params)
      res = fetch_api("#{@api_url}/trade_cancel", params, "POST")
    end

    def trade_add (coin = "btc", amount, price, type)
      params = {coin:coin, amount:amount, price:price, type:type}
      params = auth(params)
      res = fetch_api("#{@api_url}/trade_add", params, "POST")
    end

  end
end
