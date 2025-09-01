class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show update destroy ]
  before_action :set_current_user

  # GET /contacts
  def index
    @contacts = @current_user.contacts

    render json: @contacts
  end

  # GET /contacts/1
  def show
    render json: @contact
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)
    @contact.user = @current_user

    if @contact.save
      render json: @contact, status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy!
  end



  def download_contact
    contact = Contact.find(params[:id])
  
    vcard = <<~VCARD
      BEGIN:VCARD
      VERSION:3.0
      FN:#{contact.first_name} #{contact.last_name}
      ORG:PayPulse
      TITLE:#{contact.role}
      EMAIL:#{contact.email}
      TEL:#{contact.phone}
      END:VCARD
    VCARD
  
    send_data vcard,
              filename: "#{contact.first_name.parameterize}.vcf",
              type: "text/vcard",
              disposition: "attachment"
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def contact_params
      params.expect(contact: [ :first_name, :last_name, :role, :company, :location, :email, :phone ])
    end
end
