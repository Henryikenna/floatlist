import 'package:flutter/material.dart';

extension ColorX on Color {
  Color withOpacityFactor(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withValues(alpha: opacity);
  }
}
