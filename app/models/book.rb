class Book < ActiveRecord::Base
	has_many :book_genres
	has_many :genres, through: :book_genres

	has_many :reads
	has_many :users, through: :reads

	# scope :finished, ->{ where('finished_on not null')}
	scope :finished, ->{ where.not(finished_on: nil)}
	scope :recent, ->{ where('finished_on > ?', 2.days.ago)}
	scope :search, ->(keyword){ where('keywords like ?', "%#{keyword.downcase}%") if keyword.present?}
	# scope :filter, ->(genre_id){ where(joins(:book_genres).where('book_genres.genre_id = ?' , genre_id))}

	scope :filter, ->(name){
   		joins(:genres).where('genres.name = ?', name) if name.present?
 	}

	before_save :set_keywords
	# def self.search(keyword)
	# 	if keyword.present?
	# 		where(title: keyword)
	# 	else 
	# 		all
	# 	end
	# end
	def finished?
		finished_on.present?
	end

	protected
		def set_keywords
			self.keywords = [title, author, description].map { |p| p.downcase}.join(' ')
			# .(&:downcase)
		end
end
