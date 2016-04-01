class SidebarController < ApplicationController
  def index
    @query = params['query']
    all_queries = []
    Article.all.each do |article|
      all_queries << article.title
    end
    if @query
      if all_queries.include? @query
        @translation = format_response Article.find_by(title: @query).description
      else
        @translation = "нет перевода"
      end
    end
  end

  private

  def format_response(response)
		response.gsub("(I)", "(I)<br>").gsub("(II)", "<br>(II)<br>")
		.gsub("(III)", "<br>(III)<br>").gsub("(IV)", "<br>(IV)<br>")
		.gsub("(V)", "<br>(V)<br>").gsub("(VI)", "<br>(VI)<br>")
		.gsub("(VII)", "<br>(VII)<br>").gsub("(VIII)", "<br>(VIII)<br>")
		.gsub("(IX)", "<br>(IX)<br>").gsub("(X)", "<br>(X)<br>")
		.gsub("1)", "<br>\t1)").gsub("2)", "<br>\t2)").gsub("3)", "<br>\t3)").gsub("4)", "<br>\t4)")
		.gsub("5)", "<br>\t5)").gsub("6)", "<br>\t6)").gsub("7)", "<br>\t7)").gsub("8)", "<br>\t8)")
		.gsub("9)", "<br>\t9)").gsub("10)", "<br>\t10)").gsub("11)", "<br>\t11)").gsub("12)", "<br>\t12)")
		.gsub("1.", "<br>1.").gsub("2.", "<br>2.").gsub("3.", "<br>3.").gsub("4.", "<br>4.").gsub("5.", "<br>5.")
		.gsub("6.", "<br>6.").gsub("7.", "<br>7.").gsub("8.", "<br>8.").gsub("9.", "<br>9.")
		.gsub("10.", "<br>10.").gsub("11.", "<br>11.").gsub("12.", "\<br>12.").gsub("13.", "<br>13.")
    #response.gsub("<br><br>", "<br>!")
	end

end
