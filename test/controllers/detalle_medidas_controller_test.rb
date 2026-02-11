require 'test_helper'

class DetalleMedidasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detalle_medida = detalle_medidas(:one)
  end

  test "should get index" do
    get detalle_medidas_url
    assert_response :success
  end

  test "should get new" do
    get new_detalle_medida_url
    assert_response :success
  end

  test "should create detalle_medida" do
    assert_difference('DetalleMedida.count') do
      post detalle_medidas_url, params: { detalle_medida: { Medida_id: @detalle_medida.Medida_id, Nombre: @detalle_medida.Nombre, Porcentaje_Ganancia: @detalle_medida.Porcentaje_Ganancia, Proporcion: @detalle_medida.Proporcion } }
    end

    assert_redirected_to detalle_medida_url(DetalleMedida.last)
  end

  test "should show detalle_medida" do
    get detalle_medida_url(@detalle_medida)
    assert_response :success
  end

  test "should get edit" do
    get edit_detalle_medida_url(@detalle_medida)
    assert_response :success
  end

  test "should update detalle_medida" do
    patch detalle_medida_url(@detalle_medida), params: { detalle_medida: { Medida_id: @detalle_medida.Medida_id, Nombre: @detalle_medida.Nombre, Porcentaje_Ganancia: @detalle_medida.Porcentaje_Ganancia, Proporcion: @detalle_medida.Proporcion } }
    assert_redirected_to detalle_medida_url(@detalle_medida)
  end

  test "should destroy detalle_medida" do
    assert_difference('DetalleMedida.count', -1) do
      delete detalle_medida_url(@detalle_medida)
    end

    assert_redirected_to detalle_medidas_url
  end
end
