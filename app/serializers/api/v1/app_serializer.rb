module Api
  module V1
    class AppSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
