require 'test_helper'

class PuntoventaControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get puntoventa_new_url
    assert_response :success
  end

  test "should get create" do
    get puntoventa_create_url
    assert_response :success
  end

end
