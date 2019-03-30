require 'rails_helper'

RSpec.describe RepositorySearcher do
  let(:search_term) { 'Ruby Is Awesome!' }
  subject { described_class.new(term: search_term) }

  before do
    stub_request(:get, /http:\/\/api.github.com\/search\/repositories/).to_return(
      body: File.read(Rails.root.join('spec', 'fixtures', 'search_repos_response.json')),
      headers: { 'Content-Type' => 'application/json; charset=utf-8' }
    )
  end

  describe '#call' do
    it 'returns a list of Repositories' do
      expect(subject.call).to all(be_an(Repository))
    end

    context 'status 404 returned' do
      before do
        stub_request(:get, /http:\/\/api.github.com\/search\/repositories/).to_return(status: 404)
      end

      it 'raises BaseError' do
        expect{ subject.call }.to raise_error(RepositorySearcher::BaseError)
      end
    end 

    context 'Github API unreachable' do
      before { allow_any_instance_of(GithubClient).to receive(:search_repositories).and_raise(HTTParty::Error) }

      it 'raises unreachableError' do
        expect{ subject.call }.to raise_error(RepositorySearcher::UnreachableError)
      end
    end

    context 'status from 500 to 600 returned' do
      before do
        stub_request(:get, /http:\/\/api.github.com\/search\/repositories/).to_return(status: rand(500..600))
      end

      it 'raises EndpointFailedError' do
        expect{ subject.call }.to raise_error(RepositorySearcher::EndpointFailedError)
      end
    end
  end
end