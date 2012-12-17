class Stats
  class Table
    ROW_COUNTS = {
      month: 12,
      week: 52,
      day: 365
    }

    attr_reader :repos, :user, :interval

    def initialize(options = {})
      @repos    = options[:repos] || REPOS
      @user     = options[:user]
      @interval = options[:interval] || :week
    end

    def data
      [header] + rows
    end

    def colors
      COLORS.values_at(*repos)
    end

    def header
      [interval.to_s] + repos
    end

    def rows
      (1..ROW_COUNTS[interval.to_sym]).to_a.map do |key|
        [key] + stats.map { |data| data[key] || 0 }
      end
    end

    def stats
      @stats ||= repos.map do |repo|
        Record.new(repo, user, interval).data
      end
    end
  end
end
