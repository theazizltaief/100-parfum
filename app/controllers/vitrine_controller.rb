# app/controllers/vitrine_controller.rb

class VitrineController < ApplicationController
  layout "vitrine1"

  def accueil
    # Par défaut, accueil
  end

  def contact
    # Action pour la page de contact
    # Vous pouvez ajouter ici toute logique nécessaire
  end



  # Nouvelle action pour afficher les détails d'une marque dans la vitrine
  def show_brand
    @brand_id = params[:id]
    # Aucune logique de récupération de données ici.
    # Le contrôleur Stimulus 'brand_perfumes' s'en chargera côté client.
  end
  def all_brands
    @brands = Brand.all
    # Vous pouvez ajouter des filtres ou tri si nécessaire
    # @brands = Brand.where(active: true).order(:name)
  end
  def category_perfumes
    # Cette action ne fait que rendre la vue.
    # La logique de récupération et de filtrage des parfums sera gérée côté client par Stimulus.
  end

  # NOUVELLE MÉTHODE : Action pour afficher les détails d'un parfum
  def show_parfum
    @parfum = Parfum.find_by(id: params[:id])

    if @parfum.nil?
      flash[:alert] = "Le parfum demandé n'existe pas."
      redirect_to vitrine_accueil_path # Redirige vers l'accueil de la vitrine
      return # Arrête l'exécution de l'action pour éviter de rendre la vue avec @parfum = nil
    end

    # Récupérer les parfums associés de la même marque (exclure le parfum actuel)
    if @parfum.brand
      @associated_parfums = @parfum.brand.parfums.where.not(id: @parfum.id).limit(4)
    else
      @associated_parfums = []
    end
  end

  # NOUVELLE MÉTHODE : Action pour afficher le panier
  def cart
    # Cette action ne fait que rendre la vue.
    # La logique d'affichage des articles du panier sera gérée par Stimulus côté client.
  end

  # NOUVELLE MÉTHODE : Action pour afficher tous les parfums
  def all_perfumes
    # Cette action ne fait que rendre la vue.
    # La logique de récupération et de filtrage des parfums sera gérée côté client par Stimulus.
  end

  def checkout
    # Récupère les données du panier depuis les paramètres ou la session
    @cart_items = params[:cart_items] ? JSON.parse(params[:cart_items]) : []

    # Si c'est un "Acheter maintenant", récupère le produit spécifique
    if params[:parfum_id].present?
      parfum = Parfum.find(params[:parfum_id])
      # CORRIGÉ : Récupération correcte de l'image
      image_url = if parfum.image.attached?
                    rails_blob_path(parfum.image)
      else
                    "/placeholder.svg?height=50&width=50&text=P"
      end

      @cart_items = [ {
        "id" => parfum.id.to_s,
        "name" => parfum.name,
        "price" => parfum.prix.to_f,
        "imageUrl" => image_url,  # CORRIGÉ : Utilisation de la variable image_url
        "quantity" => (params[:quantity] || 1).to_i
      } ]
    end

    # Calcule les totaux
    @subtotal = @cart_items.sum { |item| item["price"].to_f * item["quantity"].to_i }
    @delivery_fee = @subtotal >= 250 ? 0 : 8
    @total = @subtotal + @delivery_fee

    @order = Order.new
  end

  def process_checkout
    @order = Order.new(order_params)

    # Récupère les articles du panier
    cart_items = JSON.parse(params[:cart_items_data])
    @order.items = cart_items

    # Calcule les totaux
    subtotal = cart_items.sum { |item| item["price"].to_f * item["quantity"].to_i }
    delivery_fee = subtotal >= 250 ? 0 : 8
    total = subtotal + delivery_fee

    @order.subtotal = subtotal
    @order.delivery_fee = delivery_fee
    @order.total_amount = total
    @order.status = "pending"

    if @order.save
      # Redirige vers la page de confirmation
      redirect_to vitrine_order_confirmation_path(@order)
    else
      # Recharge la page checkout avec les erreurs
      @cart_items = cart_items
      @subtotal = subtotal
      @delivery_fee = delivery_fee
      @total = total
      render :checkout
    end
  end

  def order_confirmation
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:first_name, :last_name, :phone, :address, :city, :postal_code, :notes)
  end
end
