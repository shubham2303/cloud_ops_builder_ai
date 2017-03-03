ActiveAdmin.register Batch do

	actions :index, :show , :new, :create

	config.filters = false

	index do
		id_column
		column :net_worth
		column :created_at
		actions defaults: false do |batch|
			div id: 'reload_me_partial_batch' do
				render 'reload_form', { batch: batch } 
			end
		end
	end

	form title: 'Create Batch', :html => { :class => "validations" }  do |f|
		f.inputs 'Details' do
			render(:partial => 'batch_form')
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
			unless request.xhr?
				send_data BatchDetail.csv(@batch) , type: 'text/csv; charset=windows-1251; header=present', 
				disposition: "attachment; filename=batch_#{DateTime.now.to_s}.csv"
			end
		end

		private

		def p_batch
			amt_arr = params.require(:batch)[:amount]
			count_arr = params.require(:batch)[:count]
			dirty_arr = []
			amt_arr.zip(count_arr).each do |x| 
				hsh = {}
				hsh[:amount] = x[0] 
				hsh[:count] = x[1] 
				dirty_arr << hsh
			end

			dirty_hsh = dirty_arr.group_by{|h| h[:amount] }
			final_arr = []
			dirty_hsh.each do |k,v|
				hsh = {}
				hsh[:amount] = k
				hsh[:count] = v.map{|x| x[:count]}.map(&:to_i).reduce(&:+)
				final_arr << hsh
			end	
			final_arr
		end

	end	

end
