class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond_search_error(exception)
    respond_to do |format|
      format.html do
        flash[:error] = exception.message
        redirect :back
      end

      format.json { render :json => { status: :error, message: exception.message }, status: :unprocessable_entity }
    end
  end
end
