module ParfumsHelper
  def display_category(parfum)
    case parfum.category.to_s
    when "homme" then "Pour Homme"
    when "femme" then "Pour Femme"
    when "unisexe" then "Unisexe"
    else "Catégorie inconnue"
    end
  end

  def display_fragrance_class(parfum)
    case parfum.fragrance_class.to_s
    when "designer" then "Designer"
    when "niche" then "Niche"
    when "collection_privee" then "Collection Privée"
    else "Type inconnu"
    end
  end
end
