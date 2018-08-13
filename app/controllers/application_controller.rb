class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception unless %w(development test).include? Rails.env

  protected

  def format_response_xml(xml_result, format)
    unless xml_result.nil?
      definition = Hash.from_xml(xml_result.to_s)['DicResult']['def']
      if definition.is_a? Hash
        if format == 'transcription'
          return definition['ts'].to_s
        end
        tr_hash = definition['tr']
        if tr_hash.is_a? Hash
          if tr_hash['syn'].is_a? Array
            syns = []
            tr_hash['syn'].each do |syn|
              syns.push ', ' + syn['text']
            end
            output_html = '<p>(' + tr_hash['pos'] + ') ' + tr_hash['text'] + syns.join(' ') + '</p>'
          elsif tr_hash['syn'].is_a? Hash
            output_html = '<p>(' + tr_hash['pos'] + ') ' + tr_hash['text'] + ', ' + tr_hash['syn']['text'] + '</p>'
          else
            output_html = '<p>(' + tr_hash['pos'] + ') ' + tr_hash['text'] + '</p>'
          end
        elsif tr_hash.is_a? Array
          output_html = []
          tr_hash.each do |tr|
            if tr['syn'].is_a? Array
              syns = []
              tr['syn'].each do |syn|
                syns.push ', ' + syn['text']
              end
              output_html.push '<p>(' + tr['pos'] + ') ' + tr['text'] + syns.join(' ') + '</p>'
            else
              output_html.push '<p>(' + tr['pos'] + ') ' + tr['text'] + '</p>'
            end
            output_html.join('<br>')
          end
        end
      elsif definition.is_a? Array
        if format == 'transcription'
          return definition[0]['ts'].to_s
        end
        output_html = []
        definition.each do |def_tag|
          if def_tag['tr'].is_a? Hash
            def_tag['tr'].store('pos', '') unless def_tag['tr']['pos']
            syns = []
            if def_tag['tr']['syn'].nil?
              output_html.push '<p>(' + def_tag['tr']['pos'] + ') ' + def_tag['tr']['text'] + '</p>'
            else
              if def_tag['tr']['syn'].is_a? Array
                def_tag['tr']['syn'].each do |syn|
                  syns.push ', ' + syn['text']
                end
                output_html.push '<p>(' + def_tag['tr']['pos'] + ') ' + def_tag['tr']['text'] +
                                     syns.join(' ') + '</p>'
              else
                syns.push ', ' + def_tag['tr']['syn']['text']
                output_html.push '<p>(' + def_tag['tr']['pos'] + ') ' + def_tag['tr']['text'] +
                                     syns.join(' ') + '</p>'
              end
            end
          else
            def_tag['tr'].each do |tr|
              syns = []
              if tr['syn'].is_a? Array
                if tr['syn'].nil?
                  output_html.push '<p>(' + tr['pos'] + ') ' + tr['text'] + '</p>'
                else
                  tr['syn'].each do |syn|
                    syns.push ', ' + syn['text']
                  end
                  output_html.push '<p>(' + tr['pos'] + ') ' + tr['text'] + syns.join(' ') + '</p>'
                end
              else
                if tr['syn'].nil?
                  output_html.push '<p>(' + tr['pos'] + ') ' + tr['text'] + '</p>'
                else
                  output_html.push '<p>(' + tr['pos'] + ') ' + tr['text'] + tr['syn']['text'] + '</p>'
                end
              end
            end
          end
        end
        output_html.join('<br>')
      end
    end
  end

  def format_response(response)
    response
        .gsub('v.; modal', '<span class="serv-word-blue-italic">модальный глагол: </span>')
        .gsub(';',         ';<br>')
        .gsub(',',         ', ')
        .gsub(', ',        ', ')
        .gsub(')',         ') ')
        .gsub('(I)',       '    <span class="serv-word-blue">Первое зачение</span><br>')
        .gsub('(II)',      '<br><br><span class="serv-word-blue">Второе зачение</span>')
        .gsub('(III)',     '<br><br><span class="serv-word-blue">Третье зачение</span>')
        .gsub('(IV)',      '<br><br><span class="serv-word-blue">Четвёртое зачение</span>')
        .gsub('(V)',       '<br><br><span class="serv-word-blue">Пятое зачение</span>')
        .gsub('(VI)',      '<br><br><span class="serv-word-blue">Шестое зачение</span>')
        .gsub('(VII)',     '<br><br><span class="serv-word-blue">Седьмое зачение</span>')
        .gsub('(VIII)',    '<br><br><span class="serv-word-blue">Восьмое зачение</span>')
        .gsub('(IX)',      '<br><br><span class="serv-word-blue">Девятое зачение</span>')
        .gsub('(X)',       '<br><br><span class="serv-word-blue">Десятое зачение</span>')
        .gsub('1)',        "<br><span class=\"serv-word-green\">\t1)</span>")
        .gsub('2)',        "<br><span class=\"serv-word-green\">\t2)</span>")
        .gsub('3)',        "<br><span class=\"serv-word-green\">\t3)</span>")
        .gsub('4)',        "<br><span class=\"serv-word-green\">\t4)</span>")
        .gsub('5)',        "<br><span class=\"serv-word-green\">\t5)</span>")
        .gsub('6)',        "<br><span class=\"serv-word-green\">\t6)</span>")
        .gsub('7)',        "<br><span class=\"serv-word-green\">\t7)</span>")
        .gsub('8)',        "<br><span class=\"serv-word-green\">\t8)</span>")
        .gsub('9)',        "<br><span class=\"serv-word-green\">\t9)</span>")
        .gsub('10)',       "<br><span class=\"serv-word-green\">\t10)</span>")
        .gsub('11)',       "<br><span class=\"serv-word-green\">\t11)</span>")
        .gsub('12)',       "<br><span class=\"serv-word-green\">\t12)</span>")
        .gsub('1.',        '<br><span class="serv-word-orange">1. </span>')
        .gsub('2.',        '<br><span class="serv-word-orange">2. </span>')
        .gsub('3.',        '<br><span class="serv-word-orange">3. </span>')
        .gsub('4.',        '<br><span class="serv-word-orange">4. </span>')
        .gsub('5.',        '<br><span class="serv-word-orange">5. </span>')
        .gsub('6.',        '<br><span class="serv-word-orange">6. </span>')
        .gsub('7.',        '<br><span class="serv-word-orange">7. </span>')
        .gsub('8.',        '<br><span class="serv-word-orange">8. </span>')
        .gsub('9.',        '<br><span class="serv-word-orange">9. </span>')
        .gsub('10.',       '<br><span class="serv-word-orange">10. </span>')
        .gsub('11.',       '<br><span class="serv-word-orange">11. </span>')
        .gsub('12.',       '<br><span class="serv-word-orange">12. </span>')
        .gsub('13.',       '<br><span class="serv-word-orange">13. </span>')
        .gsub('Syn: ',     '<br><span class="serv-word-violet">Синонимы: </span>')
        .gsub('Ant: ',     '<br><span class="serv-word-sienna">Антонимы: </span>')
        .gsub('^Syn: ',    '<br><span class="serv-word-violet">Синонимы: </span>')
        .gsub('^Ant: ',    '<br><span class="serv-word-sienna">Антонимы: </span>')
        .gsub('adv.',      '<span class="serv-word-blue-italic"> наречие: </span>')
        .gsub('prov.',     '<span class="serv-word-blue-italic"> Поговорка: </span>')
        .gsub('^adv.',     '<span class="serv-word-blue-italic"> наречие: </span>')
        .gsub('v.',        '<span class="serv-word-blue-italic">глагол: </span>')
        .gsub('v.;',       '<span class="serv-word-blue-italic">глагол: </span>')
        .gsub('v.; ',      '<span class="serv-word-blue-italic">глагол: </span>')
        .gsub('^v.',       '<span class="serv-word-blue-italic">глагол: </span>')
        .gsub('^v.;',      '<span class="serv-word-blue-italic">глагол: </span>')
        .gsub('^v.; ',     '<span class="serv-word-blue-italic">глагол: </span>')
        .gsub('noun',      '<span class="serv-word-blue-italic"> имя существительное: </span>')
        .gsub('noun.',     '<span class="serv-word-blue-italic"> имя существительное: </span>')
        .gsub('^noun',     '<span class="serv-word-blue-italic"> имя существительное: </span>')
        .gsub('^noun.',    '<span class="serv-word-blue-italic"> имя существительное: </span>')
        .gsub('pron.',     '<span class="serv-word-blue-italic"> местоимение: </span>')
        .gsub('cj.',       '<span class="serv-word-blue-italic"> союз: </span>')
        .gsub('^cj.',      '<span class="serv-word-blue-italic"> союз: </span>')
        .gsub('adj.',      '<span class="serv-word-blue-italic"> имя прилагательное: </span>')
        .gsub('^adj.',     '<span class="serv-word-blue-italic"> имя прилагательное: </span>')
        .gsub('attr.',     '<span class="serv-word-teal"> (свойство) </span>')
        .gsub('indef.',    '<span class="serv-word-teal"> (неопределённое) </span>')
        .gsub('inter.',    '<span class="serv-word-teal"> (вопросительное) </span>')
        .gsub('abbr. of',  '<span class="serv-word-teal"> сокращение от </span>')
        .gsub('coll.',     '<span class="serv-word-teal"> (в переносном смысле) </span>')
        .gsub('pl.',       '<span class="serv-word-teal"> (множественное число) </span>')
        .gsub('.;<br>',    '.;')
  end

  def language_colorize(text)
    rus_alphabet = []
    ('а'..'я').each { |l| rus_alphabet.push l }; rus_alphabet.push 'ё'

    array = text.split(' ')
    array.each_with_index do |word, index|
      if rus_alphabet.include? word.chr
        array[index] = '<span class="rus-word">' + word + '</span>'
      end
    end
    array.join(' ')
  end

  def count(query)
    article = Article.find_by(title: query).id unless Article.find_by(title: query).nil?
    user    = current_user.id unless current_user.nil?
    if Counter.find_by(article_id: article, user_id: user).nil?
      counter = Counter.new(counter: 1, article_id: article, user_id: user)
      counter.save
    else
      counter = Counter.find_by(article_id: article, user_id: user)
      counter.counter += 1
      counter.save
    end
    [counter.counter, counter.updated_at]
  end

end
