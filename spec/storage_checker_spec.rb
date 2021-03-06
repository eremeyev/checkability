# frozen_string_literal: true

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'support/checker_interface_spec'
klass = Checkability::StorageChecker
RSpec.describe klass do
  before(:each) { setup_db }
  after(:each) { teardown_db }

  it_behaves_like 'Checker', klass

  let!(:postcode) { Postcode.create(value: 'SH241AA') }
  let(:storage_checker) do
    klass.new(storage_conf)
  end
  let(:check_existing_postcode) { Check.new(value: 'SH241AA') }
  context 'when input a postcode which is EXISTS in local storage' do
    specify 'message include `Found`' do
      check_existing_postcode.ch_messages = []
      storage_checker.handle(check_existing_postcode)
      expect(check_existing_postcode.ch_messages).to include(/FOUND/)
    end
  end
  let(:check_nonexisting_postcode) { Check.new(value: 'XX11XX') }
  context 'when input a postcode which is NOT EXISTS in local storage' do
    specify 'message include `Not found`' do
      check_nonexisting_postcode.ch_messages = []
      storage_checker.handle(check_nonexisting_postcode)
      expect(check_nonexisting_postcode.ch_messages).to include(/NOT BEEN FOUND/)
    end
  end
end
