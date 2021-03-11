class CustomersController < ApplicationController
  include ApplicationHelper

  def for_client
    client = Client.find(params[:client_id]) if params[:client_id].present?

    render partial: 'list', locals:{models: customer_select_for_client(client)}
  end
end

# room stuff on right side of form
# dropdown list with number of rooms that then dynamically pushes the button
