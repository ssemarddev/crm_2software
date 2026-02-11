require 'test_helper'

class AparatosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aparato = aparatos(:one)
  end

  test "should get index" do
    get aparatos_url
    assert_response :success
  end

  test "should get new" do
    get new_aparato_url
    assert_response :success
  end

  test "should create aparato" do
    assert_difference('Aparato.count') do
      post aparatos_url, params: { aparato: { actualizado: @aparato.actualizado, actualizado_por: @aparato.actualizado_por, bodega_id: @aparato.bodega_id, cliente: @aparato.cliente, comentario: @aparato.comentario, cov: @aparato.cov, cov_remplazo: @aparato.cov_remplazo, creado: @aparato.creado, creado_por: @aparato.creado_por, estado_id: @aparato.estado_id, proveedor: @aparato.proveedor, serie: @aparato.serie, serie_remplazo: @aparato.serie_remplazo, status: @aparato.status } }
    end

    assert_redirected_to aparato_url(Aparato.last)
  end

  test "should show aparato" do
    get aparato_url(@aparato)
    assert_response :success
  end

  test "should get edit" do
    get edit_aparato_url(@aparato)
    assert_response :success
  end

  test "should update aparato" do
    patch aparato_url(@aparato), params: { aparato: { actualizado: @aparato.actualizado, actualizado_por: @aparato.actualizado_por, bodega_id: @aparato.bodega_id, cliente: @aparato.cliente, comentario: @aparato.comentario, cov: @aparato.cov, cov_remplazo: @aparato.cov_remplazo, creado: @aparato.creado, creado_por: @aparato.creado_por, estado_id: @aparato.estado_id, proveedor: @aparato.proveedor, serie: @aparato.serie, serie_remplazo: @aparato.serie_remplazo, status: @aparato.status } }
    assert_redirected_to aparato_url(@aparato)
  end

  test "should destroy aparato" do
    assert_difference('Aparato.count', -1) do
      delete aparato_url(@aparato)
    end

    assert_redirected_to aparatos_url
  end
end
