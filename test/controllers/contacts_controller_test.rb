require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)
  end

  test "should get index" do
    get contacts_url, as: :json
    assert_response :success
  end

  test "should create contact" do
    assert_difference("Contact.count") do
      post contacts_url, params: { contact: { company: @contact.company, email: @contact.email, first_name: @contact.first_name, last_name: @contact.last_name, location: @contact.location, phone: @contact.phone, role: @contact.role } }, as: :json
    end

    assert_response :created
  end

  test "should show contact" do
    get contact_url(@contact), as: :json
    assert_response :success
  end

  test "should update contact" do
    patch contact_url(@contact), params: { contact: { company: @contact.company, email: @contact.email, first_name: @contact.first_name, last_name: @contact.last_name, location: @contact.location, phone: @contact.phone, role: @contact.role } }, as: :json
    assert_response :success
  end

  test "should destroy contact" do
    assert_difference("Contact.count", -1) do
      delete contact_url(@contact), as: :json
    end

    assert_response :no_content
  end
end
