require 'test_helper'

class RoleUsuariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @role_usuario = role_usuarios(:one)
  end

  test "should get index" do
    get role_usuarios_url
    assert_response :success
  end

  test "should get new" do
    get new_role_usuario_url
    assert_response :success
  end

  test "should create role_usuario" do
    assert_difference('RoleUsuario.count') do
      post role_usuarios_url, params: { role_usuario: { Estado: @role_usuario.Estado, actualizado: @role_usuario.actualizado, actualizado_por: @role_usuario.actualizado_por, creado: @role_usuario.creado, creado_por: @role_usuario.creado_por, role_id: @role_usuario.role_id, usuario_id: @role_usuario.usuario_id } }
    end

    assert_redirected_to role_usuario_url(RoleUsuario.last)
  end

  test "should show role_usuario" do
    get role_usuario_url(@role_usuario)
    assert_response :success
  end

  test "should get edit" do
    get edit_role_usuario_url(@role_usuario)
    assert_response :success
  end

  test "should update role_usuario" do
    patch role_usuario_url(@role_usuario), params: { role_usuario: { Estado: @role_usuario.Estado, actualizado: @role_usuario.actualizado, actualizado_por: @role_usuario.actualizado_por, creado: @role_usuario.creado, creado_por: @role_usuario.creado_por, role_id: @role_usuario.role_id, usuario_id: @role_usuario.usuario_id } }
    assert_redirected_to role_usuario_url(@role_usuario)
  end

  test "should destroy role_usuario" do
    assert_difference('RoleUsuario.count', -1) do
      delete role_usuario_url(@role_usuario)
    end

    assert_redirected_to role_usuarios_url
  end
end
