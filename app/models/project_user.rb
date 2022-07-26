class ProjectUser < ApplicationRecord
  class LastRecordError < StandardError; end

  belongs_to :project
  belongs_to :user
  before_destroy :check_last_record

  private

  def check_last_record
    raise LastRecordError.new("You cannot delete the last project user") if last_record?
  end

  def last_record?
    project.project_users.count === 1
  end
end
