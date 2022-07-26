require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  let(:user) {
    create(:user, :with_team)
  }
  let(:project) {
    create(:project, team: user.team)
  }
  let!(:project_user) {
    ProjectUser.create(project_id: project.id, user_id: user.id)
  }

  describe '.destroy' do
    subject { project_user.destroy }
    context 'when it is the last record for the project' do
      it 'cannot be deleted' do
        expect {
          subject
        }.to raise_error(ProjectUser::LastRecordError, "You cannot delete the last project user")
      end
    end

    context 'when it is not the last record for the project' do
      before do
        another_user = create(:user, team: user.team)
        project.project_users.create(user_id: another_user.id)
      end
      it 'can be deleted' do
        expect { subject }.to change { project.project_users.count }.by(-1)
      end
    end
  end
end
