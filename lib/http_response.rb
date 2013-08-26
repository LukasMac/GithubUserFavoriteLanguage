require 'rubygems'
require 'net/https'
require 'json'

class HTTPResponse
  GITHUB_USER_REPOS_URL = 'https://api.github.com/users/:user/repos'

  def self.get_user_repos(username)
    url = GITHUB_USER_REPOS_URL.gsub(/:user/, username)
    response = self.get(url)
    repos = JSON.parse(response.body)

    if repos.is_a?(Hash) && repos["message"] == "Not Found"
      []
    else
      repos
    end
  end

private 

  def self.get url
    uri = URI.parse(URI::escape(url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.get(uri.request_uri)
  end
end