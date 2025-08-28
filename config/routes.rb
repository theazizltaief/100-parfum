Rails.application.routes.draw do
  # Root publique : la vitrine
  root "vitrine#accueil"
  get "vitrine/accueil", to: "vitrine#accueil", as: :vitrine_accueil

  # Devise pour admins avec contrôleur de sessions personnalisé
  devise_for :admins, skip: [ :registrations ], path: "admin_panel", controllers: {
    sessions: "admin/sessions",
    passwords: "admin_panel/passwords"
  }


  # Namespace admin_panel pour l'espace admin
  namespace :admin_panel do
    root to: "dashboard#index" # admin_panel_root_path
    resources :parfums do
      patch :update_image, on: :member
    end
    resources :brands

    # ROUTES POUR LES COMMANDES - CORRIGÉES
    resources :orders, only: [ :index, :show, :destroy ] do
      member do
        patch :update_status
      end
    end

    # NOUVELLES ROUTES POUR LA RECHERCHE
    resources :search, only: [ :index ]

    # Routes pour changer le mot de passe (seulement edit/update)
    get "profile/edit", to: "registrations#edit", as: :edit_profile
    patch "profile", to: "registrations#update", as: :profile

    # Routes pour inviter un admin
    get "invite_admin", to: "invitations#new", as: :invite_admin
    post "invite_admin", to: "invitations#create"
  end

  # NOUVELLE ROUTE SPÉCIFIQUE POUR LA PAGE DE DÉTAILS DES PARFUMS DANS LA VITRINE
  get "vitrine/parfums/:id", to: "vitrine#show_parfum", as: :vitrine_parfum_show

  # NOUVELLE ROUTE POUR LA PAGE DE DÉTAILS DES MARQUES DANS LA VITRINE
  get "vitrine/brands/:id", to: "vitrine#show_brand", as: :vitrine_brand_show

  # NOUVELLE ROUTE POUR LA PAGE DE TOUTES LES MARQUES
  get "vitrine/brands", to: "vitrine#all_brands", as: :vitrine_all_brands

  # NOUVELLE ROUTE POUR LA PAGE DU PANIER DANS LA VITRINE
  get "vitrine/cart", to: "vitrine#cart", as: :vitrine_cart

  # NOUVELLES ROUTES POUR LE CHECKOUT
  get "vitrine/checkout", to: "vitrine#checkout", as: :vitrine_checkout
  post "vitrine/checkout", to: "vitrine#process_checkout", as: :process_checkout
  get "vitrine/order_confirmation/:id", to: "vitrine#order_confirmation", as: :vitrine_order_confirmation

  # NOUVELLE ROUTE POUR LA PAGE DE TOUS LES PARFUMS DANS LA VITRINE
  get "vitrine/all_perfumes", to: "vitrine#all_perfumes", as: :vitrine_all_perfumes

  # Route pour la page des parfums par catégorie
  get "vitrine/parfums", to: "vitrine#category_perfumes", as: :category_perfumes

  # NOUVELLE ROUTE POUR LA PAGE DE CONTACT
  get "vitrine/contact", to: "vitrine#contact", as: :vitrine_contact

  # Redirection root spécifique aux admins authentifiés
  authenticated :admin do
    root to: "admin_panel/dashboard#index", as: :authenticated_admin_root
  end

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Health check
  get "up", to: "rails/health#show", as: :rails_health_check

  # API namespace versionné (NE PAS TOUCHER)
  namespace :api do
    namespace :v1 do
      resources :brands, only: [ :index, :show ]
      resources :parfums, only: [ :index, :show ]
      get "brands_only", to: "brands#only_brands"
      resources :users, only: [ :create ]
      post "login", to: "auth#login"
      resources :orders, only: [ :create ]
      resources :cart_items, only: [ :create, :update, :destroy ]
      resources :search, only: [ :index ]
    end
  end
end
