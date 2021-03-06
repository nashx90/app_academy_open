class Comment < ApplicationRecord
  extend FriendlyId
  include Votable
  validates :content, :author, :post, presence: true

  belongs_to :parent_comment, class_name: "Comment", foreign_key: :parent_comment_id, optional: true
  belongs_to :author, class_name: "User", foreign_key: :author_id
  belongs_to :post
  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id
  friendly_id :content, use: :slugged
end
