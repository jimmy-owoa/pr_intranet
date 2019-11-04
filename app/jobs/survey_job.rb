class SurveyJob < ApplicationJob
  queue_as :publish_survey

  def perform(*args)
    surveys = publish_surveys
    publish_surveys.each do |survey|
      survey.update_attributes(status: "Publicado")
    end
    puts "did job publish programed surveys"
  end

  def publish_surveys
    Survey::Survey.where(
      "DATE_FORMAT(published_at, '%d/%m/%Y %H:%M') = ? AND status = ?", Time.now.strftime("%d/%m/%Y %H:%M"), "Programado"
    )
  end
end
