class Rule < ApplicationRecord
  before_save :convert_to_json

  private
  def convert_to_json
    self.data.to_json
  end
end
