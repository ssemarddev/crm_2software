require 'test_helper'

class OpcionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @opcion = opcions(:one)
  end

  test "should get index" do
    get opcions_url
    assert_response :success
  end

  test "should get new" do
    get new_opcion_url
    assert_response :success
  end

  test "should create opcion" do
    assert_difference('Opcion.count') do
      post opcions_url, params: { opcion: { Conjunto: @opcion.Conjunto, Estado: @opcion.Estado, LetraConjunto: @opcion.LetraConjunto, Nombre: @opcion.Nombre, actualizado: @opcion.actualizado, actualizado_por: @opcion.actualizado_por, creado: @opcion.creado, creado_por: @opcion.creado_por } }
    end

    assert_redirected_to opcion_url(Opcion.last)
  end

  test "should show opcion" do
    get opcion_url(@opcion)
    assert_response :success
  end

  test "should get edit" do
    get edit_opcion_url(@opcion)
    assert_response :success
  end

  test "should update opcion" do
    patch opcion_url(@opcion), params: { opcion: { Conjunto: @opcion.Conjunto, Estado: @opcion.Estado, LetraConjunto: @opcion.LetraConjunto, Nombre: @opcion.Nombre, actualizado: @opcion.actualizado, actualizado_por: @opcion.actualizado_por, creado: @opcion.creado, creado_por: @opcion.creado_por } }
    assert_redirected_to opcion_url(@opcion)
  end

  test "should destroy opcion" do
    assert_difference('Opcion.count', -1) do
      delete opcion_url(@opcion)
    end

    assert_redirected_to opcions_url
  end
end
