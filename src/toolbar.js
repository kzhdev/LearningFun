import React from 'react';
import {withStyles} from "material-ui/styles/index";
import PropTypes from "prop-types";
import Input from 'material-ui/Input';
import { FormControl, FormHelperText } from 'material-ui/Form';
import IconButton from 'material-ui/IconButton';
import SaveIcon from 'material-ui-icons/Save';
import AudioRecorder from 'react-audio-recorder';
import CloseIcon from 'material-ui-icons/Close';
import uuid from './uuid';

const styles = theme => ({
  root: {
    width: '100%',
    height: '68px',
  },
  frame: {
    position: 'relative',
    width: '100%',
    height: '100%',
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: '5px',
    paddingLeft: '10px',
    paddingRight: '10px',
  },
  sentence_input: {
    flex: '1 1 auto'
  },
  button: {
    margin: 'auto',
  },
  recorder: {
    display: 'none',
  }
});

class Toolbar extends React.Component {
  state = {
    id: uuid(),
    sentence: '',
    audio: null,
  };

  componentDidMount = () => {
    window.bus.fire("resize");
    // var question = this.props.getQuestion();
    // this.setState({question: question});
  };

  componentWillReceiveProps = (props) => {
    if (props.question !== this.props.question) {
      this.setState({
        id: props.question ? props.question.id : uuid(),
        sentence: props.question ? props.question.sentence : '',
        audio: props.question ? props.question.audio : null,
      });
    }
  };


  handleSentenceChange = event => {
    this.setState({ sentence: event.target.value} );
    window.bus.fire("setSentence", event.target.value);
  };

  handleRecordComplet = (event) => {
    this.setState({audio: event.audioData});
  };

  render() {
    const { classes } = this.props;

    return (
      <div className={classes.root}>
        <div className={classes.frame}>
          <FormControl className={classes.sentence_input}>
            <Input id="sentence" value={this.state.sentence} onChange={this.handleSentenceChange} />
            <FormHelperText id="sentence-text">请输入句子。括号中的词，在难度简单的练习中不会被拆开。</FormHelperText>
          </FormControl>
          <AudioRecorder
            className={classes.recorder}
            downloadable={false}
            playLabel="▶ 播放"
            recordLabel="● 录音"
            removeLabel="✖ 删除"
            onChange={this.handleRecordComplet}
            initialAudio={this.state.audio}
          />
          <IconButton className={classes.button} aria-label="save"
                      onClick={ () => {this.props.onSave({
                        id: this.state.id,
                        sentence: this.state.sentence,
                        audio: this.state.audio
                      })}}
          >
            <SaveIcon/>
          </IconButton>
          <IconButton className={classes.button} aria-label="close" onClick={this.props.onClose}>
            <CloseIcon/>
          </IconButton>
        </div>
      </div>
    );
  };
}

Toolbar.propTypes = {
  classes: PropTypes.object.isRequired,
  question: PropTypes.object,
  onClose: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  getQuestion: PropTypes.func,
};

export default withStyles(styles, {withTheme: true})(Toolbar);