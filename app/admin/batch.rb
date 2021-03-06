ActiveAdmin.register Batch do

	actions :index, :show , :new, :create

	config.filters = false

	index do
		id_column
		column :net_worth
		column :created_at ,:class => 'col-created_at time'
		actions defaults: false do |batch|
			div id: "reload_me_partial_batch_#{batch.id}" do
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
			if p_amount.blank? || p_count.select{|x| x != ""}.blank?
				error_msg = p_amount.blank? ? 'Amount field can not be blank.' : 'Count field can not be blank.'
				flash[:error] = error_msg
				redirect_to new_admin_batch_path
				return
			end	
			Batch.generate(p_batch)
			redirect_to :admin_batches
		end	

		def show
			begin
				@batch = Batch.find_by!(id: params[:id])
			rescue
				@id = params[:id]
			end
			unless request.xhr?
				send_data BatchDetail.csv(@batch) , type: 'text/csv; charset=windows-1251; header=present', 
				disposition: "attachment; filename=batch_#{@batch.created_at}.csv"
			end
		end

		private

		def p_amount
			params.require(:batch)[:amount]
		end	

		def p_count
			params.require(:batch)[:count]
		end	

		def p_batch
			# amt_arr = params.require(:batch)[:amount]
			# count_arr = params.require(:batch)[:count]
			dirty_arr = []
			p_amount.zip(p_count).each do |x| 
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
