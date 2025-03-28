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
end
