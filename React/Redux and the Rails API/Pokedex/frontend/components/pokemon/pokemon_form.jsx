import React from "react";

class PokemonForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: "",
      image_url: "",
      poke_type: "",
      attack: "",
      defense: "",
      move_1: "",
      move_2: ""
    };
    this.update = this.update.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  update(property) {
    return e => {
      e.preventDefault();
      this.setState({
        [property]:
          e.target.type === "number" ? parseInt(e.target.value) : e.target.value
      });
    };
  }

  handleSubmit(e) {
    e.preventDefault();
    e.stopPropagation();
    const moves = [this.state.move_1, this.state.move_2];
    const partial_data = (({
      name,
      image_url,
      poke_type,
      attack,
      defense
    }) => ({
      name,
      image_url,
      poke_type,
      attack,
      defense
    }))(this.state);
    const poke_data = { pokemon: Object.assign(partial_data, { moves }) };
    this.props.createPokemon(poke_data);
  }

  render() {
    const pokemonTypes = [
      "fire",
      "electric",
      "normal",
      "ghost",
      "psychic",
      "water",
      "bug",
      "dragon",
      "grass",
      "fighting",
      "ice",
      "flying",
      "poison",
      "ground",
      "rock",
      "steel"
    ].sort();

    return (
      <form className="pokemon-form" onSubmit={this.handleSubmit}>
        <input
          type="text"
          placeholder="Pokemon Name"
          onChange={this.update("name")}
          value={this.state.name}
        ></input>
        <input
          type="text"
          placeholder="Image URL"
          onChange={this.update("image_url")}
          value={this.state.image_url}
        ></input>
        <select
          onChange={this.update("poke_type")}
          value={
            this.state.poke_type ? this.state.poke_type : "Select Pokemon Type"
          }
        >
          <option
            disabled={true}
            // selected={this.state.poke_type ? false : true}
          >
            Select Pokemon Type
          </option>
          {pokemonTypes.map(type => {
            return (
              <option
                key={type}
                // selected={this.state.poke_type === type ? true : false}
              >
                {type}
              </option>
            );
          })}
        </select>
        <input
          type="number"
          placeholder="Attack"
          onChange={this.update("attack")}
          value={this.state.attack}
        ></input>
        <input
          type="number"
          placeholder="Defense"
          onChange={this.update("defense")}
          value={this.state.defense}
        ></input>
        <input
          type="text"
          placeholder="Move 1"
          onChange={this.update("move_1")}
          value={this.state.move_1}
        ></input>
        <input
          type="text"
          placeholder="Move 2"
          onChange={this.update("move_2")}
          value={this.state.move_2}
        ></input>
        <button type="submit">Add Pokemon!</button>
      </form>
    );
  }
}

export default PokemonForm;
