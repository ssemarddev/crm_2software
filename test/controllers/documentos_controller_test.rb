require 'test_helper'

class DocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @documento = documentos(:one)
  end

  test "should get index" do
    get documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_documento_url
    assert_response :success
  end

  test "should create documento" do
    assert_difference('Documento.count') do
      post documentos_url, params: { documento: { ClienteProveedor_id: @documento.ClienteProveedor_id, Documento: @documento.Documento, Factura: @documento.Factura, Fecha_Entrega: @documento.Fecha_Entrega, Fecha_Recibido: @documento.Fecha_Recibido, Serie: @documento.Serie, TipoDocumento_id: @documento.TipoDocumento_id, TipoPago_id: @documento.TipoPago_id, Usuario_enviado_id: @documento.Usuario_enviado_id, Usuario_recibido_id: @documento.Usuario_recibido_id, actualizado_por: @documento.actualizado_por, creado_por: @documento.creado_por } }
    end

    assert_redirected_to documento_url(Documento.last)
  end

  test "should show documento" do
    get documento_url(@documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_documento_url(@documento)
    assert_response :success
  end

  test "should update documento" do
    patch documento_url(@documento), params: { documento: { ClienteProveedor_id: @documento.ClienteProveedor_id, Documento: @documento.Documento, Factura: @documento.Factura, Fecha_Entrega: @documento.Fecha_Entrega, Fecha_Recibido: @documento.Fecha_Recibido, Serie: @documento.Serie, TipoDocumento_id: @documento.TipoDocumento_id, TipoPago_id: @documento.TipoPago_id, Usuario_enviado_id: @documento.Usuario_enviado_id, Usuario_recibido_id: @documento.Usuario_recibido_id, actualizado_por: @documento.actualizado_por, creado_por: @documento.creado_por } }
    assert_redirected_to documento_url(@documento)
  end

  test "should destroy documento" do
    assert_difference('Documento.count', -1) do
      delete documento_url(@documento)
    end

    assert_redirected_to documentos_url
  end
end
