class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception


  before_action do

    # CanCan fix
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"

    if respond_to?(method, true)
      params[resource] &&= send(method)
    elsif respond_to?('model_params', true)
      params[resource] &&= send('model_params')
    end

    # @redirect_url = params[:redirect_url] unless params[:redirect_url].nil?
  end


  rescue_from Exception do |exception|

    if exception.class == CanCan::AccessDenied
      if user_signed_in?
        session[:user_return_to] = nil

        respond_to do |format|
          format.html do
            if request.xhr?
              render json: "Not authorized for this action", status: 401
            else
              flash[:error] = "Not authorized to view this page"
              redirect_to_back
            end
          end
          format.json do
            render json: "Not authorized for this action", status: 401
          end
        end

      else
        flash[:error] = "You must first login to view this page"
        session[:user_return_to] = request.url
        redirect_to new_user_session_path
      end

    elsif Rails.env.production?
      Honeybadger.notify(exception)

      if request.xhr?
        render plain: exception.message, status: 400
      else
        render_error 500, exception
      end
    else
      raise exception
      if request.xhr?
        render plain: exception.message, status: 400
      else
        raise exception
      end
    end
  end

  def redirect_to_back(opts={})
    redirect_back(fallback_location: fallback_location)
  end

  def fallback_location
    root_path
  end

  # Allows for checking authorization on non-model controllers - see admin_controller for usage
  def require_authorization sym
    authorize! params[:action].to_sym, sym
  end

  def can(user, action, resource)
    ability.can(user, action, resource)
  end


  private
  def ability
    @ability ||= Ability.new(current_user)
  end
end
