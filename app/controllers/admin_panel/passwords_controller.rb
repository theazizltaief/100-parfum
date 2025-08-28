module AdminPanel
  class PasswordsController < Devise::PasswordsController
    # Optionnel : Ajouter une vérification avant de permettre la réinitialisation
    before_action :restrict_to_admins, only: [ :create ]

    private

    def restrict_to_admins
      unless Admin.exists?(email: params[:admin][:email])
        redirect_to new_admin_session_path, alert: "Cet e-mail n'est pas autorisé."
      end
    end

    # Optionnel : Personnaliser la redirection après envoi du lien
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_admin_session_path
    end
  end
end
