class Book < ApplicationRecord
  # require 'active_support'
  # require 'active_support/core_ext'

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  # validates :comment,presence:true

  scope :created_today, -> {where(created_at: Time.zone.now.all_day)}
  scope :created_yesterday, -> {where(created_at: 1.day.ago.all_day)}
  scope :created_2_days_ago, -> {where(created_at: 2.day.ago.all_day)}
  scope :created_3_days_ago, -> {where(created_at: 3.day.ago.all_day)}
  scope :created_4_days_ago, -> {where(created_at: 4.day.ago.all_day)}
  scope :created_5_days_ago, -> {where(created_at: 5.day.ago.all_day)}
  scope :created_6_days_ago, -> {where(created_at: 6.day.ago.all_day)}
  # scope :created_this_week, -> {where(created_at: 6.day.ago.beginning_of_day. .Time.zone.now.end_of_day)}　←うまくいってないらしい
  d = Time.zone.now
  scope :created_this_week, -> {where(created_at: d.beginning_of_week(:saturday)..d.end_of_week(:saturday))}
  scope :created_last_week, -> {where(created_at: d.advance(weeks:-1).beginning_of_week(:saturday)..d.advance(weeks:-1).end_of_week(:saturday))}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "%#{word}%")
    else
      @book = Book.all
    end
  end
end
