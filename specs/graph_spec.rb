require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

describe GraphiteDashboardApi::Graph do

  it 'can be constructed' do

    graph = GraphiteDashboardApi::Graph.new('Test graph') do
      from "-4hours"
      until_ '-2hours'
    end

    expect(graph).to be_a_kind_of(GraphiteDashboardApi::Graph)
    expect(graph.from).to eq("-4hours")
    expect(graph.until).to eq("-2hours")
  end

  it 'can be converted to json' do
    expected_json = JSON.parse('{"until": "now","from": "-5minutes","target": ["storage.rsyslog.action1.processed.kestrel01-am5"],"title": "title"}')
    graph = GraphiteDashboardApi::Graph.new "title" do
      from "-5minutes"
      until_ 'now'
      targets ['storage.rsyslog.action1.processed.kestrel01-am5']
    end
    expect(graph.target_encode).to eq "target=storage.rsyslog.action1.processed.kestrel01-am5"
    expect(JSON.parse(JSON.generate(graph.to_hash))).to eq expected_json
  end

  it 'can be converted to json when no title' do
    expected_json = JSON.parse('{"until": "now","from": "-5minutes","target": ["storage.rsyslog.action1.processed.kestrel01-am5"]}')
    graph = GraphiteDashboardApi::Graph.new nil do
      from "-5minutes"
      until_ 'now'
      targets ['storage.rsyslog.action1.processed.kestrel01-am5']
    end
    expect(graph.target_encode).to eq "target=storage.rsyslog.action1.processed.kestrel01-am5"
    expect(JSON.parse(JSON.generate(graph.to_hash))).to eq expected_json
  end
end

