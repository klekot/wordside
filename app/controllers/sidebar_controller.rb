# Controller for getting translation results
#
class SidebarController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    @query       = params['query']
    advanced     = params['advanced']
    output       = params['format']
    @counter     = count(@query)[0]
    @translation   = search @query, advanced if @query
    @transcription = yandex(@query, 'transcription')[@query]
    respond_to do |format|
      json = {query: @query, translation: @translation[@query], transcription: @transcription }
      output == 'json' ? format.json { render json: json }: format.html
    end
  end

  private

  def search(query, advanced)
    request = Article.where(title: query).pluck(:title, :description)
    if advanced == 'on'
      request = Article.where('description LIKE ? ', "%#{query}%").pluck(:title, :description)
    end
    request.empty? ? yandex(query, 'translation') : get_results(request)
  end

  def get_results(request, translation = {})
    request.each do |r|
      key = r[0]
      val = r[1]
      title_alias = val.gsub('= ', '').strip
      if val.start_with?('=') && !Article.find_by(title: title_alias).nil?
        key = title_alias
        val = Article.find_by(title: title_alias).description
      end
      translation[key] = format_response language_colorize val
    end
    translation
  end

  def yandex(query, format, translation = {})
    eng_alphabet = []
    ('a'..'z').each { |l| eng_alphabet.push l }
    if eng_alphabet.include? query.chr
      yandex_query = 'https://dictionary.yandex.net/api/v1/dicservice/lookup?key=' + ENV['yandex_api_key'] + '&lang=en-ru&text=' + query
      result = Nokogiri::XML(open(yandex_query))
      translation[query] = format_response_xml result, format
    else
      flash[:alert] = 'Для этой формы допустимы только символы английского алфавита!'
    end
    translation
  end
end
