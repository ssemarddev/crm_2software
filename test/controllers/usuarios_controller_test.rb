require 'test_helper'

class UsuariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usuario = usuarios(:one)
  end

  test "should get index" do
    get usuarios_url
    assert_response :success
  end

  test "should get new" do
    get new_usuario_url
    assert_response :success
  end

  test "should create usuario" do
    assert_difference('Usuario.count') do
      post usuarios_url, params: { usuario: { Apellidos: @usuario.Apellidos, Correo: @usuario.Correo, Estado: @usuario.Estado, Fecha_Nacimiento: @usuario.Fecha_Nacimiento, Nivel_Acceso: @usuario.Nivel_Acceso, Nombres: @usuario.Nombres, Porcentaje_Descuento: @usuario.Porcentaje_Descuento, Telefono1: @usuario.Telefono1, Telefono: @usuario.Telefono, Ultimo_Login: @usuario.Ultimo_Login, User_Name: @usuario.User_Name, actualizado: @usuario.actualizado, actualizado_por: @usuario.actualizado_por, creado: @usuario.creado, creado_por: @usuario.creado_por, password: 'secret', password_confirmation: 'secret' } }
    end

    assert_redirected_to usuario_url(Usuario.last)
  end

  test "should show usuario" do
    get usuario_url(@usuario)
    assert_response :success
  end

  test "should get edit" do
    get edit_usuario_url(@usuario)
    assert_response :success
  end

  test "should update usuario" do
    patch usuario_url(@usuario), params: { usuario: { Apellidos: @usuario.Apellidos, Correo: @usuario.Correo, Estado: @usuario.Estado, Fecha_Nacimiento: @usuario.Fecha_Nacimiento, Nivel_Acceso: @usuario.Nivel_Acceso, Nombres: @usuario.Nombres, Porcentaje_Descuento: @usuario.Porcentaje_Descuento, Telefono1: @usuario.Telefono1, Telefono: @usuario.Telefono, Ultimo_Login: @usuario.Ultimo_Login, User_Name: @usuario.User_Name, actualizado: @usuario.actualizado, actualizado_por: @usuario.actualizado_por, creado: @usuario.creado, creado_por: @usuario.creado_por, password: 'secret', password_confirmation: 'secret' } }
    assert_redirected_to usuario_url(@usuario)
  end

  test "should destroy usuario" do
    assert_difference('Usuario.count', -1) do
      delete usuario_url(@usuario)
    end

    assert_redirected_to usuarios_url
  end
end
