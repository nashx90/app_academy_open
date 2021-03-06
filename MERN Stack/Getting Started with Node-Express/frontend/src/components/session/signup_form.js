import React from "react";
import { withRouter } from "react-router-dom";

class SignupForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      email: "",
      handle: "",
      password: "",
      password2: "",
      errors: {},
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.clearedErrors = false;
  }

  componentDidUpdate(prevProps, prevState) {
    if (this.props.signedIn === true) {
      this.props.history.push("/login");
    }
    // Set or clear errors
    if (prevState.errors !== this.props.errors) {
      this.setState({ errors: this.props.errors });
    }
  }

  update(field) {
    return e => this.setState({ [field]: e.currentTarget.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    const { email, handle, password, password2 } = this.state;
    let user = {
      email,
      handle,
      password,
      password2,
    };

    this.props.signup(user, this.props.history);
  }

  renderErrors() {
    return (
      <ul>
        {Object.keys(this.state.errors).map((error, i) => (
          <li key={`error-${i}`}>{this.state.errors[error]}</li>
        ))}
      </ul>
    );
  }

  render() {
    const { email, handle, password2, password } = this.state;
    return (
      <div className="signup-form-container">
        <form onSubmit={this.handleSubmit}>
          <div className="signup-form">
            <br />
            <input
              type="text"
              value={email}
              onChange={this.update("email")}
              placeholder="Email"
            />
            <br />
            <input
              type="text"
              value={handle}
              onChange={this.update("handle")}
              placeholder="Handle"
            />
            <br />
            <input
              type="password"
              value={password}
              onChange={this.update("password")}
              placeholder="Password"
            />
            <br />
            <input
              type="password"
              value={password2}
              onChange={this.update("password2")}
              placeholder="Confirm Password"
            />
            <br />
            <input type="submit" value="Submit" />
            {this.renderErrors()}
          </div>
        </form>
      </div>
    );
  }
}

export default withRouter(SignupForm);
