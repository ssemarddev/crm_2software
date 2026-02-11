require 'test_helper'

class OpcionRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @opcion_role = opcion_roles(:one)
  end

  test "should get index" do
    get opcion_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_opcion_role_url
    assert_response :success
  end

  test "should create opcion_role" do
    assert_difference('OpcionRole.count') do
      post opcion_roles_url, params: { opcion_role: { Estado: @opcion_role.Estado, actualizado: @opcion_role.actualizado, actualizado_por: @opcion_role.actualizado_por, creado: @opcion_role.creado, creado_por: @opcion_role.creado_por, opcion_id: @opcion_role.opcion_id, role_id: @opcion_role.role_id } }
    end

    assert_redirected_to opcion_role_url(OpcionRole.last)
  end

  test "should show opcion_role" do
    get opcion_role_url(@opcion_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_opcion_role_url(@opcion_role)
    assert_response :success
  end

  test "should update opcion_role" do
    patch opcion_role_url(@opcion_role), params: { opcion_role: { Estado: @opcion_role.Estado, actualizado: @opcion_role.actualizado, actualizado_por: @opcion_role.actualizado_por, creado: @opcion_role.creado, creado_por: @opcion_role.creado_por, opcion_id: @opcion_role.opcion_id, role_id: @opcion_role.role_id } }
    assert_redirected_to opcion_role_url(@opcion_role)
  end

  test "should destroy opcion_role" do
    assert_difference('OpcionRole.count', -1) do
      delete opcion_role_url(@opcion_role)
    end

    assert_redirected_to opcion_roles_url
  end
end
