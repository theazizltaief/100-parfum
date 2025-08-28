class Admin::SessionsController < Devise::SessionsController
    # Après login
    def create
      super do |admin|
        flash[:notice] = "Connexion réussie en tant qu'administrateur"
      end
    end

    # Après logout
    def destroy
      super do
        flash[:notice] = "Déconnexion réussie"
      end
    end

    protected

    # Redirection après login
    def after_sign_in_path_for(resource)
      admin_panel_root_path
    end

    # Redirection après logout
    def after_sign_out_path_for(resource_or_scope)
      new_admin_session_path
    end
end
