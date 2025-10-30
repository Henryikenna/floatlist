import 'package:flutter/material.dart';

extension Sizing on num {
  SizedBox get spaceH => SizedBox(height: toDouble());
  SizedBox get spaceW => SizedBox(width: toDouble());
}
