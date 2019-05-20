class ExaBenefitsService
  require 'uri'
  require 'net/http'

  def initialize
    @data = JSON.parse(File.read("public/data.json"))
  end
  
  def perform
    @data["beneficiary_groups"].each do |bg|
      General::BenefitGroup.where(name: bg["name"], code: bg["code"]).first_or_create
      bg["benefits"].each do |benefit|
        bg_id = General::BenefitGroup.last.id
        General::Benefit.where(title: benefit["name"], url: benefit["url"], code: benefit["code"], benefit_group_id: bg_id, benefit_type_id: 1).first_or_create
        if benefit["variables"].present?
          benefit["variables"].each do |variable|  
            benefit_id =  General::Benefit.last.id
            General::Variable.where(amount: variable["amount"], currency: variable["currency"], general_benefit_id: benefit_id).first_or_create
          end
        end
      end
    end
  end
  
  def self.perform
    new.perform
  end

end