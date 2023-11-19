class PdfGenerator
  def self.generate(request)
    require 'tempfile'
    pdf = Prawn::Document.new

    user = General::User.with_deleted.find(request.user_id)
    supervisor = user.get_supervisor_full_name

    pdf.text "Rendición de gastos ##{request.id}", size: 18, style: :bold, align: :center
    pdf.move_down 20 
    column1_y = pdf.cursor
    column2_y = pdf.cursor
    column_width = pdf.bounds.width / 2 - 10

    # Columna 1
    pdf.bounding_box([0, column1_y], width: column_width) do
      campos = [
        ["Usuario: ", request.user&.full_name],
        ["Código: ", request.user&.legal_number],
        ["Correo: ", request.user&.email],
        ["Estado Rendición: ", request.request_state&.code.to_s],
        ["Asistente: ", request.assistant&.full_name.to_s],
        ["Supervisor: ", supervisor.to_s],
        ["Subtotal: ", "#{request.divisa_id} #{ActiveSupport::NumberHelper.number_to_currency(request.total, precision: 2)}"],
        ["Sociedad: ", request.society&.name.to_s],
        ["Rendición Local: ", request.is_local ? 'Sí' : 'No'],
        ["País destino del reembolso: ", request.destination_country_id.to_s],
        ["Método de pago: ", request.payment_method_id.to_s],
        ["Fecha de pago: ", request.payment_date&.strftime("%d/%m/%Y")]
      ]

      campos.each do |etiqueta, valor|
        pdf.formatted_text([{ text: etiqueta, styles: [:bold] }, { text: valor.to_s }])
        pdf.move_down 5
      end
    end

    pdf.move_down 20
    pdf.text "Titulo de la rendición"
    pdf.text request.description
    pdf.move_down 30

    pdf.text "Documentación de respaldo"
    data = [["#", "Categoría", "Descripción", "Total"]]
    request.invoices.each_with_index do |invoice, index|
      data << [index + 1, invoice.category&.name, invoice.description, ActiveSupport::NumberHelper.number_to_currency(invoice.total, precision: 2)]
    end

    table_width = pdf.bounds.width
     pdf.table(data, header: true, column_widths: [table_width * 0.15, table_width * 0.35, table_width * 0.35, table_width * 0.15], cell_style: { inline_format: true })

    # Columna 2
    pdf.bounding_box([column_width + 20, column2_y], width: column_width) do
      if request.payment_method_id != 'Transferencia bancaria moneda local'
        pdf.text "Datos cuenta bancaria: #{request.bank_account_details}"
      else
        if user.accounts.present?
          account = user.accounts.last
          campos_cuenta = [
            ["Usuario: ", account.name.to_s],
            ["Nro de cuenta: ", account.account_number.to_s],
            ["Documento de Identidad: ", account.legal_number.to_s],
            ["Banco: ", account.bank_name.to_s],
            ["Tipo de cuenta: ", account.account_type.to_s],
            ["Oficina: ", account.country.to_s]
          ]

          campos_cuenta.each do |etiqueta, valor|
            pdf.formatted_text([{ text: etiqueta, styles: [:bold] }, { text: valor }])
            pdf.move_down 5
          end
        else
          pdf.text "Sin datos bancarios"
        end 
      end
      cost_centers = user.cost_center_users
      pdf.move_down 10
      pdf.text "Centro de costo"
      if cost_centers.present?
        data = [["Nombre", "Porcentaje", "Oficina"]]
        cost_centers.each do |cc|
          data << [cc.cost_center.name, "#{cc.percentage}%", cc.cost_center&.dependence&.capitalize]
        end
        pdf.table(data, header: true, column_widths: [120, 70, 70], cell_style: { inline_format: true })

      else
        pdf.text "Sin Centro de Costo"
      end

    end
    combined_pdf = CombinePDF.new
    combined_pdf << CombinePDF.parse(pdf.render)

    request.invoices.each do |invoice|
      invoice.files.each do |file|
        if is_image?(file)
          open_image(file) do |path|
            image_pdf = Prawn::Document.new(:skip_page_creation => true)
            image_pdf.start_new_page
            image_pdf.text "Anexo: #{invoice.id}", style: :bold
            image_pdf.move_down 10
            image_pdf.image path, width: image_pdf.bounds.width
            combined_pdf << CombinePDF.parse(image_pdf.render) 
          end
        elsif is_pdf?(file)
          combined_pdf << download_pdf(file)
        else
          pdf.start_new_page
          pdf.text "Archivo no compatible"
          combined_pdf << CombinePDF.parse(pdf.render)
          combined_pdf << download_pdf(file)
        end
      end
    end
    combined_pdf.to_pdf
  end

  def self.is_image?(file)
    filename = file.filename.to_s
    %w[jpg jpeg png gif].include?(File.extname(filename).downcase.delete('.'))
  end


  def self.open_image(file)
    Tempfile.create([file.filename.to_s, File.extname(file.filename.to_s)]) do |temp_file|
      temp_file.binmode
      temp_file.write(file.blob.download)
      temp_file.flush
  
      yield temp_file.path
    end
  end

  def self.is_pdf?(file)
    %w[.pdf].include?(File.extname(file.filename.to_s).downcase)
  end

  def self.download_pdf(file)
    Tempfile.create([file.filename.to_s, '.pdf']) do |temp_file|
      temp_file.binmode
      temp_file.write(file.blob.download)
      temp_file.flush
      temp_file.rewind
      pdf = CombinePDF.load(temp_file.path)
      pdf
    end 
  end

end
