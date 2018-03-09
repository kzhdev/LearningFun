import React from 'react';
import PropTypes from "prop-types";
import { withStyles } from 'material-ui/styles';
import List, { ListItem, ListItemIcon, ListItemText } from 'material-ui/List';
import IconButton from 'material-ui/IconButton';
import Divider from 'material-ui/Divider';
import AddIcon from 'material-ui-icons/Add';
import DeleteIcon from 'material-ui-icons/Delete';
import OpenIcon from 'material-ui-icons/FolderOpen';

const styles = {
  text: {
    paddingRight: 0
  },
  row: {
    padding: '5 5 5 10px'
  }
};

class NavMenu extends React.Component {
  render() {
    const {classes, onAdd} = this.props;

    let questions = this.props.questions.map(item => {
      return (
        <ListItem key={item.id} className={classes.row}>
          <ListItemText className={classes.text} primary={item.sentence} />
          <IconButton data-id={item.id} onClick={(e) => { this.props.onEdit(e.currentTarget.dataset.id)} }>
            <OpenIcon/>
          </IconButton>
          <IconButton data-id={item.id} onClick={(e) => { this.props.onDelete(e.currentTarget.dataset.id)} }>
            <DeleteIcon/>
          </IconButton>
        </ListItem>
      );
    });

    return(
      <List>
        <ListItem button onClick={onAdd}>
          <ListItemIcon><AddIcon/></ListItemIcon>
          <ListItemText primary="添加新句子" />
        </ListItem>
        <Divider/>
        {questions}
      </List>
    );
  };
}

NavMenu.propTypes = {
  classes: PropTypes.object.isRequired,
  onAdd: PropTypes.func,
  questions: PropTypes.array.isRequired,
  onDelete: PropTypes.func,
  onEdit: PropTypes.func,
};

export default withStyles(styles)(NavMenu);
