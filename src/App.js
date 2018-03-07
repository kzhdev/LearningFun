import React, { Component } from 'react';
import Reboot from 'material-ui/Reboot';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import classNames from 'classnames';
import Drawer from 'material-ui/Drawer';
import AppBar from 'material-ui/AppBar';
import Toolbar from 'material-ui/Toolbar';
import Typography from 'material-ui/Typography';
import IconButton from 'material-ui/IconButton';
import MenuIcon from 'material-ui-icons/Menu';
import CloseIcon from 'material-ui-icons/Close';
import Divider from 'material-ui/Divider';
import NavMenu from './navMenu';
import Workspace from './workspace';
import uuid from 'uuid';

const drawerWidth = 240;
let visited_questions = [];
let questions = [];

let db;

function loadrecord(onQuestionsLoaded) {
  let open = indexedDB.open("LearningFun", 1);

  open.onupgradeneeded = (event) => {
    event.target.result.createObjectStore("SentenceBuilder", {keyPath: 'id'});
  };

  open.onerror = (event) => {
    console.log("Error creating/accessing IndexedDB database");
  };

  open.onsuccess = (event) => {
    console.log("Success creating/accessing IndexedDB database");
    db = open.result;

    db.onerror = (e) => {
      console.log("Error access IndexedDB database");
    };

    if (db.setVersion) {
      if (db.version !== 1) {
        let setVersion = db.setVersion(1);
        setVersion.onsuccess = () => {
          db.createObjectStore("SentenceBuilder");
        }
      }
    }

    let transaction = db.transaction("SentenceBuilder", "readwrite");
    let objectStore = transaction.objectStore("SentenceBuilder");
    if ('getAll' in objectStore) {
      objectStore.getAll().onsuccess = event => {
        if (onQuestionsLoaded) {
          onQuestionsLoaded(event.target.result);
        }
      }
    } else {
      let questions = [];
      objectStore.openCursor().onsuccess = event => {
        let cursor = event.target.result;
        if (cursor) {
          questions.push(cursor.value);
          cursor.continue();
        } else {
          if (onQuestionsLoaded) {
            onQuestionsLoaded(questions);
          }
        }
      };
    }
  };
}

