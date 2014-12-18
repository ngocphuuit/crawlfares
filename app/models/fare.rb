class Fare < ActiveRecord::Base
	serialize :detail
	serialize :search
end
