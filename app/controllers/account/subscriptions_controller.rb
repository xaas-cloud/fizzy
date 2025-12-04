class Account::SubscriptionsController < ApplicationController
  before_action :ensure_admin
  before_action :set_account
  before_action :set_stripe_session, only: :show

  def show
  end

  def create
    session = Stripe::Checkout::Session.create \
      customer: find_or_create_stripe_customer,
      mode: "subscription",
      line_items: [ { price: Plan.paid.stripe_price_id, quantity: 1 } ],
      success_url: account_subscription_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: account_subscription_url,
      metadata: { account_id: @account.id, plan_key: Plan.paid.key }

    redirect_to session.url, allow_other_host: true
  end

  def destroy
    if @account.subscription&.stripe_subscription_id
      Stripe::Subscription.cancel(@account.subscription.stripe_subscription_id)
    end

    redirect_to account_subscription_path, notice: "Subscription canceled"
  end

  private
    def set_account
      @account = Current.account
    end

    def set_stripe_session
      @session = Stripe::Checkout::Session.retrieve(params[:session_id]) if params[:session_id]
    end

    def find_or_create_stripe_customer
      find_stripe_customer || create_stripe_customer
    end

    def find_stripe_customer
      Stripe::Customer.retrieve(@account.subscription.stripe_customer_id) if @account.subscription&.stripe_customer_id
    end

    def create_stripe_customer
      Stripe::Customer.create(email: Current.user.identity.email_address, name: @account.name, metadata: { account_id: @account.id }).tap do |customer|
        @account.create_subscription!(stripe_customer_id: customer.id, plan_key: Plan.paid.key, status: "incomplete")
      end
    end
end
