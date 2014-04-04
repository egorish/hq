prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               filename: "Акт проверки №#{@report.id}.pdf",
               page_size: 'A4', page_layout: :portrait do |pdf|
 render 'pdf/font', pdf: pdf
   pdf.font_size = 10
   pdf.text "от «___» ________________ #{Study::Discipline::CURRENT_STUDY_TERM == 1 ? Study::Discipline::CURRENT_STUDY_YEAR : Study::Discipline::CURRENT_STUDY_YEAR+1} г."
   pdf.move_down 5
   pdf.text 'Место составления: г. Москва, ул. ________________________________________________________________________________'
   pdf.move_down 5
   pdf.text 'Время составления: ________________'

  pdf.move_down 25
  pdf.text 'АКТ ПРОВЕРКИ', align: :center, style: :bold
  pdf.text 'состояния квартиры в общежитии МГУП имени Ивана Федорова', align: :center, style: :bold
  pdf.text '(СПРАВКА О РЕЗУЛЬТАТАХ ПРОВЕРКИ)', align: :center, style: :bold
  pdf.move_down 25

  pdf.text "<strong>Дата проверки:</strong> «<u>#{l @report.date, format: '%d'}</u>» <u>#{l @report.date, format: '%B'}</u> #{l @report.date, format: '%Y'} г.", inline_format: true
  pdf.move_down 5
  pdf.text "<strong>Время проверки:</strong> «<u>#{l @report.time, format: '%H:%M'}</u>».", inline_format: true

  pdf.move_down 20
  pdf.text "Настоящий акт (справка) составлен(а) по результатам проверки квартиры (блока) № <u>#{@report.flat.number}</u> общежития МГУП имени Ивана Федорова, расположенного по адресу: ", inline_format: true
  pdf.move_down 5
  pdf.text "г. Москва, #{@report.flat.hostel.address}"
  pdf.move_down 10
  pdf.text "<strong>Проверка проведена</strong> в соответствии с Уставом федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (п. 6.7, п.6.12), Положением о студенческом общежитии федерального государственного бюджетного образовательного учреждения высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова» (п. 12, п. 16) и Правилами внутреннего распорядка в студенческом общежитии Московского государственного университета печати имени Ивана Федорова (п. 4.3).", inline_format: true
  pdf.move_down 20
  if @report.offenses.empty?
     pdf.text "<strong><u>В ходе проверки нарушений не обнаружено.</u></strong>", inline_format: true
  else
    pdf.text "<strong><u>В ходе проверки выявлены нарушения</u></strong>", inline_format: true
    pdf.move_down 5
    @report.report_offenses.each_with_index do |ro, index|
     if ro.persons.empty?
      pdf.text "#{index + 1}. #{ro.offense.description} #{(ro.rooms.empty? ? 'в местах общего пользования' : 'в жилом помещении')}."
      unless ro.rooms.empty?
        pdf.text 'Комнаты, в которых зафиксирован факт нарушения:'
      end
     else
     pdf.text "#{index + 1}. #{ro.offense.description}, а именно:"
     pdf.line_width = 0.7
     pdf.stroke do
       pdf.move_down 10
       pdf.horizontal_rule
       pdf.move_down 15
       pdf.horizontal_rule
     end
     pdf.move_down 5
     pdf.text 'Установлены следующие нарушители:'
     end
        ro.rooms.each do |room|
          pdf.indent 50 do
            pdf.text room.description
          end
        end
        ro.persons.each do |person|
          pdf.indent 50 do
            pdf.text "#{person.short_name}, #{person.students.first.group.name}"
          end
        end
      pdf.move_down 5
    end
  end

  pdf.move_down 30
  pdf.text "Настоящий акт составлен в двух экземплярах, имеющих равную юридическую силу."
  pdf.move_down 20
  unless params[:applications] == '0'
    index = 1
    params[:applications].to_i.times do
      pdf.text "Приложение #{index}.                                                                                                                                                               на ____ л."
      pdf.move_down 5
      index+=1
    end
  end
  pdf.move_down 20
  pdf.text "<strong>Члены комиссии</strong>                                                                                                                     _______________ (_______________)", inline_format: true
  pdf.font 'PT', size: 7 do
     pdf.indent 385 do
       pdf.text 'подпись                   расшифровка'
     end
  end
  pdf.move_down 10
  pdf.indent 370 do
    pdf.text '_______________ (_______________)'
  end
  pdf.font 'PT', size: 7 do
    pdf.indent 385 do
      pdf.text 'подпись                   расшифровка'
    end
  end
  pdf.move_down 20
  pdf.text "<strong>С актом проверки ознакомлен:</strong>", inline_format: true
end