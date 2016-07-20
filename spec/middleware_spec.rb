# encoding: UTF-8

describe 'rack middleware' do
  it 'assembles production middleware' do
    # this can catch errors in production middleware configuration
    expect(
      system('rake middleware RAILS_ENV=production > /dev/null 2>&1')
    ).to eq(true)
  end
end
