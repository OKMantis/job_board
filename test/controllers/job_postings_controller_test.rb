require "test_helper"

class JobPostingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get job_postings_index_url
    assert_response :success
  end

  test "should get show" do
    get job_postings_show_url
    assert_response :success
  end
end
