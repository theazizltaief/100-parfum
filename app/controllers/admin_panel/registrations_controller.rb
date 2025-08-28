module AdminPanel
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_admin!

    # GET /admin_panel/profile/edit
    def edit
    end

    # PATCH /admin_panel/profile
    def update
      super do |resource|
        if resource.errors.empty?
          flash[:notice] = "Mot de passe mis à jour avec succès."
          redirect_to admin_panel_root_path and return
        end
      end
    end

    protected

    # Permet de ne mettre à jour que le mot de passe (ignore email si non changé)
    def update_resource(resource, params)
      if params[:password].blank? && params[:password_confirmation].blank? && params[:current_password].blank?
        resource.update_without_password(params)
      else
        resource.update_with_password(params)
      end
    end
    # Corrige le devise_mapping pour le scope :admin
    def set_minimum_password_length
      @minimum_password_length = Admin.password_length.min if Devise.mappings[:admin].validatable?
    end
    # Définir explicitement le mapping pour le scope :admin
    def devise_mapping
      Devise.mappings[:admin]
    end
  end
end
