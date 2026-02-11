require 'test_helper'

class SubproyectosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subproyecto = subproyectos(:one)
  end

  test "should get index" do
    get subproyectos_url
    assert_response :success
  end

  test "should get new" do
    get new_subproyecto_url
    assert_response :success
  end

  test "should create subproyecto" do
    assert_difference('Subproyecto.count') do
      post subproyectos_url, params: { subproyecto: { actualizado: @subproyecto.actualizado, actualizado_por: @subproyecto.actualizado_por, creado: @subproyecto.creado, creado_por: @subproyecto.creado_por, estado: @subproyecto.estado, nombre: @subproyecto.nombre, proyecto_id: @subproyecto.proyecto_id } }
    end

    assert_redirected_to subproyecto_url(Subproyecto.last)
  end

  test "should show subproyecto" do
    get subproyecto_url(@subproyecto)
    assert_response :success
  end

  test "should get edit" do
    get edit_subproyecto_url(@subproyecto)
    assert_response :success
  end

  test "should update subproyecto" do
    patch subproyecto_url(@subproyecto), params: { subproyecto: { actualizado: @subproyecto.actualizado, actualizado_por: @subproyecto.actualizado_por, creado: @subproyecto.creado, creado_por: @subproyecto.creado_por, estado: @subproyecto.estado, nombre: @subproyecto.nombre, proyecto_id: @subproyecto.proyecto_id } }
    assert_redirected_to subproyecto_url(@subproyecto)
  end

  test "should destroy subproyecto" do
    assert_difference('Subproyecto.count', -1) do
      delete subproyecto_url(@subproyecto)
    end

    assert_redirected_to subproyectos_url
  end
end
