# Performance (load/stess) tests for Wom Backend 
# Using Ruby - Jmeter
#

 require 'rubygems'
require 'ruby-jmeter'

def base_url
  #aws_path = 'http://wom-backend-master-env-hv2gxttyvi.elasticbeanstalk.com/'
  path_aws_p = 'http://wom.freelogue.net/'
  path_aws_d = 'http://wom-dev.freelogue.net/'
  path_local = 'http://localhost:3000/'
  api_path = 'api/v0/'
  if ARGV[0] == "-l"
  path_local + api_path
  elsif ARGV[0] == "-p"
  path_aws_p + api_path
  else
  path_aws_d + api_path
  end
end

def api_path(path)
  base_url+path
end


test do
  threads count: 1 do
    header [
      { name: 'Content-Type', value: 'application/json' }
          ]

      user = { :user => {:email => "me@me.com", :password => "password" } }

      post name: 'Sign in',
        url: api_path('sign_in'),
        raw_body: user.to_json do
        with_xhr
      end
  end
end.run(
  log: './results/jmeter.log',
  jtl: './results/jmeter.jtl')

