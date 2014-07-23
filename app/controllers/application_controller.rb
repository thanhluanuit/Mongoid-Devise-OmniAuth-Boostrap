class ApplicationController < ActionController::Base
  protect_from_forgery

  ###
  # Method is implemented after login success
  # Params: resource is information of User
  # Callback to user_path
  ###
  def after_sign_in_path_for(resource)
  	@user = resource  	
	  index_path || users_path
	end
end
