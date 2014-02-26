require 'rspec'
require_relative '../lib/graphite-dashboard-api'
require 'json'

describe GraphiteDashboardApi::Graph do

  let(:graph_with_title) do
    graph = GraphiteDashboardApi::Graph.new 'title' do
      from '-5minutes'
      until_ 'now'
      targets ['storage.rsyslog.action1.processed.kestrel01-am5']
    end
    expected_json = JSON.parse('{"until": "now","from": "-5minutes","target": ["storage.rsyslog.action1.processed.kestrel01-am5"],"title": "title"}')
    [graph, expected_json]
  end

  let(:graph_without_title) do
    graph = GraphiteDashboardApi::Graph.new do
      from '-5minutes'
      until_ 'now'
      targets ['storage.rsyslog.action1.processed.kestrel01-am5']
    end
    expected_json = JSON.parse('{"until": "now","from": "-5minutes","target": ["storage.rsyslog.action1.processed.kestrel01-am5"]}')
    [graph, expected_json]
  end

  it 'can be constructed' do
    graph = GraphiteDashboardApi::Graph.new('Test graph') do
      from '-4hours'
      until_ '-2hours'
    end

    expect(graph.from).to eq('-4hours')
    expect(graph.until).to eq('-2hours')
  end

  it 'can be converted to json' do
    graph, expected_json = graph_with_title
    expect(JSON.parse(JSON.generate(graph.to_hash))).to eq expected_json
    # also check idempotency of (to_hash o from_hash)
    new_graph = GraphiteDashboardApi::Graph.new
    expect((new_graph.from_hash! graph.to_hash).to_hash).to eq graph.to_hash
  end

  it 'can be converted to json when no title' do
    graph, expected_json = graph_without_title
    expect(graph.target_encode).to eq 'target=storage.rsyslog.action1.processed.kestrel01-am5'
    expect(JSON.parse(JSON.generate(graph.to_hash))).to eq expected_json

    # also check idempotency of (to_hash o from_hash)
    new_graph = GraphiteDashboardApi::Graph.new
    expect((new_graph.from_hash! graph.to_hash).to_hash).to eq graph.to_hash
  end
end
