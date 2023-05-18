namespace :expense_report do
    desc "Send emails to supervisors"
    task send_pending_emails: :environment do
        envoy_id = ExpenseReport::RequestState.where(name: 'envoy').last.id
        requests = ExpenseReport::Request.where("created_at < ? AND request_state_id = ?", 24.hours.ago, envoy_id)

        requests.each do |request|
          puts 'Enviando...'
          UserNotifierMailer.reminder_supervisors_requests(request).deliver_now
        end
      end
  end
  