const styles = theme => ({
  root: {
    width: '100%',
    height: '100%',
    zIndex: 1,
    overflow: 'hidden',
  },
  appFrame: {
    position: 'relative',
    display: 'flex',
    width: '100%',
    height: '100%',
  },
  appBar: {
    position: 'absolute',
    transition: theme.transitions.create(['margin', 'width'], {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
  },
  appBarShift: {
    width: `calc(100% - ${drawerWidth}px)`,
    transition: theme.transitions.create(['margin', 'width'], {
      easing: theme.transitions.easing.easeOut,
      duration: theme.transitions.duration.enteringScreen,
    }),
    marginLeft: drawerWidth,
  },
  menuButton: {
    marginLeft: 12,
    marginRight: 20,
  },
  hide: {
    display: 'none',
  },
  drawerPaper: {
    position: 'relative',
    height: '100%',
    width: drawerWidth,
  },
  drawerHeader: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'flex-end',
    padding: '0 8px',
    ...theme.mixins.toolbar,
  },
  content: {
    width: '100%',
    flexGrow: 1,
    backgroundColor: theme.palette.background.default,
    transition: theme.transitions.create('margin', {
      easing: theme.transitions.easing.sharp,
      duration: theme.transitions.duration.leavingScreen,
    }),
    height: `calc(100% - 56px)`,
    marginTop: 56,
    marginLeft: -drawerWidth,
    [theme.breakpoints.up('sm')]: {
      height: 'calc(100% - 64px)',
      marginTop: 64,
    },

    contentShift: {
      transition: theme.transitions.create('margin', {
        easing: theme.transitions.easing.easeOut,
        duration: theme.transitions.duration.enteringScreen,
      }),

      marginLeft: drawerWidth,
    },
  },
});

class App extends Component {

  constructor(props) {
    super(props);

    loadrecord((quests) => {
      this.setState({questions: quests});
      this.state.questions = quests;
      questions = [].concat(quests);
      this.next();
    });

    this.state = {
      open: false,
      show_toolbar: false,
      question: null,
      questions: [],
    };
  }

  handleDrawerOpen = () => {
    this.setState({open: true});
  };

  handleDrawerClose = () => {
    this.setState({open: false});
  };

  addSentence = () => {
    this.setState({open: false, show_toolbar: true});
    window.bus.fire('clear-workspace');
  };

  next = () => {
    if (!questions.length) {
      if (visited_questions.length) {
        questions = visited_questions;
        visited_questions = [];
      }
    }

    if (questions.length) {
      let index = Math.floor(Math.random() * questions.length);
      this.setState({question: questions[index]});
      visited_questions.push(questions[index]);
      window.bus.fire('setSentence', questions[index].sentence);
      questions.splice(index, 1);
    }
  };

  saveQuestion = (sentence, audio) => {
    let transaction = db.transaction("SentenceBuilder", "readwrite");
    let objectStore = transaction.objectStore("SentenceBuilder");

    let newQuestion = {
      id: uuid(),
      sentence: sentence,
      audio: audio
    };

    let request = objectStore.put(newQuestion);
    request.onerror = () => {
      console.log("Error save sentence");
    };

    request.onsuccess = () => {
      console.log("Save sentence succeeded");
      questions.push(newQuestion);

      let temp = this.state.questions;
      temp.push(newQuestion);

      this.setState({questions: temp});
    };
  };

  deleteSentence = (id) => {
    let transaction = db.transaction("SentenceBuilder", "readwrite");
    let objectStore = transaction.objectStore("SentenceBuilder");
    let request = objectStore.delete(id);
    request.onerror = () => {
      console.log("Error save sentence");
    };

    request.onsuccess = () => {
      console.log("Delete sentence " + id + " succeeded");

      let index = -1;
      for (let i = 0, len = questions.length; i < len; i++) {
        if (questions[i].id === id) {
          index = i;
          questions.splice(i, 1);
          break;
        }
      }

      if (index === -1) {
        for (let i = 0, len = visited_questions.length; i < len; i++) {
          if (visited_questions[i].id === id) {
            visited_questions.splice(i, 1);
            break;
          }
        }
      }

      let temp = this.state.questions;
      for (let i = 0, len = temp.length; i < len; i++) {
        if (temp[i].id === id) {
          temp.splice(i, 1);
          break;
        }
      }

      this.setState({questions: temp});
    };
  };

  render() {
    const { classes } = this.props;
    const { open } = this.state;

    return (
      <div className={classes.root}>
        <Reboot />
        <div className={classes.appFrame}>
          <AppBar
            className={classNames(classes.appBar, {
              [classes.appBarShift]: open,
            })}
          >
            <Toolbar disableGutters={!open}>
              <IconButton
                color="inherit"
                aria-label="open drawer"
                onClick={this.handleDrawerOpen}
                className={classNames(classes.menuButton, open && classes.hide)}
              >
                <MenuIcon/>
              </IconButton>
              <Typography variant="title" color="inherit" noWrap>
                趣味学中文
              </Typography>
            </Toolbar>
          </AppBar>
          <Drawer
            variant="persistent"
            classes={{
              paper: classes.drawerPaper,
            }}
            anchor="left"
            open={open}
          >
            <div className={classes.drawerInner}>
              <div className={classes.drawerHeader}>
                <IconButton onClick={this.handleDrawerClose}>
                  <CloseIcon />
                </IconButton>
              </div>
              <Divider />
              <NavMenu onAdd={this.addSentence}
                       questions={this.state.questions}
                       onDelete={this.deleteSentence}
              />
            </div>
          </Drawer>
          <main
            className={classNames(classes.content, {
              [classes.contentShift]: open,
            })}
          >
            <Workspace
              showtoolbar={this.state.show_toolbar}
              audiodata={this.state.audioData}
              closeToolbar={()=>{this.setState({show_toolbar: false})}}
              saveQuestion={this.saveQuestion}
              next={this.next}
            />
          </main>
        </div>
      </div>
    );
  }
}

App.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles, {withTheme: true})(App);
