class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
    render :new, layout: "login"
  end

  def create
    usuario = Usuario.find_by(User_Name: params[:User_Name], :Estado => true)
    empresa = Empresa.all.first
    if usuario and usuario.authenticate(params[:Password])
      session[:user_id]     = usuario.id
      session[:user_name]   = usuario.User_Name
      session[:name]        = usuario.Nombres
      session[:descuento]   = usuario.Porcentaje_Descuento
      session[:version]     = empresa.version
      session[:factNegativ] = empresa.facturaNegativos
      session[:dominio]     = empresa.domain
      session[:desplegableProducto] = empresa.desplegableProducto
      session[:desplegableNit]      = empresa.desplegableNit

      session[:access_lvl]  = usuario.Nivel_Acceso
      #if(usuario.Nivel_Acceso == 3)
      #  session[:access_lvl] = [:show, :edit, :update, :destroy, :save, :new, :create, :index]
      #elsif(usuario.Nivel_Acceso == 2)
      #  session[:access_lvl] = [:show, :edit, :update, :save, :new, :create, :index]
      #elsif(usuario.Nivel_Acceso == 1)
      session[:access_lvl]  = usuario.Nivel_Acceso
      #end
      session[:role_name]   = ""
      session[:user_option] = []
      session[:user_url]    = []
      role_user = RoleUsuario.where(:usuario_id => usuario.id, :Estado => true)
      role_user.each do |role|
        role                 = Role.find_by(id: role.role_id, :Estado => true)
        role_option          = OpcionRole.where(:role_id => role.id, :Estado => true)
        session[:role_name] += "-"+role.Nombre.to_s
        role_option.each do |option|
          session[:user_option].push(option.opcion_id)
          session[:user_url].push(option.opcion.LetraConjunto)
        end
      end
      usuario.Ultimo_Login = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      usuario.save

      @productos_list ||= Producto.where(estado: true)
      redirect_to chooseBodega_url(), alert: "User logged in :D "+session[:role_name]

    else
      redirect_to login_url, alert: "Invalid user/password combination"
    end
  end

  
  def logout
    session[:user_id] = nil
    redirect_to login_url, alert: "User logged out D:"
  end
end
