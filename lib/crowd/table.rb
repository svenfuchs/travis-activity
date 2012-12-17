class Crowd
  class Table
    ROW_COUNTS = {
      month: 12,
      week: 52,
      day: 365
    }

    attr_reader :packages, :interval

    def initialize(options = {})
      @packages = options[:packages] || [:small] # || PACKAGES.keys
      @interval = options[:interval] || :week
    end

    def data
      [header] + rows
    end

    def header
      [interval.to_s] + packages
    end

    def rows
      (1..ROW_COUNTS[interval.to_sym]).to_a.map do |key|
        [key] + stats.map { |data| data[key] || 0 }
      end
    end

    def stats
      @stats ||= packages.map do |repo|
        Record.new(repo, interval).data
      end
    end
  end
end

