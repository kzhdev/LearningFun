part of canvas;

class Filter extends Node {

  Filter([Map<String, dynamic> config = const {}]) : super(config);

  @override
  Node _clone(Map<String, dynamic> config) => new Filter(config);

  @override
  NodeImpl createImpl([bool isReflection = false]) => new FilterImpl(this);

  void set offset(List<num> value) => setAttribute(FILTER_OFFSET, value);
  List<num> get offset => getAttribute(FILTER_OFFSET, []);

  @override
  String get id => getAttribute(ID, '__filter_${uid}');

  void addFilter(Map<String, dynamic> filter) {
    attrs['filter'] = filter;
  }

  void removeFilter(String filterName) {
    attrs.remove('filter');
  }
}
