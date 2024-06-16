require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  
  describe 'validations and associations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:deadline) }
    it { should belong_to(:user) }
  end
  
  describe 'callbacks' do
    let(:task) { build(:task, user: user) }
    
    it 'sets default state before validation on create' do
      task = Task.new
      task.valid?
      expect(task.state).to eq('Backlog')
    end

    it 'schedules reminders after create' do
      expect(SendReminderJob).to receive(:set).with(wait_until: task.deadline - 1.day).and_call_original
      expect(SendReminderJob).to receive(:set).with(wait_until: task.deadline - 1.hour).and_call_original
      task.save
    end
  end
end
