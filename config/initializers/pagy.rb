require 'pagy/extras/overflow'
require 'pagy/extras/metadata'
require 'pagy/extras/array'

Pagy::DEFAULT[:limit] = 25
Pagy::DEFAULT[:metadata] = %i[limit count page prev next last]
Pagy::DEFAULT[:overflow] = :empty_page
