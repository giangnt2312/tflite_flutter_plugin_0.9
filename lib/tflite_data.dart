
class TfliteData {
  TfliteData._internal();
  static final TfliteData shared = TfliteData._internal();
  factory TfliteData() {
    return shared;
  }

  String _pathLibTensorFlowLite = '';
  String get pathLibTensorFlowLite => _pathLibTensorFlowLite;
  set pathLibTensorFlowLite(value) {
    _pathLibTensorFlowLite = value;
  }

}