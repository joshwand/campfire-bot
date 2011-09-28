module AbsenteeCamper
  class Logger
    include Singleton
    extend Forwardable

    attr_accessor :log
    def_delegators :log, :debug, :info, :warn, :error, :fatal
  end
end
