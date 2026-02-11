require 'test_helper'

class MovimientoProductosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movimiento_producto = movimiento_productos(:one)
  end

  test "should get index" do
    get movimiento_productos_url
    assert_response :success
  end

  test "should get new" do
    get new_movimiento_producto_url
    assert_response :success
  end

  test "should create movimiento_producto" do
    assert_difference('MovimientoProducto.count') do
      post movimiento_productos_url, params: { movimiento_producto: { Documento_id: @movimiento_producto.Documento_id, Entrante_Bodega_id: @movimiento_producto.Entrante_Bodega_id, Producto_id: @movimiento_producto.Producto_id, Saliente_Bodega_id: @movimiento_producto.Saliente_Bodega_id, actualizado: @movimiento_producto.actualizado, actualizado_por: @movimiento_producto.actualizado_por, cantidad: @movimiento_producto.cantidad, creado: @movimiento_producto.creado, creado_por: @movimiento_producto.creado_por, movimiento_tipo: @movimiento_producto.movimiento_tipo, porcentaje_proporcion: @movimiento_producto.porcentaje_proporcion, signo: @movimiento_producto.signo } }
    end

    assert_redirected_to movimiento_producto_url(MovimientoProducto.last)
  end

  test "should show movimiento_producto" do
    get movimiento_producto_url(@movimiento_producto)
    assert_response :success
  end

  test "should get edit" do
    get edit_movimiento_producto_url(@movimiento_producto)
    assert_response :success
  end

  test "should update movimiento_producto" do
    patch movimiento_producto_url(@movimiento_producto), params: { movimiento_producto: { Documento_id: @movimiento_producto.Documento_id, Entrante_Bodega_id: @movimiento_producto.Entrante_Bodega_id, Producto_id: @movimiento_producto.Producto_id, Saliente_Bodega_id: @movimiento_producto.Saliente_Bodega_id, actualizado: @movimiento_producto.actualizado, actualizado_por: @movimiento_producto.actualizado_por, cantidad: @movimiento_producto.cantidad, creado: @movimiento_producto.creado, creado_por: @movimiento_producto.creado_por, movimiento_tipo: @movimiento_producto.movimiento_tipo, porcentaje_proporcion: @movimiento_producto.porcentaje_proporcion, signo: @movimiento_producto.signo } }
    assert_redirected_to movimiento_producto_url(@movimiento_producto)
  end

  test "should destroy movimiento_producto" do
    assert_difference('MovimientoProducto.count', -1) do
      delete movimiento_producto_url(@movimiento_producto)
    end

    assert_redirected_to movimiento_productos_url
  end
end
