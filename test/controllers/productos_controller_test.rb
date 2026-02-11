require 'test_helper'

class ProductosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @producto = productos(:one)
  end

  test "should get index" do
    get productos_url
    assert_response :success
  end

  test "should get new" do
    get new_producto_url
    assert_response :success
  end

  test "should create producto" do
    assert_difference('Producto.count') do
      post productos_url, params: { producto: { ClienteProveedor_id: @producto.ClienteProveedor_id, Codigo: @producto.Codigo, Columna: @producto.Columna, Fila: @producto.Fila, Marca_id: @producto.Marca_id, Medida_id: @producto.Medida_id, Minimos: @producto.Minimos, Nombre: @producto.Nombre, TipoProducto_id: @producto.TipoProducto_id, Valor_Compra: @producto.Valor_Compra, Valor_Venta: @producto.Valor_Venta } }
    end

    assert_redirected_to producto_url(Producto.last)
  end

  test "should show producto" do
    get producto_url(@producto)
    assert_response :success
  end

  test "should get edit" do
    get edit_producto_url(@producto)
    assert_response :success
  end

  test "should update producto" do
    patch producto_url(@producto), params: { producto: { ClienteProveedor_id: @producto.ClienteProveedor_id, Codigo: @producto.Codigo, Columna: @producto.Columna, Fila: @producto.Fila, Marca_id: @producto.Marca_id, Medida_id: @producto.Medida_id, Minimos: @producto.Minimos, Nombre: @producto.Nombre, TipoProducto_id: @producto.TipoProducto_id, Valor_Compra: @producto.Valor_Compra, Valor_Venta: @producto.Valor_Venta } }
    assert_redirected_to producto_url(@producto)
  end

  test "should destroy producto" do
    assert_difference('Producto.count', -1) do
      delete producto_url(@producto)
    end

    assert_redirected_to productos_url
  end
end
