# Performance (load/stess) tests for Wom Backend 
# Using Ruby - Jmeter
#

require 'rubygems'
require 'ruby-jmeter'

@is_local = ARGV[0]=="-l"
def base_url
  aws_path = 'http://wom-backend-master-env-hv2gxttyvi.elasticbeanstalk.com/'
  local_path = 'http://localhost:3000/'
  api_path = 'api/v0/'
  @is_local?(local_path + api_path): (aws_path + api_path)
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

