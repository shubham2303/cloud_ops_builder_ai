ActiveAdmin.register Batch do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form title: 'Create Batch' do |f|
	f.inputs 'Details' do
    render(:partial => 'batch_form')
  end
  actions

end	


	actions :index, :show, :create, :new


	index do
		id_column
		column :location
		column :net_worth
		column :created_at
		actions defaults: false do |batch|
			link_to "Download CSV", admin_batch_path(batch)
		end
	end

	form title: 'Create Batch' do |f|
		f.inputs 'Details' do
			div id:"batch_form" do
				render(:partial => 'test')
			end
		end
		actions
	end	

	controller do
		def create
			Batch.generate(p_batch)
			redirect_to :admin_batches
		end	

		def show
			@batch = Batch.find(params[:id])
			send_data @batch.to_csv, type: 'text/csv; charset=windows-1251; header=present', 
			disposition: "attachment; filename=batch_#{DateTime.now.to_s}.csv"
		end	

		private

		def p_batch
			amt_arr = params.require(:batch)[:amount]
			count_arr = params.require(:batch)[:count]
			final_arr = []
			amt_arr.zip(count_arr).each do |x| 
				hsh = {}
				hsh[:amount] = x[0] 
				hsh[:count] = x[1] 
				final_arr << hsh
			end
			final_arr
		end

	end	

end
