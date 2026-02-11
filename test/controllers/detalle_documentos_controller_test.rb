require 'test_helper'

class DetalleDocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detalle_documento = detalle_documentos(:one)
  end

  test "should get index" do
    get detalle_documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_detalle_documento_url
    assert_response :success
  end

  test "should create detalle_documento" do
    assert_difference('DetalleDocumento.count') do
      post detalle_documentos_url, params: { detalle_documento: { DetalleMedida_id: @detalle_documento.DetalleMedida_id, Documento_id: @detalle_documento.Documento_id, Medida_id: @detalle_documento.Medida_id, Producto_id: @detalle_documento.Producto_id, actualizado: @detalle_documento.actualizado, actualizado_por: @detalle_documento.actualizado_por, cantidad: @detalle_documento.cantidad, creado: @detalle_documento.creado, creado_por: @detalle_documento.creado_por, descripcion: @detalle_documento.descripcion, descuento: @detalle_documento.descuento, descuento_porcentaje: @detalle_documento.descuento_porcentaje, estado: @detalle_documento.estado, total: @detalle_documento.total, valor_compra: @detalle_documento.valor_compra, valor_venta: @detalle_documento.valor_venta } }
    end

    assert_redirected_to detalle_documento_url(DetalleDocumento.last)
  end

  test "should show detalle_documento" do
    get detalle_documento_url(@detalle_documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_detalle_documento_url(@detalle_documento)
    assert_response :success
  end

  test "should update detalle_documento" do
    patch detalle_documento_url(@detalle_documento), params: { detalle_documento: { DetalleMedida_id: @detalle_documento.DetalleMedida_id, Documento_id: @detalle_documento.Documento_id, Medida_id: @detalle_documento.Medida_id, Producto_id: @detalle_documento.Producto_id, actualizado: @detalle_documento.actualizado, actualizado_por: @detalle_documento.actualizado_por, cantidad: @detalle_documento.cantidad, creado: @detalle_documento.creado, creado_por: @detalle_documento.creado_por, descripcion: @detalle_documento.descripcion, descuento: @detalle_documento.descuento, descuento_porcentaje: @detalle_documento.descuento_porcentaje, estado: @detalle_documento.estado, total: @detalle_documento.total, valor_compra: @detalle_documento.valor_compra, valor_venta: @detalle_documento.valor_venta } }
    assert_redirected_to detalle_documento_url(@detalle_documento)
  end

  test "should destroy detalle_documento" do
    assert_difference('DetalleDocumento.count', -1) do
      delete detalle_documento_url(@detalle_documento)
    end

    assert_redirected_to detalle_documentos_url
  end
end
