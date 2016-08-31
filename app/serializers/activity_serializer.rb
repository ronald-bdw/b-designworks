class ActivitySerializer < ApplicationSerializer
  attributes :id, :started_at, :finished_at, :steps_count
end
