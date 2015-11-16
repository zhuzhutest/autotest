#require File.dirname(__FILE__) + '/../vendor/gems/environment'
require "soap/rpc/standaloneserver"

begin
  class SoapServer < SOAP::RPC::StandaloneServer
    # Expose our services
    def initialize(*args)
      add_method(self, 'add', 'a', 'b')
      add_method(self, 'div', 'a', 'b')
    end

    # Handler methods
    def add(a, b)
      return a + b
    end
    def div(a, b)
      return a / b
    end
  end
rescue Exception => e
  puts e.message
end
