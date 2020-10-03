require 'rails_helper'

class MockController
  include Authenticatable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe 'Authenticatable', type: :feature do
  before do
    @user = FactoryBot.create(:user)
    @authentication = MockController.new
  end

  it 'gets authentication token' do
    @authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: @user.id)
    expect(@authentication.current_user).to_not be_nil
    expect(@authentication.current_user.id).to eq(@user.id)
  end
end
