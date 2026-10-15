require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get employees_create_url
    assert_response :success
  end
end
