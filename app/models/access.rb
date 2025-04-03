class Access < ApplicationRecord
  belongs_to :bucket
  belongs_to :user

  enum :involvement, %i[ access_only watching everything ].index_by(&:itself)
end
