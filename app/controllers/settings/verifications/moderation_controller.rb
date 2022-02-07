class Settings::Verifications::ModerationController < Admin::BaseController

	def index
		@verification_requests = AccountVerificationRequest.order('created_at DESC').all
	end

	def approve

		ActiveRecord::Base.connected_to(role: :writing) do
			verification_request = AccountVerificationRequest.find(params[:id])

			# Mark user as verified
			account = verification_request.account
			ApplicationRecord.transaction do
				account.update!(is_verified: true)

				# Remove all traces
				verification_request.destroy
			end
		end

		# Notify user
		UserMailer.verification_approved(account.user).deliver_later!

		# Redirect back to the form with a proper message
		redirect_to settings_verifications_moderation_url, notice: I18n.t('verifications.moderation.approved_msg')
	end

	def reject
		ActiveRecord::Base.connected_to(role: :writing) do
			verification_request = AccountVerificationRequest.find(params[:id])
			verification_request.destroy()
		end
		redirect_to settings_verifications_moderation_url, notice: I18n.t('verifications.moderation.rejected_msg')
	end
end
