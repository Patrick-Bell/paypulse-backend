class PaymentController < ApplicationController

    before_action :set_current_user
    before_action :set_stripe_key




    def create_checkout_session
        
        paypulse_pro =
        [
          {
            price_data: {
              currency: 'gbp',
              product_data: {
                name: 'PayPulse Pro',
                images: ['http://localhost:5173/src/components/assets/logo.png'],
              },
              unit_amount: 499,
            },
            quantity: 1
          }
        ]
    
        session_params = {
          payment_method_types: ['card'],
          line_items: paypulse_pro,
          client_reference_id: @current_user&.id,
          mode: 'payment',
          shipping_address_collection: {
            allowed_countries: ['GB']
          },
          metadata: {
          user_id: @current_user&.id
          },
          success_url: ENV['CHECKOUT_SUCCESS_URL'],
          cancel_url: ENV['CHECKOUT_CANCEL_URL']
        }
    
        session = Stripe::Checkout::Session.create(session_params)
    
        render json: { url: session.url }
      end


      def set_stripe_key
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      end


end
