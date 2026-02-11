require 'test_helper'

class CalidadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calidad = calidads(:one)
  end

  test "should get index" do
    get calidads_url
    assert_response :success
  end

  test "should get new" do
    get new_calidad_url
    assert_response :success
  end

  test "should create calidad" do
    assert_difference('Calidad.count') do
      post calidads_url, params: { calidad: { actualizado: @calidad.actualizado, actualizado_por: @calidad.actualizado_por, creado: @calidad.creado, creado_por: @calidad.creado_por, nombre: @calidad.nombre, status: @calidad.status } }
    end

    assert_redirected_to calidad_url(Calidad.last)
  end

  test "should show calidad" do
    get calidad_url(@calidad)
    assert_response :success
  end

  test "should get edit" do
    get edit_calidad_url(@calidad)
    assert_response :success
  end

  test "should update calidad" do
    patch calidad_url(@calidad), params: { calidad: { actualizado: @calidad.actualizado, actualizado_por: @calidad.actualizado_por, creado: @calidad.creado, creado_por: @calidad.creado_por, nombre: @calidad.nombre, status: @calidad.status } }
    assert_redirected_to calidad_url(@calidad)
  end

  test "should destroy calidad" do
    assert_difference('Calidad.count', -1) do
      delete calidad_url(@calidad)
    end

    assert_redirected_to calidads_url
  end
end
