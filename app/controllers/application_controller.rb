class ApplicationController < ActionController::Base
  # Empêche les requêtes non-GET sans token CSRF (protection standard Rails)
  protect_from_forgery with: :exception

  # Crée/assure un identifiant de visiteur dans la session pour lier le panier
  before_action :ensure_visitor_session

  layout :layout_by_resource

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path # redirige vers la page de login
  end

  private

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end

  # Assure qu'un token visiteur existe dans la session (ne change pas ta logique,
  # ça permet juste d'avoir un cookie de session pour associer le panier)
  def ensure_visitor_session
    session[:visitor_token] ||= SecureRandom.uuid
  end
end
