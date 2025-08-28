class Rack::Attack
  # === 1️⃣ Détection de l'environnement ===
  is_production = Rails.env.production?

  # === 2️⃣ Limitation pour la vitrine publique ===
  # Dév : limite très haute pour éviter de bloquer le dev
  # Prod : limite raisonnable pour protéger le site
  throttle("vitrine/ip", limit: (is_production ? 200 : 1000), period: 60) do |req|
    req.ip if req.path.start_with?("/vitrine")
  end

  # === 3️⃣ Limitation pour l'admin panel ===
  # Les admins doivent pouvoir travailler sans gêne en dev, stricte en prod
  throttle("admin_api/ip", limit: (is_production ? 50 : 200), period: 60) do |req|
    req.ip if req.path.start_with?("/admin_panel")
  end

  # === 4️⃣ Limitation pour l'API publique ===
  throttle("api_public/ip", limit: (is_production ? 100 : 500), period: 60) do |req|
    req.ip if req.path.start_with?("/api/v1/")
  end

  # === 5️⃣ Réponse personnalisée pour dépassement ===
  self.throttled_response = lambda do |env|
    match_data = env["rack.attack.match_data"]

    # Log optionnel : utile en production pour surveiller les abus
    if is_production
      Rails.logger.info "Rack::Attack Throttle triggered: #{env['REMOTE_ADDR']} for #{env['PATH_INFO']}, limit: #{match_data[:limit]}"
    end

    headers = {
      "Content-Type" => "text/plain",
      "Retry-After" => match_data[:period].to_s
    }

    [ 429, headers, [ "Trop de requêtes. Merci de réessayer après #{match_data[:period]} secondes.\n" ] ]
  end

  # === 6️⃣ Optionnel : blocage des requêtes suspectes ===
  # Exemple : bloquer certaines IP blacklistées
  # Rack::Attack.blocklist("block 1.2.3.4") { |req| req.ip == "1.2.3.4" }
end
