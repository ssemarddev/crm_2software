require 'test_helper'

class AutoSatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auto_sat = auto_sats(:one)
  end

  test "should get index" do
    get auto_sats_url
    assert_response :success
  end

  test "should get new" do
    get new_auto_sat_url
    assert_response :success
  end

  test "should create auto_sat" do
    assert_difference('AutoSat.count') do
      post auto_sats_url, params: { auto_sat: { Actual: @auto_sat.Actual, Bodega_id: @auto_sat.Bodega_id, Estado: @auto_sat.Estado, Fin: @auto_sat.Fin, Inicio: @auto_sat.Inicio, Numero_autorizacion: @auto_sat.Numero_autorizacion, Serie: @auto_sat.Serie, actualizado: @auto_sat.actualizado, actualizado_por: @auto_sat.actualizado_por, creado: @auto_sat.creado, creado_por: @auto_sat.creado_por } }
    end

    assert_redirected_to auto_sat_url(AutoSat.last)
  end

  test "should show auto_sat" do
    get auto_sat_url(@auto_sat)
    assert_response :success
  end

  test "should get edit" do
    get edit_auto_sat_url(@auto_sat)
    assert_response :success
  end

  test "should update auto_sat" do
    patch auto_sat_url(@auto_sat), params: { auto_sat: { Actual: @auto_sat.Actual, Bodega_id: @auto_sat.Bodega_id, Estado: @auto_sat.Estado, Fin: @auto_sat.Fin, Inicio: @auto_sat.Inicio, Numero_autorizacion: @auto_sat.Numero_autorizacion, Serie: @auto_sat.Serie, actualizado: @auto_sat.actualizado, actualizado_por: @auto_sat.actualizado_por, creado: @auto_sat.creado, creado_por: @auto_sat.creado_por } }
    assert_redirected_to auto_sat_url(@auto_sat)
  end

  test "should destroy auto_sat" do
    assert_difference('AutoSat.count', -1) do
      delete auto_sat_url(@auto_sat)
    end

    assert_redirected_to auto_sats_url
  end
end
