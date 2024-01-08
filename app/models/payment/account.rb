class Payment::Account < ApplicationRecord
  belongs_to :user, class_name: 'General::User'
  has_many :expense_report_requests, class_name: 'ExpenseReport::Request'

  def filtered_account
    if self.account_number.present? 
      self.account_number = "X" * (self.account_number.length - 4) + self.account_number.last(4)
      self
    else
      self.account_number = nil
    end
  end

    # Define una constante para mapear los países a sus métodos de pago
    PAYMENT_METHODS_BY_COUNTRY = {
      'ARGENTINA'  => [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'],
      'BRASIL'     => [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'],
      'CHILE'      => [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Abono tarjeta de crédito'],
      'MEXICO'     => [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'],
      'PERU'       => [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera'],
      'URUGUAY'    => [:'Transferencia bancaria moneda local', :'Transferencia bancaria moneda extranjera', :'Pago tarjeta corporativa'],
      'NUEVA YORK' => [:'Transferencia bancaria moneda local'],
      'MIAMI'      => [:'Transferencia bancaria moneda local']
    }.freeze
  
    # Método para obtener los métodos de pago basados en el país
    def self.payment_methods_for_country(country)
      methods = PAYMENT_METHODS_BY_COUNTRY[country] || ExpenseReport::Request::PAYMENT_METHOD
      ExpenseReport::Request::PAYMENT_METHOD.select { |method| methods.include?(method.keys.first.to_sym) }
    end
end
