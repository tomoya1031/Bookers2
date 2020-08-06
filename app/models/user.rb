class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }
         
  has_many :books, dependent: :destroy
  
  attachment :profile_image

  def user_address
    "%s %s %s"%([self.prefecture_name,self.address_city, self.address_street])
  end

  geocoded_by :user_address
  after_validation :geocode

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end
end
