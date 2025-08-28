module AdminPanel
  class InvitationsController < ApplicationController
    before_action :authenticate_admin!

    # GET /admin_panel/invite_admin
    def new
    end

    # POST /admin_panel/invite_admin
    def create
      email = params[:email]
      if Admin.exists?(email: email)
        flash[:alert] = "Cet email est déjà utilisé par un admin existant."
        render :new, status: :unprocessable_entity
        return
      end

      password = SecureRandom.hex(10) # Génère un mot de passe sécurisé de 20 caractères (hex)
      admin = Admin.new(email: email, password: password, password_confirmation: password)

      if admin.save
        AdminMailer.invitation_instructions(admin, password).deliver_later
        flash[:notice] = "Invitation envoyée avec succès."
        redirect_to admin_panel_root_path
      else
        flash.now[:alert] = "Erreur : #{admin.errors.full_messages.join(', ')}"
        render :new, status: :unprocessable_entity
      end
    end
  end
end
