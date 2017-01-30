---
author: Hugo Fabre <hfabre@synbioz.com>
title: Gosu et le tile mapping
categories:
  - dev
tags:
  - jeu
  - fr
description: Un article pour présenter la gestion du tile mapping en Ruby grâce à Gosu
preview_size: 2
related: [[nil, 'introduction_a_motiongame'],[nil, 'motiongame-les-sprites']]
publish_on: 2017-01-31
---

# Introduction au _tile mapping_ avec Gosu

### Gosu

[Gosu](https://www.libgosu.org/) est une bibliothèque pour le développement de jeu vidéo 2D.

Elle peut être utilisée en C++ ou en Ruby.
Comme on peut le lire sur le site officiel, c'est un bibliothèque accès sur la simplicité, elle est par example utilisé pour apprendre ou enseigner ruby, pour prototyper des jeux, ou encore lors de competitions de développement de jeux vidéo.

Ce qui est agréable dans l'utilisation de Gosu, c'est qu'elle est très légère, mais embarque toutes les fonctionnalités importantes pour un jeu en _tile mapping_, notamment :

* La gestion des _inputs_ (clavier, souris, ou gamepad)
* Le chargement très simple d'images (simple, spritesheet, ou bien tileset)
* Une boucle principale qui nous permet de mettre à jour nos objets et de les afficher.

*Attention, pour installer Gosu, il faut quelques dépendances natives, je vous invite à vous rendre sur le [wiki](https://github.com/gosu/gosu/wiki) pour avoir plus d'informations*

### Tile Mapping

Le principe du _tile mapping_ est de découper sa fenêtre de jeu en petites cases de taille prédéfinie (en général, aux alentours de 16×16 pixels) et d'y apposer une tuile (_tile_) qui est en fait une image de la taille de notre case (![Tile](http://www.synbioz.com/images/articles/20170125/tile.png "Tile")).

La première apparition du _tile mapping_ est dans le jeu [namco galaxian](https://en.wikipedia.org/wiki/Galaxian) en 1979. Mais c'est une technique qui s'est très répendu par la suite grâce à l'optimisation qu'elle peut apporter sur l'utilisation de la mémoire. On la retrouve nottament dans deux franchises très connues:

![Pokemon](http://www.synbioz.com/images/articles/20170125/pokemon.png "Pokemon")
![Mario](http://www.synbioz.com/images/articles/20170125/mario.png "Mario")

Lorsque l'on fait attention, on remarque très facilement le découpage en cases.

C'est une technique que j'apprecie car elle est très simple à mettre en oeuvre et permet de faire beaucoup de choses.

## Ouvrir une fenêtre

Voilà le code du [tutoriel](https://github.com/gosu/gosu/wiki/Ruby-Tutorial) permettant d'ouvrir une fenêtre.

~~~ruby
# game_window.rb
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Tutorial Game"
  end

  def update
    # ...
  end

  def draw
    # ...
  end
end

GameWindow.new.show
~~~

On note la présence des méthodes `update` et `draw` qui seront appelées à chaque tour de la boucle principale.
Avec ce bout de code, vous devriez avoir une fenêtre simple qui s'ouvre `ruby game_window.rb` :

![Empty window](http://www.synbioz.com/images/articles/20170125/empty_window.png "Empty window")

## Passons aux choses sérieuses

Pour la suite de l'article, je vous propose d'utiliser ces deux images (libre à vous d'en prendre d'autres, il faudra simplement être vigilant quant à leurs tailles) :

* [Sprite sheet](http://www.synbioz.com/images/articles/20170125/sprite.png "Sprite sheet")

* [Tile set](http://www.synbioz.com/images/articles/20170125/tilesetpkm.png "Tile set")

Si vous ouvrez les deux images, vous remarquerez qu'elles sont un peu spéciales. En effet elles embarquent tout ce qu'il nous faut (animations, et différentes "textures"). C'est une technique d'optimisation très courante dans ce genre de jeu.

De plus, c'est facilement utilisable grâce à Gosu qui nous fournit un [outil](http://www.rubydoc.info/github/jlnr/gosu/Gosu/Image.load_tiles) pour les découper comme il faut, il suffit de connaitre la taille de chaque tuile (ici: 16×16 pixels).

Commençons par définir notre personnage et lui attribuer ses images :

~~~ruby
# character.rb
class Character
  SPRITE_SIZE = 16
  ZORDER = 2

  # window est notre classe principale qui hérite de Gosu::Window
  # sprite_path est le chemin vers la sprite sheet
  def initialize(window, sprite_path)
    @sprite = load_sprite_from_image(window, sprite_path)
    @facing = :down
  end

  def update

  end

  def draw
    # Le ZOrder est une technique pour gérer les priorités d'affichage en 2D
    # (qui s'affiche par dessus qui).
    # On accède à notre hash de direction puis, pour le moment,
    # à la frame 0 de l'animation.
    @sprite[@facing][0].draw(x, y, ZORDER)
  end

  private

  def load_sprite_from_image(window, sprite_path)

    sprites = Gosu::Image.load_tiles(window, sprite_path, SPRITE_SIZE, SPRITE_SIZE, false)
    # Avec cet appel, Gosu nous renvoie un tableau d'images
    # découpées en SPRITE_SIZE * SPRITE_SIZE pixels.
    # Les images sont accessibles dans l'ordre ci-dessous:
    #
    # 0 | 1 | 2 | 3
    # --------------
    # 4 | 5 | 6 | 7
    # ...

    {left: sprites[4..7], right: sprites[12..15],
      down: sprites[0..3], up: sprites[8..11]}
    # Un simple hash avec pour clé l'orientation du personnage
    # et pour valeur, un tableau d'images avec les différentes frames
    # qui nous serviront à animer le personnage.
  end
end
~~~

Et donc dans notre `GameWindow`:

~~~ruby
# game_window.rb
require 'gosu'

require_relative './character'

class GameWindow < Gosu::Window

  ESC = Gosu::Button::KbEscape

  def initialize
    super 360, 360
    self.caption = "Gosu article"

    @player = Character.new(self, './assets/sprite.png')
  end

  def update
    # Un simple raccourci sur la touche ECHAP pour quitter le jeu
    self.close if button_down? ESC
    @player.update
  end

  def draw
    @player.draw(50, 50)
  end
end

GameWindow.new.show
~~~

Vous devriez avoir maintenant une fenêtre qui s'ouvre, avec le personnage à la position x: 50, y: 50.

![Character](http://www.synbioz.com/images/articles/20170125/character.png "Character")

On remarque d'ailleurs la gestion un peu particulière de Gosu au niveau des axes :

~~~
0 ----------------> +x
|
|
|
|
|
V
+y
~~~

## Un peu d'animation

Nous allons maintenant voir comment animer notre personnage grâce aux images chargées depuis la sprite sheet.

### Gérer les inputs

Pour nous faciliter la vie nous allons rajouter quelques constantes à `GameWindow`

~~~ruby
# game_window.rb
class GameWindow < Gosu::Window

  LEFT = Gosu::Button::KbLeft
  UP = Gosu::Button::KbUp
  DOWN = Gosu::Button::KbDown
  RIGHT = Gosu::Button::KbRight

  ...
~~~

Il nous faut ensuite sélectionner la direction dans laquelle le joueur souhaite aller :

~~~ruby
# game_window.rb
class GameWindow < Gosu::Window

...

  def update
    self.close if button_down? ESC
    direction = ''
    direction = :left if button_down? LEFT
    direction = :right if button_down? RIGHT
    direction = :up if button_down? UP
    direction = :down if button_down? DOWN
    @player.update(direction)
  end

...

end
~~~

On retourne ensuite à notre classe `Character` pour modifier légèrement la méthode `update`.
Nous allons avoir besoin d'une variable qui permet de savoir à quelle _frame_ nous en sommes dans l'animation, et d'une méthode pour définir si nous avons fini de jouer l'animation.
Nous pourrons ensuite incrémenter cette variable dans le `update` pour passer de _frame_ en _frame_ :

~~~ruby
# character.rb
class Character

  ...

  ANIMATION_NB = 4

  def initialize(...)
    ...
    @image_count = 0
  end

  def update(direction)
    unless direction.empty?
      @facing = direction
      @image_count += 1
      @image_count = 0 if done?
    end
  end

  def done?
    @image_count == ANIMATION_NB
  end

...

end
~~~

### Gérer la vitesse

Vous devriez avoir un personnage qui s'anime, mais très (trop) vite. Pour l'animer à une vitesse plus correcte, il faut définir le temps que l'on donne à une _frame_ pour s'exécuter.
Une fois que l'on a ce temps, il suffit de faire une méthode qui vérifie que le temps accordé à la _frame_ est bien écoulé avant de passer à la suivante.
Ouvrons de nouveau notre classe `Character` pour rajouter ça :

~~~ruby
# character.rb
class Character
  ...

  FRAME_DELAY = 60 # ms

  def frame_expired?
    # On récupère le nombre de millisecondes écoulées
    # depuis le lancement du programme
    now = Gosu.milliseconds

    @last_frame ||= now

    # On vérifie que le temps FRAME_DELAY n'est pas écoulé
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    else
      false
    end
  end

  ...
end
~~~

Et voilà nous avons un personnage qui bouge !

## La map

C'est pas mal, mais il nous faut une _map_ sur laquelle se déplacer maintenant. Cette _map_ devra contenir les fameuses tuiles :

~~~ruby
class Tile
# tile.rb
  attr_reader :position

  def initialize(tileset, tile_pos, collidable: false)
    @image = tileset[tile_pos]
    @position = tile_pos
    @collidable = collidable
  end

  def collidable?
    @collidable
  end
end
~~~

La _map_ :

~~~ruby
# map.rb
class Map

  TILE_SIZE = 16

  # La position des tuiles que l'on va utiliser dans la tileset
  WALL_POS = 18
  FLOOR_POS = 13

  HEIGHT = 360
  WIDTH = 360
  NUMBER_OF_LINE = HEIGHT / TILE_SIZE

  ZORDER = 1

  def initialize(window, tiles_path)
    @tileset = Gosu::Image.load_tiles(window, tiles_path, TILE_SIZE, TILE_SIZE, false)
    @board = generate_board
  end

  def draw

    # On parcourt le tableau case par case pour afficher les tuiles
    @board.each_with_index do |line, height|
      line.each_with_index do |tile, width|

        # On pense à multiplier par `TILE_SIZE` pour ne pas afficher
        # toutes les cases les unes sur les autres.
        @tileset[tile.position].draw(height * TILE_SIZE, width * TILE_SIZE, ZORDER)
      end
    end
  end

  private

  # On génère la carte avec des murs sur les côtés
  def generate_board
    board = Array.new(NUMBER_OF_LINE, [])

    board[0] = Array.new(NUMBER_OF_LINE, Tile.new(@tileset, WALL_POS, collidable: true))
    (NUMBER_OF_LINE - 2).times do |i|
      line = []
      line << Tile.new(@tileset, WALL_POS, collidable: true)
      (NUMBER_OF_LINE - 2).times do
        line << Tile.new(@tileset, FLOOR_POS, collidable: false)
      end
      line << Tile.new(@tileset, WALL_POS, collidable: true)
      board[i + 1] = line
    end
    board[NUMBER_OF_LINE - 1] = Array.new(NUMBER_OF_LINE, Tile.new(@tileset, WALL_POS, collidable: true))
    board
  end
end
~~~

Une petite modification côté `GameWindow` s'impose pour afficher la _map_.

~~~ruby
# game_window.rb
...

require_relative './map.rb'
require_relative './tile.rb'

class GameWindow < Gosu::Window

  ...

  def initialize

    ...

    @map = Map.new(self, './assets/tilesetpkm.png')
  end

  def draw
    ...

    @map.draw
  end
  ...
end
~~~

Voilà le résultat : ![map](http://www.synbioz.com/images/articles/20170125/map.png "map")

## Les déplacements

Pour faire simple, nous déplacerons uniquement le personnage en faisant attention de ne pas marcher sur des tuiles avec lesquelles nous sommes censés entrer en collision (ce que vérifiera la méthode `collidable?`).
Sur un vrai _tile mapping_, le personnage resterait au centre de l'écran et nous déplacerions uniquement notre vue.

Bref, pour faire avancer notre personnage nous allons définir une vitesse de défilement et rajouter deux variables pour gérer la position :

~~~ruby
# character.rb
class Character

  ...

  SPEED = 1.5

  def initialize(...)

    ...
    # On définit la position du joueur par défaut
    @x = @y = Map::HEIGHT / 2
  end

  # On passe la map en paramètre de notre méthode `update`
  # pour pouvoir vérifier que l'on peut marcher sur la case suivante.
  def update(direction, map)
    unless direction.empty?
      case direction
        when :left
          @x -= SPEED unless map.blocked?(@y, @x - SPEED)
        when :right
          # Ici on rajoute SPRITE_SIZE,
          # pour tenir compte du sprite entier (largeur et hauteur),
          # et pas seulement de son origine.
          @x += SPEED unless map.blocked?(@y, @x + SPEED + SPRITE_SIZE)
        when :up
          @y -= SPEED unless map.blocked?(@y - SPEED, @x)
        when :down
          @y += SPEED unless map.blocked?(@y + SPEED + SPRITE_SIZE, @x)
      end

      ...
    end
  end
end
~~~

Comme vous l'avez vu nous utilisons une méthode `blocked?` dans `Map` qui n'existe pas encore. L'objectif de cette méthode est de vérifier que l'on ne va pas tenter de marcher sur une case `collidable?` (Oui, le _boolean_ que l'on passe en troisième paramètre lors de la création d'un `Tile`).

~~~ruby
# map.rb
class Map
  ...

  def blocked?(tile_y, tile_x)
    tile = @board[tile_y / TILE_SIZE][tile_x / TILE_SIZE]
    return true unless tile
    tile.collidable?
  end

  ...

end
~~~

## Conclusion

Les outils apportés par Gosu nous facilitent vraiment la tâche sans pour autant embarquer un énorme _framework_. Tout cela en Ruby, et avec des performances plus qu'acceptables. Je vous invite à jouer avec Gosu et n'hésitez pas à faire un tour sur le [forum](https://www.libgosu.org/cgi-bin/mwf/forum_show.pl) ou bien le [subreddit](https://www.reddit.com/r/gosu/). Le développeur de Gosu est vraiment très accessible si vous avez une question ou si vous souhaitez partager une de vos réalisations !

## Aller plus loin

Si vous souhaitez aller plus loin, il y a plein de pistes d'amélioration à l'exemple que j'apporte avec cet article :

* On pourra imaginer charger la _map_ depuis un fichier de configuration (Il existe déjà des formats de fichier pour le _tile mapping_, mais je les trouve assez complexes pour l'utilisation que j'en ai).
* On pourrait gérer le mouvement de la caméra comme suggéré au début de la section déplacement.
* Rajouter un système de scène et de menu

Je vous encourage à vous lancer, Gosu est une bibliothèque très accessible, légère et on peut vraiment faire plein de choses avec.

L’équipe Synbioz.
Libres d’être ensemble.
