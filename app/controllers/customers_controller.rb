class CustomersController < ApplicationController
  include ApplicationHelper

  def for_client
    client = Client.find(params[:client_id]) if params[:client_id].present?

    render partial: 'list', locals:{models: customer_select_for_client(client)}
  end
end