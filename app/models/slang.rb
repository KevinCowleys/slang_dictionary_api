class Slang < ApplicationRecord
  belongs_to :user, -> { select(:id, :username) }

  validates :word, presence: true, length: { minimum: 2 }
  validates :definition, presence: true, length: { minimum: 10 }

  has_many :votes

  def self.search(pattern)
    if pattern.blank?  # blank? covers both nil and empty string
      where('is_approved = true')
    else
      where('word LIKE ? AND is_approved = true', "%#{pattern}%")
    end
  end

  def upvote_count
    votes.where(upvote: true).count
  end

  def downvote_count
    votes.where(upvote: false).count
  end
end
