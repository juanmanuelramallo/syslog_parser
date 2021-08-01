module SyslogParser
  # Parses a group of syslog entries.
  #
  # @see https://datatracker.ietf.org/doc/html/rfc5424
  #
  # @example Parse a single syslog entry
  #     SyslogParser::Parser.new(message_count: 1, body: syslog_entry).parse
  #
  # @example Parse a group of syslog entries
  #     SyslogParser.new(message_count: 3, body: syslog_entries).parse
  #
  # Passing a message count value is particularly helpful when working with Heroku's LogPlex.
  #
  # @example The message count doesn't match the body
  #     parser = SyslogParser::Parser.new(message_count: 2, body: syslog_entry)
  #     parser.parse
  #     parser.errors[:message_count] #=> "with 1 is inconsistent with body, missing frames to parse."
  class Parser
    attr_reader :message_count, :body, :errors

    FRAME_REGEX = Regexp.new [
      '<(?<priority>\d+)>',
      '(?<syslog_version>\d) ',
      '(?<timestamp>\S+) ',
      '(?<host>\S+) ',
      '(?<app_name>\S+) ',
      '(?<process_name>\S+) ',
      "- (?<message>.+)"
    ].join.freeze

    # @param message_count [Integer] Amount of syslog entries to parse from +body+
    # @param body [String] A string that contains either one or several syslog entries.
    def initialize(message_count:, body:)
      @message_count = message_count
      @body = body
      @errors = {}
    end

    # Executes the parsing algorithm against the +body+.
    #
    # @return Array<Hash<String, String>>
    def parse
      body_index = 0
      parsed_logs = message_count.times.map do |index|
        # Overflow error
        if body_index >= body.size
          errors[:message_count] = "with #{message_count} is inconsistent with body, overflowed body."
          return []
        end

        # Get frame size
        frame = /\A(\d)+/.match(body[body_index..])[0].to_i

        # Discard frame information and whitespace
        body_index += frame.to_s.size + 1

        # Get current frame
        current_frame = body[body_index..(body_index + frame)]

        # Advance pointer to the next frame
        body_index += frame

        FRAME_REGEX.match(current_frame).named_captures
      end

      # Missing frames to parse
      if body_index != body.size
        errors[:message_count] = "with #{message_count} is inconsistent with body, missing frames to parse."
        return []
      end

      parsed_logs
    end
  end
end
