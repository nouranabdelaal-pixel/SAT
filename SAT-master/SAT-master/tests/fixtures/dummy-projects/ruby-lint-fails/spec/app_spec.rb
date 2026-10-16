# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe 'add' do
  it('adds') { expect(add(1, 2)).to eq(3) }
end
