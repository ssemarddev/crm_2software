require 'test_helper'

class BodegausersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bodegauser = bodegausers(:one)
  end

  test "should get index" do
    get bodegausers_url
    assert_response :success
  end

  test "should get new" do
    get new_bodegauser_url
    assert_response :success
  end

  test "should create bodegauser" do
    assert_difference('Bodegauser.count') do
      post bodegausers_url, params: { bodegauser: { actualizado: @bodegauser.actualizado, actualizado_por: @bodegauser.actualizado_por, bodega_id: @bodegauser.bodega_id, creado: @bodegauser.creado, creado_por: @bodegauser.creado_por, status: @bodegauser.status, usuario_id: @bodegauser.usuario_id } }
    end

    assert_redirected_to bodegauser_url(Bodegauser.last)
  end

  test "should show bodegauser" do
    get bodegauser_url(@bodegauser)
    assert_response :success
  end

  test "should get edit" do
    get edit_bodegauser_url(@bodegauser)
    assert_response :success
  end

  test "should update bodegauser" do
    patch bodegauser_url(@bodegauser), params: { bodegauser: { actualizado: @bodegauser.actualizado, actualizado_por: @bodegauser.actualizado_por, bodega_id: @bodegauser.bodega_id, creado: @bodegauser.creado, creado_por: @bodegauser.creado_por, status: @bodegauser.status, usuario_id: @bodegauser.usuario_id } }
    assert_redirected_to bodegauser_url(@bodegauser)
  end

  test "should destroy bodegauser" do
    assert_difference('Bodegauser.count', -1) do
      delete bodegauser_url(@bodegauser)
    end

    assert_redirected_to bodegausers_url
  end
end
