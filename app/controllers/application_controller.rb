require 'set'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize
  helper_method :user_is_admin

  protected

  skip_before_action :verify_authenticity_token

def authorize
  path_without_format = request.path.gsub(/\.[^\/]+\z/, '')
  scaffold0 = path_without_format.split('/')
  scaffold = '/' + scaffold0[1].to_s

  allowedURL = ['/admin', '/chooseBodega', '/saveChoose', '/findCliente', '/dashboard']
  allowedURL += ['/findTipoPago', '/findFactura', '/findProductosByProvider', '/newCliente.1', '/findProduct',
                 '/findMedida', '/findDetalleMedida']
  allowedURL += ['/findBodegas', '/findProveedor', '/saveMovProduct', '/saveOrder', '/unloadOrder', '/unloadMovProd',
                 '/getDoctosByUserAndDate', '/despachar']
  inDevelopment = ['/opcions', '/print', '/saveCartOrder', '/productosView2', '/writeExcel', '/proyectos', '/tareas',
                   '/subproyectos', '/avanceProyecto']
  inDevelopment += ['/finalizarTarea', '/addDescripcion', '/puntoventaMiniSuper', '/productoStock', '/bancos', '/bancos.json',
                    '/cotizacion', '/cotizaciones']
  allowedURL += inDevelopment

  if scaffold == '/cliente_proveedor_tipo'
    if scaffold0[2] == 'new.1'
      scaffold = '/cliente_proveedor_tipo/1'
    elsif scaffold0[2] == 'new.2'
      scaffold = '/cliente_proveedor_tipo/2'
    else
      scaffold += '/' + scaffold0[2].to_s
    end
  elsif scaffold == '/cliente_proveedors'
    scaffold = '/cliente_proveedor_tipo/1'
  end

  user = Usuario.find_by(id: session[:user_id])
  user_urls = session[:user_url].to_s

  unless user && (allowedURL.include?(scaffold) || user_urls.include?(scaffold))
    redirect_to login_url, alert: 'Tu no tienes permiso de estar aqui.'
  end
end

  helper_method :catalog_user_logged_in?, :current_catalog_user, :current_catalog_phone

def current_catalog_phone
  session[:catalog_phone].presence || params[:phone].presence
end

  helper_method :current_open_cashbox

def current_open_cashbox
  return @current_open_cashbox if defined?(@current_open_cashbox)

  @current_open_cashbox = Caja.where(usuario_id: session[:user_id], Estado: [false, nil]).last
end

def current_catalog_user
  return @current_catalog_user if defined?(@current_catalog_user)

  phone = current_catalog_phone
  @current_catalog_user =
    if phone.present?
      Usuario.find_by(Telefono: phone.to_i, Estado: true) ||
      Usuario.find_by(Telefono1: phone.to_i, Estado: true)
    else
      nil
    end
end

def catalog_user_logged_in?
  current_catalog_user.present?
end

  def user_is_admin
    roles = session[:role_name].split('-').reject { |role| role.size <= 0 }.map { |role| role.upcase }
    roles.include? 'ADMIN'
  end

  def authorize_module(id)
    redirect_to admin_url, alert: 'Tu no tienes permiso de estar aqui.' unless session[:user_option].include? id
  end
end
