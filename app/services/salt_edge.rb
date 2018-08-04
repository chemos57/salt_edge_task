require "json"
require "base64"
require "openssl"
require "digest"
require "net/http"
require "uri"

class SaltEdge
  attr_reader :app_id, :secret, :private_key

  def initialize(app_id, secret, private_pem_path)
    @app_id = app_id
    @secret = secret
    @private_key = OpenSSL::PKey::RSA.new(File.open(private_pem_path))
  end

  def request(method, url)
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["App-Id"] = app_id 
    request["Secret"] = secret
    id = url.split("/") 
    # if it's a customer we must add identifier to request
    if id.last == "customers"
      request.body = JSON.dump({
        "data" => {
          "identifier" => "" + SecureRandom.hex(5) + ""
        }
      })
    end

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    puts response.body
    return JSON.parse(response.body)
  end
  
  private

  def as_json(params)
    return "" if params.empty?
    params.to_json
  end
end