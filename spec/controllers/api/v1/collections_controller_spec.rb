require 'rails_helper'
require 'spec_helper'
require 'auth_helper'

RSpec.describe Api::V1::CollectionsController, type: :controller do

  include ApplicationHelper

  let (:agent) { FactoryGirl.create :agent }
  let (:token) { FactoryGirl.create :token, agent: agent }

  it "should pass decryption testing" do
    agent
    token
    set_headers(agent)
    rsa =  ApplicationHelper::StaticRSAHelper.new
    encrypted_secret = rsa.public_encrypt("123")
    decrypted_secret = rsa.decrypt(encrypted_secret)
    des =  ApplicationHelper::TripleDESHelper.new(decrypted_secret)
    encrypted_data = des.encrypt( '{"status":1, "otp":"1111"}')
    post :test_decryption, { secret: encrypted_secret, data: encrypted_data }
    expect( JSON.parse(response.body)['status'] ).to eq(1)
  end
end
