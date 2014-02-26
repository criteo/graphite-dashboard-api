Graphite Dashboard API
----------------------

[![Build Status](https://travis-ci.org/criteo/graphite-dashboard-api.png?branch=master)](https://travis-ci.org/criteo/graphite-dashboard-api)
[![Gem Version](https://badge.fury.io/rb/graphite-dashboard-api.png)](http://badge.fury.io/rb/graphite-dashboard-api)
[![Dependency Status](https://gemnasium.com/criteo/graphite-dashboard-api.png)](https://gemnasium.com/criteo/graphite-dashboard-api)


Graphite dashboard api is a ruby gem which help to create and update graphite dashboards.

It allows to create dashboard with code instead of long manipulations in graphite dashboard UI.

How to
------

Simple example:
```ruby
my_graphs = %w(preprod prod).map do |env|
  GraphiteDashboardApi::Graph.new "chef-client run time" do
    targets [
      "alias(averageSeries(storage.#{env}.chef.*.elapsed_time),\"average run time\")",
      "alias(maxSeries(storage.#{env}.chef.*.elapsed_time),\"max run time\")"
      ]
    end
  end

dashboard = GraphiteDashboardApi::Dashboard.new 'chef-run-time' do
  graphs my_graphs
end

dashboard.save!('http://mygraphite.server.com')
```

For more complex examples, see `spec/` folder
