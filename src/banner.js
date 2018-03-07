import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from 'material-ui/styles';
import Dialog from 'material-ui/Dialog';

const banners = [
  'Good Job!',
  'Marvelous!',
  'Great Job!',
  'Fantastic!',
  'Extraordinary!',
  'Remarkable!'
];

const styles = {
  banner_txt: {
    margin: '30px 50px',
    color: 'red',
  }
};

class Banner extends React.Component {
  selectBanner = () => {
    let idx = Math.floor(Math.random() * banners.length);
    return banners[idx];
  };

  render() {
    const {classes, correct, ...other} = this.props;

    return (
      <Dialog {...other}>
        <h1 className={classes.banner_txt}>{this.props.correct ? this.selectBanner() : "Try Again."}</h1>
      </Dialog>
    );
  }
}

Banner.propTypes = {
  classes: PropTypes.object.isRequired,
  correct: PropTypes.bool.isRequired,
};

export default withStyles(styles)(Banner);