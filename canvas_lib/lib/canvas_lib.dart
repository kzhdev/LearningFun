library canvas;

// external dependencies
import 'dart:html' as dom;
import 'dart:math';
import 'dart:svg' as svg;
import 'dart:async';

import 'package:r2d2/r2d2_client.dart';
import 'package:dart_ext/collection_ext.dart';

import 'event_bus.dart';

part 'nodebase.dart';
part 'node.dart';
part 'utils/container.dart';
part 'canvas.dart';
part 'group.dart';
part 'layer.dart';
part 'pattern.dart';
part 'animation_loop.dart';
part 'container_node.dart';
part 'reflection_layer.dart';
part 'filter.dart';
part 'gradient/gradient.dart';
part 'gradient/linear_gradient.dart';
part 'gradient/radial_gradient.dart';

part 'utils/position.dart';
part 'utils/constants.dart';
part 'utils/size.dart';
part 'utils/util.dart';
part 'utils/text_measure.dart';
part 'utils/bbox.dart';
part 'utils/transform_matrix.dart';

part 'shapes/circle.dart';
part 'shapes/ellipse.dart';
part 'shapes/rect.dart';
part 'shapes/line.dart';
part 'shapes/text.dart';
part 'shapes/poly_shape.dart';
part 'shapes/polygon.dart';
part 'shapes/path.dart';

part 'impl/control_points/control_point.dart';
part 'impl/control_points/n_control_point.dart';
part 'impl/control_points/s_control_point.dart';
part 'impl/control_points/w_control_point.dart';
part 'impl/control_points/e_control_point.dart';
part 'impl/control_points/nw_control_point.dart';
part 'impl/control_points/ne_control_point.dart';
part 'impl/control_points/sw_control_point.dart';
part 'impl/control_points/se_control_point.dart';

part 'impl/node_impl.dart';
part 'impl/group_impl.dart';
part 'impl/layer_impl.dart';
part 'impl/pattern_impl.dart';
part 'impl/def_layer_impl.dart';
part 'impl/container_node_impl.dart';
part 'impl/draggable_node_impl.dart';
part 'impl/filter_impl.dart';
part 'impl/gradient/gradient_impl.dart';
part 'impl/gradient/linear_gradient_impl.dart';
part 'impl/gradient/radial_gradient_impl.dart';

part 'impl/shapes/circle_impl.dart';
part 'impl/shapes/rect_impl.dart';
part 'impl/shapes/ellipse_impl.dart';
part 'impl/shapes/line_impl.dart';
part 'impl/shapes/text_impl.dart';
part 'impl/shapes/poly_shape_impl.dart';
part 'impl/shapes/polygon_impl.dart';
part 'impl/shapes/path_impl.dart';

