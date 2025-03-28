class Activity < ApplicationRecord
  enum :kind, {
    diaper: "diaper",
    nursing: "nursing",
    formula: "formula",
    expressed: "expressed",
    sleep: "sleep",
    growth: "growth",
    temperature: "temperature",
    medication: "medication",
    milestone: "milestone",
    other: "other"
  }

  enum :category, {
    routine: "routine",
    event: "event"
  }

  validates :kind, :category, presence: true

  validate :validate_data_structure

  def validate_data_structure
    expected_keys = DATA_FIELDS_BY_KIND[kind] || []
    return if data.blank?

    extra_keys = data.keys - expected_keys
    unknown_keys = expected_keys.empty? && data.keys.any?

    if unknown_keys
      errors.add(:data, "não há estrutura esperada para o tipo '#{kind}'")
    elsif extra_keys.any?
      errors.add(:data, "tem campos não esperados: #{extra_keys.join(', ')}")
    end
  end

  def self.build_data(kind, raw_data)
    allowed = DATA_FIELDS_BY_KIND[kind] || []
    return {} if raw_data.blank?

    raw_data.slice(*allowed)
  end

  DATA_FIELDS_BY_KIND = {
    "diaper" => %w[Status],
    "formula" => ["Amount (ml)", "Method"],
    "expressed" => ["Amount (ml)", "Left", "Right", "Duration"],
    "nursing" => ["Left", "Right", "Duration"],
    "temperature" => ["Temperature (C)"],
    "growth" => ["Height (cm)", "Weight (kg)"],
    "milestone" => ["Milestone"],
    "medication" => ["Medication", "Amount", "Description", "Unit"],
    "sleep" => ["Duration"],
    "other" => ["Activity"]
  }.freeze
end
