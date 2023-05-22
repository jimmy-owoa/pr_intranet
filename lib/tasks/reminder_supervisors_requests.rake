namespace :expense_report do
    desc "Send emails to supervisors"
    task send_pending_emails: :environment do
        envoy_id = ExpenseReport::RequestState.where(name: 'envoy').last.id
        requests = ExpenseReport::Request.where("created_at < ? AND request_state_id = ?", 24.hours.ago, envoy_id)
        puts "Reporte recordatorio supervisores - #{Time.now}"
        requests.each do |request|
          puts "Enviando request n° #{request.id}"
          UserNotifierMailer.reminder_supervisors_requests(request).deliver_now
        end
      end
  end
