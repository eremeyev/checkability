# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative '../lib/checkability'
require 'pry'

RSpec.describe Checkability::ActsAsCheckable do
  setup_db
#  before(:each) do
#    conf = { storage_class: Struct.new(:value) }
#    @object = @storage_checker = StorageChecker.new(conf)
#  end
  
  

  describe 'respond to method' do
    it 'calls perform method' do
      record = instance_double("Record")
      allow(record).to receive(:perform)
      record.perform
    end
    it 'calls acts_as_checkable method' do
      klass = class_double("Record")
      allow(klass).to receive(:acts_as_checkable)
      klass.acts_as_checkable
    end
  end
  
#  it_behaves_like 'Checker', Checkability::Validator
end
