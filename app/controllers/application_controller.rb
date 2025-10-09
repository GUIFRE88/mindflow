class ApplicationController < ActionController::Base
  # Configuração para redirecionamento após logout
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
