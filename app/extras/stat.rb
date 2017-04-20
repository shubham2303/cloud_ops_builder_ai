class Stat
	include ApplicationHelper

	def self.to_xlsx(start_date, end_date, stat_for, time_format)
		xlsx_package = Axlsx::Package.new
		wb = xlsx_package.workbook
    category_data = AppConfig.categories
    categories = category_data[:categories]
    sub_categories = category_data[:sub_categories]
		wb.styles do |style|
			bold_wid_background = style.add_style(bg_color: "EFC376", b: true, :alignment=>{:horizontal => :center})
			@center_align = style.add_style(:alignment=>{:horizontal => :center})
			@agent_sheet =  wb.add_worksheet(name: "Agents")
			@agent_sheet.add_row ['Date Of Collection', 'Agent Id','First Name','Last Name',
											 'Business/Individual Name/Vehicle Number', 'LGA Of Collection', 'Payer Id',
											 'Transaction id', 'Address', 'Mobile Number', 'Registration Date',
											 'Revenue Collected'], style: [bold_wid_background]*12

			@business_sheet = wb.add_worksheet(name: "Businesses")
			@business_sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name',
											 'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business',
											 'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id',
											 'Total Revenue Paid'], style: [bold_wid_background]*17

			@vehicle_sheet = wb.add_worksheet(name: "Vehicles")
			@vehicle_sheet.add_row ['Date Of Collection','Phone No', 'Vehicle Number',
											 'Payer Id', 'Transaction id', 'Date of Registration', 'LGA of Vehicle',
											 'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id',
											 'Total Revenue Paid'], style: [bold_wid_background]*17

			@individual_sheet = wb.add_worksheet(name: "Individuals")
			@individual_sheet.add_row ['Date Of Collection','First Name','Last Name','Phone No', 'Business/Individual Name/Vehicle Number',
											 'Payer Id', 'Transaction id', 'Date of Registration', 'Address', 'LGA of Business',
											 'Category', 'Sub Category','Period', 'Revenue Amount', 'Agent Name','Agent Id',
											 'Total Revenue Paid'], style: [bold_wid_background]*17

			@collection_sheet= wb.add_worksheet(name: "Collection Report - Summary")
			@collection_sheet.add_row ['Date Of Collection','LGA','Category', 'Sub Category', 'Revenue Amount'],
											style: [bold_wid_background]*5

		end
		Collection.fetch_for_stats(start_date, end_date, -1*time_format).find_each do |coll|

				ind_or_buss_or_veh = coll.collectionable
				agent_created_dt = coll.agent_cat ? ApplicationHelper.local_time(coll.agent_cat, time_format).strftime('%d-%m-%Y') : ''
				@agent_sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), coll.agent_id, coll.agent_fname,
									coll.agent_lname, ind_or_buss_or_veh.try(:vehicle_number)||ind_or_buss_or_veh.try(:name)||get_payer_name(coll),
									coll.lga, coll.payer_id, coll.uuid, coll.agent_address, coll.agent_phone,
									agent_created_dt, coll.amount], style: [@center_align]*12
				if coll.collectionable_type == "Business"
					business = coll.collectionable
					reg_date = business.try(:created_at) ? ApplicationHelper.local_time(business.created_at, time_format).strftime("%d-%m-%Y") : ''
					@business_sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), coll.payer_fname,
												 coll.payer_lname, coll.payer_phone,
												 business.name || get_payer_name(coll), coll.payer_id, coll.uuid, reg_date, business.address,
												 business.lga, categories[coll.category_type],
												 sub_categories[coll.subtype], coll.period,
												 coll.amount, get_agent_name(coll), coll.agent_id, business.amount],
												style: [@center_align]*17
				elsif coll.collectionable_type == "Vehicle"
					vehicle = coll.collectionable
					reg_date = vehicle.try(:created_at) ? ApplicationHelper.local_time(vehicle.created_at, time_format).strftime("%d-%m-%Y") : ''
					@vehicle_sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), vehicle.phone,
												 vehicle.vehicle_number, coll.payer_id, coll.uuid, reg_date,
												 vehicle.lga, categories[coll.category_type],
												 sub_categories[coll.subtype], coll.period,
												 coll.amount, get_agent_name(coll), coll.agent_id, vehicle.amount],
												style: [@center_align]*17
        else
          reg_date = coll.payer_cat ? ApplicationHelper.local_time(coll.payer_cat, time_format).strftime("%d-%m-%Y") : ''
          @individual_sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), coll.payer_fname,
                                     coll.payer_lname, coll.payer_phone,
                                     get_payer_name(coll), coll.payer_id, coll.uuid,
                                     reg_date, coll.payer_address, coll.lga,
                                     categories[coll.category_type],
                                     sub_categories[coll.subtype], coll.period,
                                     coll.amount, get_agent_name(coll), coll.agent_id, coll.payer_tot_amount],
                                    style: [@center_align]*17
				end
				@collection_sheet.add_row [ApplicationHelper.local_time(coll.created_at, time_format).strftime('%d-%m-%Y'), coll.lga,
											 categories[coll.category_type],
											 sub_categories[coll.subtype], coll.amount],
											style: [@center_align]*5

		end
		xlsx_package.use_shared_strings = true
		sample_file = xlsx_package.serialize('sample.xlsx')
		period = (stat_for == 'daily' ? start_date.to_s : "#{start_date.to_s} - #{end_date.to_s}")
		ApplicationMailer.send_stat(File.read("#{Rails.root.join('sample.xlsx')}"), period, stat_for).deliver
	end

	def self.get_agent_name(collection)
		collection.agent_fname + ' ' + collection.agent_lname
	end

	def self.get_payer_name(collection)
		collection.payer_fname + ' ' + collection.payer_lname
	end

end
