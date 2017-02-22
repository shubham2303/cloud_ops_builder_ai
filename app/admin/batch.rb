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
    render(:partial => 'test')
  end
  actions
end	

controller do
	def create
		Batch.generate(p_batch)
		redirect_to :admin_batches
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
