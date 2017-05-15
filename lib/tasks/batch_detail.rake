namespace :batch_detail do

  desc "Update remaining amount from nil to amount"
  task :update_nil_remaining_amount => :environment do
    BatchDetail.where(remaining_amount: nil).lock(true).update_all('remaining_amount = batch_details.amount')
  end
end
