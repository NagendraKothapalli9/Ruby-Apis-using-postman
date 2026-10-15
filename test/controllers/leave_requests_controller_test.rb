require "test_helper"

class LeaveRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get leave_requests_create_url
    assert_response :success
  end
end
