#encoding: utf-8
module Oauth2China
  class QQ < Oauth2China::Base
    def initialize(access_token, clientid, openid)
      @conn = Faraday.new(:url => 'https://openmobile.qq.com') do |faraday|
        faraday.request  :multipart
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      @tmpl = Hashie::Mash.new({
        oauth_consumer_key: clientid,
        access_token: access_token,
        openid: openid,
        format: "json"
      })
    end

    def get_inform
      params = @tmpl.clone
      res = @conn.post("/user/get_simple_userinfo", params.to_hash).body
      Hashie::Mash.new(JSON.parse res)
    end
  end
end