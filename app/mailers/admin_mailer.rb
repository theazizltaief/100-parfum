class AdminMailer < ApplicationMailer
  default from: "no-reply@bissofragrance.com" # Change en prod avec ton email fourni

  def invitation_instructions(admin, password)
    @admin = admin
    @password = password
    mail(to: @admin.email, subject: "Invitation à rejoindre l'équipe Kmar perfume comme admin")
  end
end
