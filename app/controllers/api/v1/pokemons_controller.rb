module API
  module V1
    class PokemonsController < BaseController
      before_action :prepare_object, only: %i[show]
      before_action :prepare_collection, only: %i[index]

      def index
        pagy, collection = paginate_array(filtered_collection)
        collection = handle_collection(collection)

        render_resource_collection(collection, pagy:, each_serializer: PokemonSerializer)
      end

      def show
        object = pokemon_details(@object)

        render_resource(object, serializer: PokemonSerializer)
      end

      private

      def prepare_object
        @object = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{params[:id]}")
      end

      def prepare_collection
        @collection = HTTParty.get('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0')&.dig('results')
      end

      def filtered_collection
        GatherPokemonService.call(@collection, filter_params, order_params)
      end

      def handle_collection(collection)
        collection.map do |object|
          pokemon = HTTParty.get(object['url'])

          pokemon_details(pokemon)
        end
      end

      def pokemon_details(pokemon)
        {
          id: pokemon['id'],
          name: pokemon['name'],
          height: pokemon['height'],
          weight: pokemon['weight'],
          types: pokemon['types'].map { |type| type['type']['name'] },
          stats: pokemon['stats'].each_with_object({}) do |stat, memo|
            memo[stat['stat']['name']] = stat['base_stat']
          end
        }
      end
    end
  end
end
