ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Reports", class: 'input' do
          render 'admin/reports/search_report_form'
        end
        render 'admin/reports/table_content'
      end
    end
  end # content

  # controller do
    
  #   def generate_reports
  #     if(params[:start_date] > params[:end_date])
  #       render 'admin/reports/date_range_error.js.erb'
  #     else
  #       StatGenerationWorker.perform_async(params[:start_date], params[:end_date], current_admin_user.id, params[:time_format])
  #     end
  #   end
  # end  
end
