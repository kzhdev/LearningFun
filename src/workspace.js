import React from 'react';
import {withStyles} from "material-ui/styles/index";
import PropTypes from "prop-types";
import classNames from 'classnames';
import Banner from './banner';
import Toolbar from "./toolbar";

const styles = ({
  root: {
    width: '100%',
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
  },
  toolbar: {
    marginTop: '64px',
    height: '68px',
  },
  playground: {
    width: '100%',
    flex: 1,
    height: `calc(100% - 64px)`
  },
  playgroundMoveDown: {
    height: 'calc(100% - 64px - 68px)'
  }
});

class Workspace extends React.Component {

  state = {
    show_banner: false,
    isCorrect: false,
  };

  componentDidMount = () => {
    setTimeout(()=>{
      window.bus.on('wksMsg', (type, value) => {
        if (type === 'showBanner') {
          this.setState({
            isCorrect: value,
            show_banner: true,
          });
        }
      });
    }, 10);
  };

  handleBannerClose = () => {
    this.setState({ show_banner: false });
    if (this.state.isCorrect) {
      this.props.next();
    }
  };

  render() {
    const { classes, showtoolbar, question } = this.props;

    return (
      <div className={classes.root}>
        {showtoolbar &&
          <Toolbar
            audiodata={question ? question.audio : null}
            onClose={this.props.closeToolbar}
            onSave={this.props.saveQuestion}
          />
        }
        <div id="playground"
             className={classNames(classes.playground, {[classes.playgroundMoveDown]: showtoolbar})}/>
        <Banner
          correct={this.state.isCorrect}
          open={this.state.show_banner}
          onClose={this.handleBannerClose}
        />
      </div>
    );
  }
}

Workspace.propTypes = {
  classes: PropTypes.object.isRequired,
  showtoolbar: PropTypes.bool.isRequired,
  question: PropTypes.object,
  closeToolbar: PropTypes.func.isRequired,
  saveQuestion: PropTypes.func.isRequired,
  next: PropTypes.func,
};

export default withStyles(styles)(Workspace);