class V2::Test
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :steps
end
