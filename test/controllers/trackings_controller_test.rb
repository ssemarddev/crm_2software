require 'test_helper'

class TrackingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tracking = trackings(:one)
  end

  test "should get index" do
    get trackings_url
    assert_response :success
  end

  test "should get new" do
    get new_tracking_url
    assert_response :success
  end

  test "should create tracking" do
    assert_difference('Tracking.count') do
      post trackings_url, params: { tracking: { ClienteProveedor_id: @tracking.ClienteProveedor_id, Estado_id: @tracking.Estado_id, actualizado: @tracking.actualizado, actualizado_por: @tracking.actualizado_por, creado: @tracking.creado, creado_por: @tracking.creado_por, descripcion: @tracking.descripcion, direccionDestion: @tracking.direccionDestion, direccionOrigen: @tracking.direccionOrigen, numero: @tracking.numero, state: @tracking.state } }
    end

    assert_redirected_to tracking_url(Tracking.last)
  end

  test "should show tracking" do
    get tracking_url(@tracking)
    assert_response :success
  end

  test "should get edit" do
    get edit_tracking_url(@tracking)
    assert_response :success
  end

  test "should update tracking" do
    patch tracking_url(@tracking), params: { tracking: { ClienteProveedor_id: @tracking.ClienteProveedor_id, Estado_id: @tracking.Estado_id, actualizado: @tracking.actualizado, actualizado_por: @tracking.actualizado_por, creado: @tracking.creado, creado_por: @tracking.creado_por, descripcion: @tracking.descripcion, direccionDestion: @tracking.direccionDestion, direccionOrigen: @tracking.direccionOrigen, numero: @tracking.numero, state: @tracking.state } }
    assert_redirected_to tracking_url(@tracking)
  end

  test "should destroy tracking" do
    assert_difference('Tracking.count', -1) do
      delete tracking_url(@tracking)
    end

    assert_redirected_to trackings_url
  end
end
