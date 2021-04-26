class ChangeDomainName < ActiveRecord::Migration[6.1]
  def change
    remove_column :clients, :domain, :string if Client.new.respond_to?(:domain)
    add_column :clients, :domain_name, :string if !Client.new.respond_to?(:domain_name)
  end
end
