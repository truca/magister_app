class Course < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :homeworks
  has_many :trees
  #accepts_nested_attributes_for :trees, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
