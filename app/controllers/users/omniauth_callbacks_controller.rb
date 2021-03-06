class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token, :only => [:developer,:anonymous]
  def developer
    find_or_create_user('developer')
  end
  def shibboleth
    find_or_create_user('shibboleth')
  end

  def find_or_create_user(auth_type)
    find_or_create_method = "find_or_create_for_#{auth_type.downcase}".to_sym
    logger.debug "#{auth_type} :: #{current_user.inspect}"
  	@user = User.send(find_or_create_method,request.env["omniauth.auth"], current_user)
    session[:user_name] = @user.name
    session[:user_id] = @user.uid
    if @user.persisted?
      flash[:success] = I18n.t "devise.omniauth_callbacks.success", :kind => auth_type.capitalize
      #sign_in_and_redirect @user, :event => :authentication
      sign_in @user, :event => :authentication
      redirect_to request.env['omniauth.origin'] || root_url
    else
      session["devise.#{auth_type.downcase}_data"] = request.env["omniauth.auth"]
      redirect_to request.env['omniauth.origin'] || root_url 
    end
  end
  protected :find_or_create_user
end
