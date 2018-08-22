class Game < ApplicationRecord

  before_save :convert_to_json

  private
  def convert_to_json
    self.score.to_json
  end
end
