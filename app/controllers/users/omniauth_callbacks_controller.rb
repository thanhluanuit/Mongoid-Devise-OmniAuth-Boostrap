class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  ##
  # Method: Handle the callback from provider (facebook/twitter)
  # Parameters::(Hash) Authentication Hash contains info returned from provider
  # Return::None
  ##
  def facebook
    handle_omniauth_callback(request.env["omniauth.auth"])
  end

  ##
  # Method: Handle the callback from provider (facebook/twitter)
  # Parameters::(Hash) Authentication Hash contains info returned from provider
  # Return::None
  ##
  def twitter
    handle_omniauth_callback(request.env['omniauth.auth'])
  end

  def failure
    set_flash_message :alert, :failure, :kind => OmniAuth::Utils.camelize(failed_strategy.name), :reason => failure_message
    redirect_to after_omniauth_failure_path_for(resource_name)
  end
  protected

  def failed_strategy
    env["omniauth.error.strategy"]
  end

  def failure_message
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error        if exception.respond_to?(:error)
    error ||= env["omniauth.error.type"].to_s
    error.to_s.humanize if error
  end

  def after_omniauth_failure_path_for(scope)
    new_session_path(scope)
  end

  private
  
  ##
  # Method: Handle the callback from provider (facebook/twitter)
  # Parameters::(Hash) Authentication Hash contains info returned from provider
  # Return::None
  ##
  def handle_omniauth_callback(auth)
    # Try to find authentication first
    
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    provider = auth['provider'] || 'Unknown'

    if authentication      
      # Sign in and direct to previous page
      sign_in_and_redirect authentication.user, :event => :authentication
      set_flash_message(:notice, :success, :kind => auth["facebook"]) if is_navigational_format?
    
    else
      # Authentication not found, thus a new user.
      @user = User.new            
      @user.apply_omniauth(auth)
      
      # Assign to form new
      @info = {
        :email => @user.email
      }       

      # Check and create
      if @user.save
        flash[:notice] = "Logged in."
        sign_in_and_redirect User.find(@user.id)
      else
        session["devise.#{auth["provider"]}_data"] = auth.except("extra")
        render :template => "devise/registrations/new"        
      end   
    end
  end

end

