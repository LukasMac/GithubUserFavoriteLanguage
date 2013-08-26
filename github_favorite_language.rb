require_relative 'lib/github'

include Github

github_username = ARGV[0]
Github::favorite_language_of(github_username)