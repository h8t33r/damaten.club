class WelcomeController < ApplicationController
  def index
    render "index"#, :layout => false
  end

  def yaku
    render html: "yaku"
  end

  def rulebook
    render html: "rulebook"
  end

  def events
    render html: "events"
  end
end
