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
		# redirect_to :admin_batches_path
	end	

	private
	def p_batch
		params.permit(batch: [:amount, :count])
	end	

end	

end
