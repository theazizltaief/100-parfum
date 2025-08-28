module AdminPanel
  class ApplicationController < ::ApplicationController
    # S'assure que les controllers admin héritant d'ici demandent un admin authentifié.
    # (Si un controller admin redéclare déjà `before_action :authenticate_admin!` ce n'est pas un problème.)
    before_action :authenticate_admin!
  end
end
