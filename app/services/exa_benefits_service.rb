class ExaBenefitsService
  require 'uri'
  require 'net/http'

  def initialize
    @data = JSON.parse(File.read('public/benefits_data.json'))
  end

  def perform
    record_all = General::Benefit.pluck(:id)
    bgr_all = General::BenefitGroupRelationship.pluck(:id)
    record_ids = []
    new_records_bgr = []
    beneficiary_groups_used = []
    @data['beneficiary_groups'].each do |bg|
      puts "========= Creando o actualizando benefit group: #{bg['name']} ========="
      benefit_group = General::BenefitGroup.find_by(code: bg['code']) || General::BenefitGroup.only_deleted.find_by(code: bg['code'])
      benefit_group = General::BenefitGroup.create(code: bg['code'], name: bg['name']) if benefit_group.nil?
      
      
      
      benefit_group.restore if benefit_group.deleted_at.present?
      benefit_group.update(name: bg['name'])

      beneficiary_groups_used << benefit_group.id
      bg['benefits'].each do |benefit|
        if benefit['name'].present?
          puts "Beneficio: #{benefit['name']}"
        end
        
        next unless benefit.present?

        if benefit["name"].downcase.include?("bono")
          benefit_type = General::BenefitType.find_by(name: "Bonos")
        elsif benefit["name"].downcase.include?("crédito")
          benefit_type = General::BenefitType.find_by(name: "Créditos")
        elsif benefit["name"].downcase.include?("permiso")
          benefit_type = General::BenefitType.find_by(name: "Permisos")
        elsif benefit["name"].downcase.include?("convenio")
          benefit_type = General::BenefitType.find_by(name: "Convenios")
        else
          benefit_type = General::BenefitType.find_by(name: "Otros")
        end


        is_transactional = benefit['es_transaccional'] == 'si'
        
        record = General::Benefit.find_by(code: benefit['name']) || General::Benefit.only_deleted.find_by(code: benefit['name'])
        record = General::Benefit.create(title: benefit['pretty_name'], code: benefit['name'], benefit_type: benefit_type ) if record.nil?

        record.restore if record.deleted_at.present?
        record.update(benefit_type_id: benefit_type) if !record.benefit_type_id.present?
        record.update(is_transactional: is_transactional)

        record_ids << record.id
        if benefit['variables'].present?
          benefit['variables'].each do |variable|
            var = General::BenefitGroupRelationship.with_deleted.where(amount: variable['amount'].to_i, currency: variable['currency'], url: benefit['url'], benefit_group: benefit_group).first_or_create
            var.restore if var.deleted_at.present?
            new_records_bgr << var.id
            record.benefit_group_relationships << var unless record.benefit_group_relationships.include?(var)
          end
        else
          var = General::BenefitGroupRelationship.with_deleted.where(url: benefit['url'], benefit_group: benefit_group).first_or_create
          var.restore if var.deleted_at.present?
          new_records_bgr << var.id
          record.benefit_group_relationships << var unless record.benefit_group_relationships.include?(var)
        end
      end
    end

    delete_bgr_ids = bgr_all - new_records_bgr
    if delete_bgr_ids.present?
      puts "BGR a eliminar: #{delete_bgr_ids.count}"
      General::BenefitGroupRelationship.where(id: delete_bgr_ids).destroy_all
    end
    delete_benefit_ids = record_all - record_ids.uniq
    puts "Beneficios a eliminar: #{delete_benefit_ids.count}"
    puts "Grupos beneficiarios a eliminar: #{General::BenefitGroup.count - beneficiary_groups_used.count}"
    if delete_benefit_ids.present?
      General::Benefit.where(id: delete_benefit_ids).destroy_all
    end
    General::BenefitGroup.where.not(id: beneficiary_groups_used).destroy_all
    puts "Fin de la carga de beneficios"
  end

  def self.perform
    new.perform
  end
end
