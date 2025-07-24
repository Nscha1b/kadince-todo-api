class Todo < ApplicationRecord
  PRIORITY_OPTIONS = %w[low medium high]
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true
  validates :priority, inclusion: { in: PRIORITY_OPTIONS }
end
