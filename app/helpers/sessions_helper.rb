module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token

    # Ajusta a entrada :remember_token no cookie para expirar em 20 anos.
    # O mesmo que usar cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc }
    cookies.permanent[:remember_token] = remember_token

    # update_attribute atualiza o atributo sem chamar as validações do Model.
    # update_attributes atualiza recebe um hash com atributos e novos valores, e chama as validações do Model.
    user.update_attribute(:remember_token, User.digest(remember_token))

    # Ajusta variável current_user
    self.current_user = user
  end

  def sign_out
    unless current_user.nil?
      current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
      cookies.delete(:remember_token)
      self.current_user = nil
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    # O código abaixo é necessário porque o HTTP é stateless e não grava o valor de @current_user caso o usuário acesse
    # outro site.

    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    current_user == user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

end
