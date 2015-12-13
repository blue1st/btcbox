require 'net/http'
require 'uri'
require 'openssl'
require 'time'
require 'json'

module Btcbox
  class Client 
    def initialize (public_key = nil, secret_key = nil, api_url = "https://www.btcbox.co.jp/api/v1")
      @public_key = public_key 
      @secret_key = secret_key
      @api_url = api_url
    end

    def fetch(uri_str, params = {}, method = "GET",limit = 10)
      uri = URI.parse(uri_str)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true if uri.port == 443

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
        if limit == 0
          raise ArgumentError, 'HTTP redirect too deep'
        else
          fetch(res["location"], params, method, limit - 1)
        end
      else
        raise ArgumentError, res.value
      end
    end

    def auth(params = {})
      raise ArgumentError, 'need keys' if !@public_key or !@secret_key
      params["key"] = @public_key
      params["nonce"] ="#{Time.now.to_i}#{'%06d' % Time.now.usec}".to_i

      algo = OpenSSL::Digest.new('sha256')
      key = Digest::MD5.hexdigest(@secret_key)
      data = URI.encode_www_form(params)
      params["signature"] = OpenSSL::HMAC.hexdigest(algo, key, data)

      params
    end

    def response_parse (json)
      raise ArgumentError,"json is not found" unless json
      res = JSON.parse json
      if res.kind_of?(Hash) and res.key?("result") and res["result"] == false
        raise ArgumentError, "error code:#{res['code']}"
      else
        res
      end
    end

    def ticker (coin = "btc")
      params = {coin:coin}
      json_str = fetch("#{@api_url}/ticker", params)
      response_parse(json_str)
    end

    def depth (coin = "btc")
      params = {coin:coin}
      json_str = fetch("#{@api_url}/depth", params)
      response_parse(json_str)
    end

    def orders (coin = "btc")
      params = {coin:coin}
      json_str = fetch("#{@api_url}/orders", params)
      response_parse(json_str)
    end


    # ReadOnly

    def balance(coin = "btc")
      params = {coin:coin}
      params = auth(params)
      json_str = fetch("#{@api_url}/balance", params, "POST")
      response_parse(json_str)
    end

    def wallet (coin = "btc")
      params = {coin:coin}
      params = auth(params)
      json_str = fetch("#{@api_url}/wallet", params, "POST")
      response_parse(json_str)
    end

    # 発注
    # since: unixtimeで
    # type: open=現在受付中, all=完了含む
    def trade_list (coin = "btc", since = 0, type = "open")
      params = {coin:coin, since:since, type:type}
      params = auth(params)
      json_str = fetch("#{@api_url}/trade_list", params, "POST")
      response_parse(json_str)
    end

    # 個別の売買について id必須
    def trade_view (coin = "btc", id)
      params = {coin:coin, id:id}
      params = auth(params)
      json_str = fetch("#{@api_url}/trade_view", params, "POST")
      response_parse(json_str)
    end


    # Full

    def trade_cancel (coin = "btc", id)
      params = {coin:coin, id:id}
      params = auth(params)
      json_str = fetch("#{@api_url}/trade_cancel", params, "POST")
      response_parse(json_str)
    end

    def trade_add (coin = "btc", amount, price, type)
      params = {coin:coin, amount:amount, price:price, type:type}
      params = auth(params)
      json_str = fetch("#{@api_url}/trade_add", params, "POST")
      response_parse(json_str)
    end

  end
end
