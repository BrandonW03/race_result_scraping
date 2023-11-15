require 'fileutils'
require './runner_class.rb'
require './race_class.rb'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

nirca_xc_links = ["https://clubrunning.org/races/race_results.php?race=1114", "https://clubrunning.org/races/race_results.php?race=1109", "https://clubrunning.org/races/race_results.php?race=1123", "https://clubrunning.org/races/race_results.php?race=1104"]
school = "Ohio State University"

mech = Mechanize.new

def get_xc_races(nirca_links, mech, school)
	get_nirca_xc(nirca_links, mech, school)
end

def get_nirca_xc(nirca_links, mech, school)
	
	team = []
	max_runners = 500
	nirca_links.each do |link|
		curr_page = mech.get(link)

		curr_noko = Nokogiri::HTML(curr_page.content)

		race_name = curr_noko.xpath("//title")[0].text
		orig_date = curr_noko.xpath("//div")[10].text
		race_date = orig_date[/[A-Z][a-z]+ [\d]+, [\d]+/, 0]

		index = 1
		while(index < max_runners)
			curr_class = "column1 row#{index}"
			race_distance = "8000m"
			
			university_list = curr_noko.xpath("//*[@class=\"#{curr_class}\"]")
			check_index = 0
			university_list.each do |university|
				exists = false
				if(university != nil)
					if(university.text == school)
						osu_runner_last_name = curr_noko.xpath("//*[@class=\"column2 row#{index}\"]")[check_index].text
						osu_runner_first_name = curr_noko.xpath("//*[@class=\"column3 row#{index}\"]")[check_index].text
						osu_runner_sex = curr_noko.xpath("//*[@class=\"column6 row#{index}\"]/a")[check_index].get_attribute('onclick')
						
						curr_osu_runner = nil
						
						team.each do |person|
							if(person.same_person?(osu_runner_first_name, osu_runner_last_name))
								exists = true
								curr_osu_runner = person
							end
						end
							
						if(!exists && osu_runner_sex.include?("\"M\""))
							curr_osu_runner = Runner.new(osu_runner_first_name, osu_runner_last_name, "Male")
						elsif(!exists)
							curr_osu_runner = Runner.new(osu_runner_first_name, osu_runner_last_name, "Female")
							race_distance = "6000m"
						end
						
						race_time = curr_noko.xpath("//*[@class=\"column5 row#{index}\"]")[check_index].text
						curr_race = Race.new(race_name, race_date, race_distance, race_time, link)
						
						curr_osu_runner.add_xc_time(curr_race)
						team.append(curr_osu_runner)
					end
				end
				check_index = check_index + 1
			end
			
			index = index + 1
		end
	end
	
	return team
end

team = get_xc_races(nirca_xc_links, mech, school)
FileUtils.mkdir_p 'runners'

team.each do |curr_runner|
	curr_file = File.new("./runners/#{curr_runner.firstname}_#{curr_runner.lastname}.html", "w")
	if curr_file
	
	   curr_file.syswrite("<!DOCTYPE html>\n<html lang=\"en\">\n\t<head>\n\t\t<title>#{curr_runner.firstname} #{curr_runner.lastname}</title>\n\t\t<meta charset=\"utf-8\" />\n\t\t<link rel = \"stylesheet\" href = \"stylesheet.css\"/>\n\t</head>\n\t<body>\n\t\t<h1>#{curr_runner.firstname} #{curr_runner.lastname}</h1>\n\t\t<div class = \"crossCountry\">\n\t\t\t<div>\n\t\t\t\t<h2>Cross Country</h2>\n\t\t\t</div>\n\t\t\t<div>\n\t\t\t\t<table>\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th>Race</th>\n\t\t\t\t\t\t<th>Date</th>\n\t\t\t\t\t\t<th>Distance</th>\n\t\t\t\t\t\t<th>Time</th>\n\t\t\t\t\t</tr>")
	   
	   curr_runner.xctimes.each do |race|	curr_file.syswrite("\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<td>\n\t\t\t\t\t\t\t<a href = \"#{race.link}\">#{race.name}</a></td>\n\t\t\t\t\t\t<td>#{race.date}</td>\n\t\t\t\t\t\t<td>#{race.distance}</td>\n\t\t\t\t\t\t<td>#{race.time}</td>\n\t\t\t\t\t</tr>")
	   end
	   
	   curr_file.syswrite("\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t</body>\n</html>")
	   
	   curr_file.close
	else
	   puts "Unable to open file!"
	end
	
end
