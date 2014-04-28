module Picturelife

  def self.const_missing(name)
    Stub.new(underscore(name.to_s))
  end

  class Stub
    
    attr_reader :module_name

    def initialize(module_name)
      @module_name = module_name
    end

    def method_missing(name, args = nil)
      method = [module_name, name].join('/')
      Api.call(method, args)
    end

  end

end
