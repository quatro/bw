class EnableFuzzyMatch < ActiveRecord::Migration[6.1]
  def change
    enable_extension "fuzzystrmatch"
  end
end
