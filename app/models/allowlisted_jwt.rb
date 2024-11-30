# == Schema Information
#
# Table name: allowlisted_jwts
#
#  id      :integer          not null, primary key
#  jti     :string           not null
#  aud     :string
#  exp     :datetime         not null
#  user_id :uuid             not null
#
# Indexes
#
#  index_allowlisted_jwts_on_jti      (jti) UNIQUE
#  index_allowlisted_jwts_on_user_id  (user_id)
#

class AllowlistedJwt < ApplicationRecord
  belongs_to :user

  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true
end
