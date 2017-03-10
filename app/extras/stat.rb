class Stat
	include ApplicationHelper

	def self.to_xlsx(start_date, end_date, admin_user)
		xlsx_package = Axlsx::Package.new
		wb = xlsx_package.workbook
		@collections = Collection.where("Date(created_at) >= ? AND Date(created_at) <= ?", start_date, end_date)

		wb.styles do |style|
			bold_wid_background = style.add_style(bg_color: "EFC376", b: true, :alignment=>{:horizontal => :center})
			center_align = style.add_style(:alignment=>{:horizontal => :center})

			wb.add_worksheet(name: "Agents") do |sheet|
				sheet.add_row ['Date Of Collection', 'Agent Id','First Name','Last Name', 
					'Business/Individual Name', 'LGA Of Collection', 'Payer Id',
					'Transaction id', 'Address', 'Mobile Number', 'Registration Date', 
					'Revenue Collected'], style: [bold_wid_background]*12
					
					@collections.each do |coll|
						agent = coll.agent
						ind_or_buss = coll.collectionable || coll.individual
						sheet.add_row [coll.created_at.strftime('%d-%m-%Y'), coll.agent_id, agent.first_name, 
							agent.last_name, ind_or_buss.name, 
							coll.try(:lga), coll.try(:individual).id, coll.id, agent.address, agent.phone, 
							agent.created_at.strftime('%d-%m-%Y'), coll.amount], style: [center_align]*12
						end
					end

					wb.add_worksheet(name: "Businesses") do |sheet|
						sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name', 
							'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business', 
							'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id', 
							'Total Revenue Paid'], style: [bold_wid_background]*17

							@collections.each do |coll|
								business = coll.collectionable
								ind_or_buss = business || coll.individual
								agent = coll.agent
								reg_date = business.try(:created_at) ? business.created_at.strftime("%d-%m-%Y") : ''
								sheet.add_row [coll.created_at.strftime('%d-%m-%Y'), business.try(:individual).try(:first_name), 
									business.try(:individual).try(:last_name), business.try(:individual).try(:phone), 
									ind_or_buss.name, coll.try(:individual).id, coll.id, reg_date, business.try(:address), 
									business.try(:lga), AppConfig.categories[:categories][coll.category_type], 
									AppConfig.categories[:sub_categories][coll.subtype], coll.period, 
									coll.amount, agent.name, agent.id, ind_or_buss.try(:amount)], 
									style: [center_align]*17
								end
							end

							wb.add_worksheet(name: "Individuals") do |sheet|
								sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name', 
									'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business', 
									'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id', 
									'Total Revenue Paid'], style: [bold_wid_background]*17

									@collections.each do |coll|
										individual = coll.individual
										ind_or_buss = coll.collectionable || coll.individual
										agent = coll.agent
										reg_date = individual.try(:created_at) ? individual.created_at.strftime("%d-%m-%Y") : ''
										sheet.add_row [coll.created_at.strftime('%d-%m-%Y'), individual.try(:first_name), 
											individual.try(:last_name), individual.try(:phone),
											ind_or_buss.name, coll.try(:individual).id, coll.id, 
											reg_date, individual.try(:address),  coll.try(:lga), 
											AppConfig.categories[:categories][coll.category_type],
											AppConfig.categories[:sub_categories][coll.subtype], coll.period, 
											coll.amount, agent.name, agent.id, ind_or_buss.try(:amount)], 
											style: [center_align]*17
										end
									end

									wb.add_worksheet(name: "Collection Report - Summary") do |sheet|
										sheet.add_row ['Date Of Collection','LGA','Category', 'Sub Category', 'Revenue Amount'], 
										style: [bold_wid_background]*5
										@collections.each do |coll|

											sheet.add_row [coll.created_at.strftime('%d-%m-%Y'), coll.try(:lga), 
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
