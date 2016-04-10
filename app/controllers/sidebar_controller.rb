class SidebarController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
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
        val = format_response r.description
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
    @query = query
    #@translation = translation
    yandex_api_key = "dict.1.1.20150909T192757Z.a7faa86c794ef318.30842ee89a25dc7e5d02fc1c8562110f5d856a59";
    yandex_query = "https://dictionary.yandex.net/api/v1/dicservice/lookup?key="+yandex_api_key+"&lang=en-ru&text="+@query
    @translation[@query] = Nokogiri::XML(open(yandex_query)).to_s
  end

  def format_response(response)
		response
    .gsub("(I)",    "    <span class=\"serv-word-blue\">Первое зачение</span><br>")
    .gsub("(II)",   "<br><span class=\"serv-word-blue\">Второе зачение</span><br>")
		.gsub("(III)",  "<br><span class=\"serv-word-blue\">Третье зачение</span><br>")
    .gsub("(IV)",   "<br><span class=\"serv-word-blue\">Четвёртое зачение</span><br>")
		.gsub("(V)",    "<br><span class=\"serv-word-blue\">Пятое зачение</span><br>")
    .gsub("(VI)",   "<br><span class=\"serv-word-blue\">Шестое зачение</span><br>")
    .gsub("(VII)",  "<br><span class=\"serv-word-blue\">Седьмое зачение</span><br>")
    .gsub("(VIII)", "<br><span class=\"serv-word-blue\">Восьмое зачение</span><br>")
    .gsub("(IX)",   "<br><span class=\"serv-word-blue\">Девятое зачение</span><br>")
    .gsub("(X)",    "<br><span class=\"serv-word-blue\">Десятое зачение</span><br>")
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
		.gsub("1.",     "<br><span class=\"serv-word-orange\">1.</span>")
    .gsub("2.",     "<br><span class=\"serv-word-orange\">2.</span>")
    .gsub("3.",     "<br><span class=\"serv-word-orange\">3.</span>")
    .gsub("4.",     "<br><span class=\"serv-word-orange\">4.</span>")
    .gsub("5.",     "<br><span class=\"serv-word-orange\">5.</span>")
		.gsub("6.",     "<br><span class=\"serv-word-orange\">6.</span>")
    .gsub("7.",     "<br><span class=\"serv-word-orange\">7.</span>")
    .gsub("8.",     "<br><span class=\"serv-word-orange\">8.</span>")
    .gsub("9.",     "<br><span class=\"serv-word-orange\">9.</span>")
		.gsub("10.",    "<br><span class=\"serv-word-orange\">10.</span>")
    .gsub("11.",    "<br><span class=\"serv-word-orange\">11.</span>")
    .gsub("12.",    "<br><span class=\"serv-word-orange\">12.</span>")
    .gsub("13.",    "<br><span class=\"serv-word-orange\">13.</span>")
    .gsub("; ",     ";<br>")
    #response.gsub("<br><br>", "<br>!")
	end

end
