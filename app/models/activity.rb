class Activity < ActiveRecord::Base
  # Идентификатор показателя в базе, отвечающего за преподавательскую нагрузку.
  TEACHING_LOAD = 46

  validates_presence_of :activity_group_id, :activity_type_id, :name

  belongs_to :activity_group
  belongs_to :group, class_name: 'ActivityGroup', foreign_key: :activity_group_id

  belongs_to :activity_type

  belongs_to :activity_credit_type

  has_many :achievements

  scope :without_teaching_load, -> { where('activities.id != ?', TEACHING_LOAD) }

  def unique?
    unique
  end

  def fixed_credits?
    ActivityCreditType::FIXED == activity_credit_type_id
  end

  def numeric_credits?
    ActivityCreditType::NUMERIC == activity_credit_type_id
  end

  def flexible_credits?
    ActivityCreditType::FLEXIBLE == activity_credit_type_id
  end

  def dynamic_credits?
    ActivityCreditType::DYNAMIC == activity_credit_type_id
  end
end