class Stat
	include ApplicationHelper

	def self.to_xlsx(start_date, end_date)
		xlsx_package = Axlsx::Package.new
		wb = xlsx_package.workbook
		stat_for = 'daily'

		wb.styles do |style|
			bold_wid_background = style.add_style(bg_color: "EFC376", b: true, :alignment=>{:horizontal => :center})
			center_align = style.add_style(:alignment=>{:horizontal => :center})

			wb.add_worksheet(name: "Agents") do |sheet|
				sheet.add_row ['Date Of Collection', 'Agent Id','First Name','Last Name', 
					'Business/Individual Name', 'LGA Of Collection', 'Payer Id',
					'Transaction id', 'Address', 'Mobile Number', 'Registration Date', 
					'Revenue Collected'], style: [bold_wid_background]*12

					@collections = Collection.where("Date(created_at) >= ? AND Date(created_at) <= ?", start_date, end_date)
					@collections.each do |coll|
						agent = coll.agent
						agent_name = coll.agent.name.split(' ')
						ind_or_buss = coll.business || coll.individual
						sheet.add_row [coll.created_at.to_date, coll.agent_id, agent_name[0], agent_name[1], ind_or_buss.name, 
						coll.try(:lga), coll.try(:individual).id, coll.id, agent.address, agent.phone, 
						agent.created_at.to_date, coll.amount], style: [center_align]*12
					end
				end

				wb.add_worksheet(name: "Businesses") do |sheet|
					sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name', 
						'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business', 
						'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id', 
						'Total Revenue Paid'], style: [bold_wid_background]*17

						@collections = Collection.where("Date(created_at) >= ? AND Date(created_at) <= ?", start_date, end_date)
						@collections.each do |coll|
							agent = coll.agent
							agent_name = coll.agent.name.split(' ')
							ind_or_buss = coll.business || coll.individual
							sheet.add_row [coll.created_at.to_date, coll.agent_id, agent_name[0], agent_name[1], ind_or_buss.name, 
							coll.try(:lga), coll.try(:individual).id, coll.id, agent.address, agent.phone, 
							agent.created_at.to_date, coll.amount], style: [center_align]*12
						end
					end

					wb.add_worksheet(name: "Individuals") do |sheet|
					end	

					wb.add_worksheet(name: "Collection Report - Summary") do |sheet|
					end

				end
				xlsx_package.use_shared_strings = true
				sample_file = xlsx_package.serialize('sample.xlsx')
				ApplicationMailer.send_stat(sample_file).deliver
			end
		end
