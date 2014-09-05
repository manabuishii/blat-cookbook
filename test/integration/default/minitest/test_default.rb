require 'minitest/autorun'
require 'json'

$node = ::JSON.parse(File.read('/tmp/attributes/blat/node.json'))
p $node

describe 'check blat' do
  it "check blat" do
    blatpath = "ls "+$node['blat']['installdirectory']+"/blat"
    assert system(blatpath), 'blat is not installed'
  end
end
