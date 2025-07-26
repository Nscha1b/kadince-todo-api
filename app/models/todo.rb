class Todo < ApplicationRecord
  PRIORITY_OPTIONS = %w[low medium high]

  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where completed: false }

  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true
  validates :priority, inclusion: { in: PRIORITY_OPTIONS }
end
