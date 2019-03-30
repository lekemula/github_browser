class RepositorySearcher
  BaseError = Class.new(StandardError)
  EndpointFailedError = Class.new(BaseError)
  UnreachableError = Class.new(BaseError)

  
  attr_reader :term, :client

  def initialize(term:, client: GithubClient.new)
    @term = term
    @client = client
  end

  def call
    parse_response handle_response { client.search_repositories(term: term) }
  end

  private

  def handle_response
    response = yield
    
    case response.code 
      when 200
        return response
      when 404
        raise BaseError.new('Search endpoint not found')
      when 500...600
        raise EndpointFailedError.new('API failed to return the results')
    end
  rescue HTTParty::Error
    raise UnreachableError.new('Unable to connect with endpoint')
  else
    response
  end
  
  def parse_response(response)
    response_hash = response.parsed_response
    
    parse_repositories(response_hash)
  end

  def parse_repositories(response_hash)
    response_hash['items'].map do |repository_hash|
      repository_attrs = repository_hash.slice(*%w(
        description
        watchers_count
        forks_count
        open_issues_count
      )).merge(
        :url => repository_hash['html_url'],
        :name => repository_hash['full_name'],
        :stars_count => repository_hash['stargazers_count'],
        :owner => parse_owner(repository_hash['owner'])
      )

      Repository.new(repository_attrs)
    end
  end

  def parse_owner(owner_hash)
    owner_attrs = owner_hash.slice(*%w(avatar_url url))
      .merge(:name => owner_hash['login'])

    Owner.new(owner_attrs)
  end
end