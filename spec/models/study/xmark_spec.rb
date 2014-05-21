require 'spec_helper'

describe Study::Xmark do
  it 'должен обладать валидной фабрикой' do
    build(:mark).should be_valid
  end

  describe 'обладает связями с другими моделями:' do
    it 'с предметом' do
      should belong_to(:subject)
    end
    it 'со студентом' do
      should belong_to(:student)
    end
    it 'со пользователем' do
      should belong_to(:user)
    end
  end

end