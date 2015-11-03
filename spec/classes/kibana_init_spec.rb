require 'spec_helper'

describe 'kibana', :type => :class do
  it { should contain_class('kibana') }
end

