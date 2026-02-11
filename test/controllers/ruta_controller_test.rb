require 'test_helper'

class RutaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rutum = ruta(:one)
  end

  test "should get index" do
    get ruta_url
    assert_response :success
  end

  test "should get new" do
    get new_rutum_url
    assert_response :success
  end

  test "should create rutum" do
    assert_difference('Rutum.count') do
      post ruta_url, params: { rutum: { actualizado: @rutum.actualizado, actualizado_por: @rutum.actualizado_por, creado: @rutum.creado, creado_por: @rutum.creado_por, nombre: @rutum.nombre, piloto: @rutum.piloto, status: @rutum.status } }
    end

    assert_redirected_to rutum_url(Rutum.last)
  end

  test "should show rutum" do
    get rutum_url(@rutum)
    assert_response :success
  end

  test "should get edit" do
    get edit_rutum_url(@rutum)
    assert_response :success
  end

  test "should update rutum" do
    patch rutum_url(@rutum), params: { rutum: { actualizado: @rutum.actualizado, actualizado_por: @rutum.actualizado_por, creado: @rutum.creado, creado_por: @rutum.creado_por, nombre: @rutum.nombre, piloto: @rutum.piloto, status: @rutum.status } }
    assert_redirected_to rutum_url(@rutum)
  end

  test "should destroy rutum" do
    assert_difference('Rutum.count', -1) do
      delete rutum_url(@rutum)
    end

    assert_redirected_to ruta_url
  end
end
