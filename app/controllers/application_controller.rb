class ApplicationController < ActionController::Base
    # CSRF保護をオンにする
    protect_from_forgery with: :exception
    
    include SessionsHelper
end
  