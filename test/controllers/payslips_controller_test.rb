require "test_helper"

class PayslipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payslip = payslips(:one)
  end

  test "should get index" do
    get payslips_url, as: :json
    assert_response :success
  end

  test "should create payslip" do
    assert_difference("Payslip.count") do
      post payslips_url, params: { payslip: { gross: @payslip.gross, hours: @payslip.hours, month: @payslip.month, name: @payslip.name, net: @payslip.net, rate: @payslip.rate, shifts: @payslip.shifts, status: @payslip.status, tax: @payslip.tax, year: @payslip.year } }, as: :json
    end

    assert_response :created
  end

  test "should show payslip" do
    get payslip_url(@payslip), as: :json
    assert_response :success
  end

  test "should update payslip" do
    patch payslip_url(@payslip), params: { payslip: { gross: @payslip.gross, hours: @payslip.hours, month: @payslip.month, name: @payslip.name, net: @payslip.net, rate: @payslip.rate, shifts: @payslip.shifts, status: @payslip.status, tax: @payslip.tax, year: @payslip.year } }, as: :json
    assert_response :success
  end

  test "should destroy payslip" do
    assert_difference("Payslip.count", -1) do
      delete payslip_url(@payslip), as: :json
    end

    assert_response :no_content
  end
end
