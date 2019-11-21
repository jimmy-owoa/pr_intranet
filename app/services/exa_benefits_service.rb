class ExaBenefitsService
  require "uri"
  require "net/http"

  def initialize
    @data = JSON.parse(File.read("public/data.json"))
  end

  def perform
    @data["beneficiary_groups"].each do |bg|
      benefit_group = General::BenefitGroup.where(name: bg["name"], code: bg["code"]).first_or_create
      bg["benefits"].each do |benefit|
        if benefit["name"].present?
          if /^(\s)*bono/.match(benefit["name"].downcase)
            benefit_type = 1
          elsif /^(\s)*crédito/.match(benefit["name"].downcase)
            benefit_type = 2
          elsif /^(\s)*seguro/.match(benefit["name"].downcase)
            benefit_type = 3
          elsif /^(\s)*permiso/.match(benefit["name"].downcase)
            benefit_type = 4
          end
        end
        record = General::Benefit.where(title: benefit["name"], code: benefit["code"], benefit_type_id: benefit_type).first_or_create
        if benefit["variables"].present?
          benefit["variables"].each do |variable|
            var = General::BenefitGroupRelationship.where(amount: variable["amount"].to_i, currency: variable["currency"], url: benefit["url"], benefit_group: benefit_group).first_or_create
            record.benefit_group_relationships << var unless record.benefit_group_relationships.include?(var)
          end
        end
      end
    end
  end

  def self.perform
    new.perform
  end
end
