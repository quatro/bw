class CustomersController < ApplicationController
  include ApplicationHelper

  def for_client
    customer_id = params[:customer_id]
    client = Client.find(params[:client_id]) if params[:client_id].present?

    render partial: 'list', locals:{models: customer_select_for_client(client), selected_customer_id: customer_id}
  end
end

# room stuff on right side of form
# dropdown list with number of rooms that then dynamically pushes the button
