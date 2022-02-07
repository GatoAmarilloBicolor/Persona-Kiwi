# frozen_string_literal: true

class Api::V1::FollowsController < Api::BaseController
  before_action -> { doorkeeper_authorize! :follow, :'write:follows' }
  before_action :require_user!

  def create
    raise ActiveRecord::RecordNotFound if follow_params[:uri].blank?

    @account = FollowService.new.call(current_user.account, target_uri).try(:target_account)

    render json: @account, serializer: REST::AccountSerializer
  end

  private

  def target_uri
    follow_params[:uri].strip.gsub(/\A@/, '')
  end

  def follow_params
    params.permit(:uri)
  end
end
