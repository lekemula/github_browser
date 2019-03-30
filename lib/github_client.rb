class GithubClient
  include HTTParty
  base_uri 'api.github.com'
  debug_output $stdout if Rails.env.development?

  def search_repositories(term:)
    self.class.get("/search/repositories", query: { q: term })
  end
end