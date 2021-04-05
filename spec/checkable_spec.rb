# frozen_string_literal: true

require_relative '../lib/checkability'

def klass
  Checkability::Checkable
end

RSpec.describe klass, :aggregate_failure do
  before(:each) { setup_db }
  after(:each)  { teardown_db }

  let!(:check_valid_postcode) { Check.create(value: 'SE17QD') }
  let!(:check_obj_valid) { klass.new(check_valid_postcode) }

  context "when #check with @value = 'SE17QD'" do
    it 'valid by Postcode regex' do
      check_obj_valid.check({ 'Validator' => validator_conf.merge(next_handler: nil) })

      expect(check_obj_valid.ch_messages).to include(/COMPLY/)
      expect(check_obj_valid.ch_allowed).to be(true)
    end
  end

  let!(:check_outside_postcode) { Check.create(value: 'RM30DP', ch_messages: [], ch_allowed: nil) }
  let!(:checkable_outside) { klass.new(check_outside_postcode) }
  context "when #check with @value = 'RM30PD'" do
    it 'excluded by postcodes.io' do
      checkable_outside.check(uk_postcode_checkers_conf)
      expect(checkable_outside.ch_allowed).to be(false)
    end
  end
end
