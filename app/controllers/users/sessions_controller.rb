class Users::SessionsController < Devise::SessionsController
  layout 'devise'

  def new
    # Limpa mensagens flash de "unauthenticated" quando acessa a página de login
    flash.clear if flash[:alert]&.include?("Faça login para acessar")
    super
  end

  def create
    super
  end

  def destroy
    super
  end
end