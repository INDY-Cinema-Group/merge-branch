class MergeBrachService
  attr_reader :inputs, :event

  TYPE_LABELED = "labeled".freeze
  TYPE_NOW = "now".freeze

  def self.validate_inputs!(target_branches:, type:, label_name:)
    raise "Error: Invalid type" unless [TYPE_LABELED, TYPE_NOW].include?(type)
    raise "Error: No target branches" unless target_branches.is_a?(Array) && !target_branches.empty?
    if type == TYPE_LABELED
      raise " Error: Empty target label name" unless label_name
    end
  end

  def initialize(inputs, github_event)
    @inputs = inputs
    @event = github_event
  end

  def valid?
    case inputs[:type]
    when TYPE_LABELED
      labeled_valid?
    when TYPE_NOW
      true
    end
  end

  def labeled_valid?
    @event&.dig('action') == TYPE_LABELED &&
    @event&.dig('label', 'name') == inputs[:label_name]
  end
end
