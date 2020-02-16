import 'dart:ui';

enum CollissionEdge { Top, Left, Right, Bottom, Stuck }

CollissionEdge centerCollission(
  Rect target,
  Rect source,
) {
  return target.contains(source.topCenter)
      ? CollissionEdge.Top
      : target.contains(source.bottomCenter)
          ? CollissionEdge.Bottom
          : target.contains(source.centerLeft)
              ? CollissionEdge.Left
              : target.contains(source.centerRight)
                  ? CollissionEdge.Right
                  : null;
}
