class PokemonSerializer < ApplicationSerializer
  fields  :id,
          :name,
          :height,
          :weight,
          :types,
          :stats,
          :abilities,
          :image,
          :background
end
