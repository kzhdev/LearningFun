import React from 'react';
import {withStyles} from "material-ui/styles/index";
import PropTypes from "prop-types";
import classNames from 'classnames';
import Banner from './banner';
import Toolbar from "./toolbar";
import WAVEInterface from "react-audio-recorder/dist/waveInterface";
import VolumUpIcon from 'material-ui-icons/VolumeUp';
import Button from 'material-ui/Button';

const intBus = (app) => {
  if (window.bus) {
    window.bus.on('wksMsg', (type, value) => {
      if (type === 'showBanner') {
        app.setState({
          isCorrect: value,
          show_banner: true,
        });
      }
    });
  } else {
    setTimeout(()=> {
      intBus(app);
    }, 1);
  }
};

const styles = theme => ({
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
  },
  fab: {
    position: 'absolute',
    right: theme.spacing.unit * 2,
    top: '70px',
    zIndex: 2,
  }
});

class Workspace extends React.Component {

  state = {
    show_banner: false,
    isCorrect: false,
    question: null,
  };

  componentDidMount = () => {
    intBus(this);
  };

  componentWillReceiveProps = (props) => {
    if (props.question !== this.props.question) {
      this.setState({question: props.question});
      if (window.bus && props.question) {
        if (props.question.sentence) {
          window.bus.fire('setSentence', props.question.sentence);
        } else {
          window.bus.fire('clearWorkspace');
        }

        if (props.question.audio) {
          this.playAudio(props.question.audio);
        }
      }
    }
  };

  playAudio = (audio) => {
    setTimeout(() => {
      const reader = new FileReader();
      reader.readAsArrayBuffer(audio);
      reader.onloadend = () => {
        WAVEInterface.audioContext.decodeAudioData(reader.result, (buffer) => {
          const source = WAVEInterface.audioContext.createBufferSource();
          source.buffer = buffer;
          source.connect(WAVEInterface.audioContext.destination);
          source.loop = false;
          source.start(0);
        });
      };
    }, 10);
  };

  handleBannerClose = () => {
    this.setState({ show_banner: false });
    if (this.state.isCorrect) {
      this.props.next();
    }
  };

  render() {
    const { classes, showtoolbar } = this.props;

    return (
      <div className={classes.root}>
        {showtoolbar &&
          <Toolbar
            question={this.state.question}
            onClose={this.props.closeToolbar}
            onSave={this.props.saveQuestion}
            getQuestion={() => {return this.state.question}}
          />
        }
        {!showtoolbar && this.state.question && this.state.question.audio &&
          <Button variant="fab" className={classes.fab}
                  onClick={() => {this.playAudio(this.state.question.audio)}}
          >
            <VolumUpIcon/>
          </Button>
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