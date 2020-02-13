# frozen_string_literal: true

RSpec.describe RubyGemTemplate do
  it 'has a version number' do
    expect(RubyGemTemplate::Base::VERSION).not_to be nil
  end
end
