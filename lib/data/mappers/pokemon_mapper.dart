import 'package:flutter/material.dart';
import 'package:pokedex/domain/entities/pokemon.dart';
import 'package:pokedex/domain/entities/pokemon_type.dart';
import 'package:pokeapi_wrapper/pokeapi_wrapper.dart' as api;

class PokemonMapper {
  static Future<List<Pokemon>> toDomain(List<api.Pokemon> pokemonList) async {
    List<Pokemon> pokemonProfileList = [];

    for (var pokemon in pokemonList) {
      var types = await _mapPokemonTypes(pokemon.types);
      pokemonProfileList.add(
        Pokemon(
          id: pokemon.id,
          name: pokemon.name,
          sprite: pokemon.sprites.officialArtWork,
          types: types,
          abilities: _mapPokemonAbilities(pokemon.abilities),
          species: await _mapSpecies(pokemon.species),
          height: pokemon.height,
          weight: pokemon.weight,
        ),
      );
    }
    return pokemonProfileList;
  }
}

Future<String> _mapSpecies(Future<api.Either<Error, api.PokemonSpecies>> species) async {
  String genus = "";

  await species.fold(
    (error) {
      return;
    },
    (value) {
      genus = value.genera[7].genus.replaceAll(' Pokémon', '');
    },
  );
  return genus;
}

List<String> _mapPokemonAbilities(List<api.PokemonAbility> abilities) {
  List<String> pokemonAbilities = [];

  for (var ability in abilities) {
    ability.ability.fold(
      (error) => {
        throw Exception(error),
      },
      (ability) => {
        pokemonAbilities.add(ability.name),
      },
    );
  }
  return pokemonAbilities;
}

Future<List<PokemonType>> _mapPokemonTypes(List<api.PokemonType> types) async {
  List<PokemonType> pokemonTypes = [];

  for (var value in types) {
    await value.type.fold(
      (error) => {
        throw Exception(error),
      },
      (type) => {
        pokemonTypes.add(
          _getPokemonType(type),
        ),
      },
    );
  }

  return pokemonTypes;
}

PokemonType _getPokemonType(api.Type type) {
  return switch (type.name) {
    'normal' => PokemonType.normal,
    'fighting' => PokemonType.fighting,
    'flying' => PokemonType.flying,
    'poison' => PokemonType.poison,
    'ground' => PokemonType.ground,
    'rock' => PokemonType.rock,
    'bug' => PokemonType.bug,
    'ghost' => PokemonType.ghost,
    'steel' => PokemonType.steel,
    'fire' => PokemonType.fire,
    'water' => PokemonType.water,
    'grass' => PokemonType.grass,
    'electric' => PokemonType.electric,
    'psychic' => PokemonType.psychic,
    'ice' => PokemonType.ice,
    'dragon' => PokemonType.dragon,
    'dark' => PokemonType.dark,
    'fairy' => PokemonType.fairy,
    'unknown' => PokemonType.unknown,
    'shadow' => PokemonType.shadow,
    _ => PokemonType.unknown
  };
}
