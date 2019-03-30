class RepositoriesController < ApplicationController
  respond_to :json

  rescue_from 'RepositorySearcher::BaseError', with: :respond_search_error

  def index
    respond_with RepositorySearcher.new(term: search_params[:term]).call
  end

  protected

  def search_params
    params.permit(:term)
  end
end
