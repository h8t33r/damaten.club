class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "damaten", password: "7213@damaten"
end
