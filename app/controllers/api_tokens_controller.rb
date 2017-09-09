# frozen_string_literal: true

require 'securerandom'

# API tokens controller.
#
# Generates API tokens.
class ApiTokensController < ApplicationController
  def create
    head(:forbidden) && return if not_logged_in

    respond_to do |format|
      format.json do
        new_api_token = SecureRandom.hex
        current_user.update!(api_token: new_api_token)
        render(json: { token: new_api_token })
      end
    end
  end
end
