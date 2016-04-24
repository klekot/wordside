class SidebarController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  @@eng_alphabet = []; ('a'..'z').each { |l| @@eng_alphabet.push l }
  @@rus_alphabet = []; ('а'..'я').each { |l| @@rus_alphabet.push l }; @@rus_alphabet.push "ё"

  def index
    @query = params['query']
    search @query if @query
  end

  private

  def search(query)
    @query = query
    result = Article.where(title: @query)
    @translation = {}   
    if result.size > 0
      result.each do |r|
        key = r.title
        val = format_response language_colorize r.description
        if val.starts_with?("=")
          title_alias = val.gsub("= ", "").strip
          @translation[key + " = " + title_alias] = format_response Article.find_by(title: title_alias).description
        else
          yandex(@query)
          @translation[key] = val
        end
      end 
    else
      yandex(@query)
    end
  end

  def yandex(query)
    if @@eng_alphabet.include? query.chr
      @query = query
      #@translation = translation
      yandex_api_key = "dict.1.1.20150909T192757Z.a7faa86c794ef318.30842ee89a25dc7e5d02fc1c8562110f5d856a59";
      yandex_query = "https://dictionary.yandex.net/api/v1/dicservice/lookup?key="+yandex_api_key+"&lang=en-ru&text="+@query
      result = Nokogiri::XML(open(yandex_query))
      @translation[@query] = format_response_xml result
    else
      flash[:alert] = "Для этой формы допустимы только символы английского алфавита!"
    end
  end

  def format_response_xml(xml_result)
    xml_result.xpath("//def").inner_text
  end

  def format_response(response)
		response
    .gsub("v.; modal", "<span class=\"serv-word-blue-italic\">модальный глагол: </span>")
    .gsub(";",      ";<br>")
    .gsub(",",      ", ")
    .gsub(", ",     ", ")
    .gsub(")",      ") ")
    .gsub("(I)",    "    <span class=\"serv-word-blue\">Первое зачение</span><br>")
    .gsub("(II)",   "<br><br><span class=\"serv-word-blue\">Второе зачение</span>")
		.gsub("(III)",  "<br><br><span class=\"serv-word-blue\">Третье зачение</span>")
    .gsub("(IV)",   "<br><br><span class=\"serv-word-blue\">Четвёртое зачение</span>")
		.gsub("(V)",    "<br><br><span class=\"serv-word-blue\">Пятое зачение</span>")
    .gsub("(VI)",   "<br><br><span class=\"serv-word-blue\">Шестое зачение</span>")
    .gsub("(VII)",  "<br><br><span class=\"serv-word-blue\">Седьмое зачение</span>")
    .gsub("(VIII)", "<br><br><span class=\"serv-word-blue\">Восьмое зачение</span>")
    .gsub("(IX)",   "<br><br><span class=\"serv-word-blue\">Девятое зачение</span>")
    .gsub("(X)",    "<br><br><span class=\"serv-word-blue\">Десятое зачение</span>")
		.gsub("1)",     "<br><span class=\"serv-word-green\">\t1)</span>")
    .gsub("2)",     "<br><span class=\"serv-word-green\">\t2)</span>")
    .gsub("3)",     "<br><span class=\"serv-word-green\">\t3)</span>")
    .gsub("4)",     "<br><span class=\"serv-word-green\">\t4)</span>")
		.gsub("5)",     "<br><span class=\"serv-word-green\">\t5)</span>")
    .gsub("6)",     "<br><span class=\"serv-word-green\">\t6)</span>")
    .gsub("7)",     "<br><span class=\"serv-word-green\">\t7)</span>")
    .gsub("8)",     "<br><span class=\"serv-word-green\">\t8)</span>")
		.gsub("9)",     "<br><span class=\"serv-word-green\">\t9)</span>")
    .gsub("10)",    "<br><span class=\"serv-word-green\">\t10)</span>")
    .gsub("11)",    "<br><span class=\"serv-word-green\">\t11)</span>")
    .gsub("12)",    "<br><span class=\"serv-word-green\">\t12)</span>")
    .gsub("1.",     "<br><span class=\"serv-word-orange\">1. </span>")
    .gsub("2.",     "<br><span class=\"serv-word-orange\">2. </span>")
    .gsub("3.",     "<br><span class=\"serv-word-orange\">3. </span>")
    .gsub("4.",     "<br><span class=\"serv-word-orange\">4. </span>")
    .gsub("5.",     "<br><span class=\"serv-word-orange\">5. </span>")
    .gsub("6.",     "<br><span class=\"serv-word-orange\">6. </span>")
    .gsub("7.",     "<br><span class=\"serv-word-orange\">7. </span>")
    .gsub("8.",     "<br><span class=\"serv-word-orange\">8. </span>")
    .gsub("9.",     "<br><span class=\"serv-word-orange\">9. </span>")
    .gsub("10.",    "<br><span class=\"serv-word-orange\">10. </span>")
    .gsub("11.",    "<br><span class=\"serv-word-orange\">11. </span>")
    .gsub("12.",    "<br><span class=\"serv-word-orange\">12. </span>")
    .gsub("13.",    "<br><span class=\"serv-word-orange\">13. </span>")
    .gsub("Syn: ",    "<br><span class=\"serv-word-violet\">Синонимы: </span>")
    .gsub("Ant: ",    "<br><span class=\"serv-word-sienna\">Антонимы: </span>")
    .gsub("^Syn: ",    "<br><span class=\"serv-word-violet\">Синонимы: </span>")
    .gsub("^Ant: ",    "<br><span class=\"serv-word-sienna\">Антонимы: </span>")
    .gsub("adv.",    "<span class=\"serv-word-blue-italic\"> наречие: </span>")
    .gsub("prov.",    "<span class=\"serv-word-blue-italic\"> Поговорка: </span>")
    .gsub("^adv.",    "<span class=\"serv-word-blue-italic\"> наречие: </span>")
    .gsub("v.",    "<span class=\"serv-word-blue-italic\">глагол: </span>")
    .gsub("v.;",    "<span class=\"serv-word-blue-italic\">глагол: </span>")
    .gsub("v.; ",    "<span class=\"serv-word-blue-italic\">глагол: </span>")
    .gsub("^v.",    "<span class=\"serv-word-blue-italic\">глагол: </span>")
    .gsub("^v.;",    "<span class=\"serv-word-blue-italic\">глагол: </span>")
    .gsub("^v.; ",    "<span class=\"serv-word-blue-italic\">глагол: </span>")
    .gsub("noun",    "<span class=\"serv-word-blue-italic\"> имя существительное: </span>")
    .gsub("noun.",    "<span class=\"serv-word-blue-italic\"> имя существительное: </span>")  
    .gsub("^noun",    "<span class=\"serv-word-blue-italic\"> имя существительное: </span>")
    .gsub("^noun.",    "<span class=\"serv-word-blue-italic\"> имя существительное: </span>")
    .gsub("cj.",    "<span class=\"serv-word-blue-italic\"> союз: </span>")
    .gsub("^cj.",    "<span class=\"serv-word-blue-italic\"> союз: </span>")
    .gsub("adj.",    "<span class=\"serv-word-blue-italic\"> имя прилагательное: </span>")
    .gsub("^adj.",    "<span class=\"serv-word-blue-italic\"> имя прилагательное: </span>")
    .gsub("attr.",    "<span class=\"serv-word-teal\"> (свойство) </span>")
    .gsub("abbr. of",    "<span class=\"serv-word-teal\"> сокращение от </span>")
    .gsub("coll.",    "<span class=\"serv-word-teal\"> (в переносном смысле) </span>")
    .gsub(".;<br>",      ".;")
	end

  def language_colorize(text)
    array = text.split(' ')
    array.each_with_index do |word, index|
      #array[index] = "<span class=\"eng-word\">" + word + "</span>" if @@eng_alphabet.include? word.chr
      array[index] = "<span class=\"rus-word\">" + word + "</span>" if @@rus_alphabet.include? word.chr
    end
    array.join(' ')
  end
end
