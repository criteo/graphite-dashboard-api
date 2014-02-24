require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

describe GraphiteDashboardApi::Graph do

  it 'can be constructed' do
    graph = GraphiteDashboardApi::Graph.new 'Test graph'
    graph.from = "-4hours"
    graph.until = "-2hours"
    expect(graph).to be_a_kind_of(GraphiteDashboardApi::Graph)
    expect(graph.until).to eq("-2hours")
  end

  it 'can be converted to json' do
    expected_json = JSON.parse('{"until": "now","from": "-5minutes","target": ["storage.rsyslog.action1.processed.kestrel01-am5"],"title": "title"}')
    graph = GraphiteDashboardApi::Graph.new "title"
    graph.from = "-5minutes"
    graph.until = "now"
    graph.targets << 'storage.rsyslog.action1.processed.kestrel01-am5'
    expect(graph.target_encode).to eq "target=storage.rsyslog.action1.processed.kestrel01-am5"
    expect(JSON.parse(JSON.generate(graph.to_hash))).to eq expected_json
  end

  it 'can be converted to json when no title' do
    expected_json = JSON.parse('{"until": "now","from": "-5minutes","target": ["storage.rsyslog.action1.processed.kestrel01-am5"]}')
    graph = GraphiteDashboardApi::Graph.new nil
    graph.from = "-5minutes"
    graph.until = "now"
    graph.targets << 'storage.rsyslog.action1.processed.kestrel01-am5'
    expect(graph.target_encode).to eq "target=storage.rsyslog.action1.processed.kestrel01-am5"
    expect(JSON.parse(JSON.generate(graph.to_hash))).to eq expected_json
  end
end

