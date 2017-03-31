class Stat
	include ApplicationHelper

	def self.to_xlsx(start_date, end_date, admin_user, time_format)
		xlsx_package = Axlsx::Package.new
		wb = xlsx_package.workbook
		@collections = Collection.where("Date(created_at) >= ? AND Date(created_at) <= ?", start_date, end_date)

		wb.styles do |style|
			bold_wid_background = style.add_style(bg_color: "EFC376", b: true, :alignment=>{:horizontal => :center})
			center_align = style.add_style(:alignment=>{:horizontal => :center})

			wb.add_worksheet(name: "Agents") do |sheet|
				sheet.add_row ['Date Of Collection', 'Agent Id','First Name','Last Name', 
									 'Business/Individual Name/Vehicle Number', 'LGA Of Collection', 'Payer Id',
									 'Transaction id', 'Address', 'Mobile Number', 'Registration Date', 
									 'Revenue Collected'], style: [bold_wid_background]*12

				@collections.each do |coll|
					agent = coll.agent
					ind_or_buss_or_veh = coll.collectionable || coll.individual
					agent_created_dt = agent.try(:created_at) ? ApplicationHelper.local_time(agent.created_at, time_format).strftime('%d-%m-%Y') : ''
					sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), coll.agent_id, agent.try(:first_name),
										agent.try(:last_name), ind_or_buss_or_veh.try(:vehicle_number)||ind_or_buss_or_veh.try(:name),
										coll.try(:lga), coll.individual.try(:uuid), coll.id, agent.try(:address), agent.try(:phone),
										agent_created_dt, coll.amount], style: [center_align]*12
				end
			end

			wb.add_worksheet(name: "Businesses") do |sheet|
				collections = @collections.where(collectionable_type: "Business")
				sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name',
									 'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business',
									 'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id',
									 'Total Revenue Paid'], style: [bold_wid_background]*17

				collections.each do |coll|
					business = coll.collectionable
					agent = coll.agent
					reg_date = business.try(:created_at) ? ApplicationHelper.local_time(business.created_at, time_format).strftime("%d-%m-%Y") : ''
					sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), business.try(:individual).try(:first_name),
										business.try(:individual).try(:last_name), business.try(:individual).try(:phone),
										business.try(:name) || business.try(:individual).try(:name), coll.try(:individual).try(:uuid), coll.id, reg_date, business.try(:address),
										business.try(:lga), AppConfig.categories[:categories][coll.category_type],
										AppConfig.categories[:sub_categories][coll.subtype], coll.period,
										coll.amount, agent.try(:name), agent.try(:id), business.try(:amount)],
					style: [center_align]*17
				end
			end

			wb.add_worksheet(name: "Vehicles") do |sheet|
				collections = @collections.where(collectionable_type: "Vehicle")
				sheet.add_row ['Date Of Collection','Phone No', 'Vehicle Number',
									 'Payer Id', 'Transaction id', 'Date of Registration', 'LGA of Vehicle',
									 'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id',
									 'Total Revenue Paid'], style: [bold_wid_background]*17

				collections.each do |coll|
					vehicle = coll.collectionable
					agent = coll.agent
					reg_date = vehicle.try(:created_at) ? ApplicationHelper.local_time(vehicle.created_at, time_format).strftime("%d-%m-%Y") : ''
					sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), vehicle.try(:phone),
										vehicle.try(:vehicle_number), coll.try(:individual).try(:uuid), coll.id, reg_date,
										vehicle.try(:lga), AppConfig.categories[:categories][coll.category_type],
										AppConfig.categories[:sub_categories][coll.subtype], coll.period,
										coll.amount, agent.try(:name), agent.try(:id), vehicle.try(:amount)],
					style: [center_align]*17
				end
			end

			wb.add_worksheet(name: "Individuals") do |sheet|
				sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name/Vehicle Number',
									 'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business', 
									 'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id', 
									 'Total Revenue Paid'], style: [bold_wid_background]*17

				@collections.each do |coll|
					individual = coll.individual
					ind_or_buss_or_veh = coll.collectionable || coll.individual
					agent = coll.agent
					reg_date = individual.try(:created_at) ? ApplicationHelper.local_time(individual.created_at, time_format).strftime("%d-%m-%Y") : ''
					sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), individual.try(:first_name),
										individual.try(:last_name), individual.try(:phone),
										ind_or_buss_or_veh.try(:vehicle_number) || ind_or_buss_or_veh.try(:name), coll.try(:individual).try(:id), coll.id,
										reg_date, individual.try(:address),  coll.try(:lga), 
										AppConfig.categories[:categories][coll.category_type],
										AppConfig.categories[:sub_categories][coll.subtype], coll.period, 
										coll.amount, agent.try(:name), agent.try(:id), ind_or_buss_or_veh.try(:amount)],
					style: [center_align]*17
				end
			end

			wb.add_worksheet(name: "Collection Report - Summary") do |sheet|
				sheet.add_row ['Date Of Collection','LGA','Category', 'Sub Category', 'Revenue Amount'], 
					style: [bold_wid_background]*5
				@collections.each do |coll|

					sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), coll.try(:lga),
										AppConfig.categories[:categories][coll.category_type], 
										AppConfig.categories[:sub_categories][coll.subtype], coll.amount],
					style: [center_align]*5
				end
			end

		end
		xlsx_package.use_shared_strings = true
		sample_file = xlsx_package.serialize('sample.xlsx')
		ApplicationMailer.send_stat(File.read("#{Rails.root.join('sample.xlsx')}"), admin_user, "#{start_date.to_s} - #{end_date.to_s}").deliver
	end
end
