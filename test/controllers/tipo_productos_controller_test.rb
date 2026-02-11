require 'test_helper'

class TipoProductosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_producto = tipo_productos(:one)
  end

  test "should get index" do
    get tipo_productos_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_producto_url
    assert_response :success
  end

  test "should create tipo_producto" do
    assert_difference('TipoProducto.count') do
      post tipo_productos_url, params: { tipo_producto: { Es_Servicio: @tipo_producto.Es_Servicio, Estado: @tipo_producto.Estado, Nombre: @tipo_producto.Nombre, actualizado: @tipo_producto.actualizado, actualizado_por: @tipo_producto.actualizado_por, creado: @tipo_producto.creado, creado_por: @tipo_producto.creado_por } }
    end

    assert_redirected_to tipo_producto_url(TipoProducto.last)
  end

  test "should show tipo_producto" do
    get tipo_producto_url(@tipo_producto)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_producto_url(@tipo_producto)
    assert_response :success
  end

  test "should update tipo_producto" do
    patch tipo_producto_url(@tipo_producto), params: { tipo_producto: { Es_Servicio: @tipo_producto.Es_Servicio, Estado: @tipo_producto.Estado, Nombre: @tipo_producto.Nombre, actualizado: @tipo_producto.actualizado, actualizado_por: @tipo_producto.actualizado_por, creado: @tipo_producto.creado, creado_por: @tipo_producto.creado_por } }
    assert_redirected_to tipo_producto_url(@tipo_producto)
  end

  test "should destroy tipo_producto" do
    assert_difference('TipoProducto.count', -1) do
      delete tipo_producto_url(@tipo_producto)
    end

    assert_redirected_to tipo_productos_url
  end
end
