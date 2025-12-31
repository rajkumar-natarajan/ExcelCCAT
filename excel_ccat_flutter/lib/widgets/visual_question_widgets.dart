import 'package:flutter/material.dart';

/// Custom painters and widgets for visual/image-based CCAT questions
/// These replace the need for static image assets with programmatic drawings

// MARK: - Shape Painters

/// Draws basic shapes for pattern recognition questions
class ShapePainter extends CustomPainter {
  final String shapeType;
  final Color color;
  final bool filled;
  
  ShapePainter({
    required this.shapeType,
    this.color = Colors.black,
    this.filled = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;
    
    final center = Offset(size.width / 2, size.height / 2);
    final minDim = size.width < size.height ? size.width : size.height;
    final radius = minDim * 0.4;

    switch (shapeType.toLowerCase()) {
      case 'circle':
        canvas.drawCircle(center, radius, paint);
        break;
      case 'square':
        final rect = Rect.fromCenter(center: center, width: radius * 1.8, height: radius * 1.8);
        canvas.drawRect(rect, paint);
        break;
      case 'triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius, center.dy + radius * 0.8)
          ..lineTo(center.dx - radius, center.dy + radius * 0.8)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'rectangle':
        final rect = Rect.fromCenter(center: center, width: radius * 2.2, height: radius * 1.4);
        canvas.drawRect(rect, paint);
        break;
      case 'star':
        _drawStar(canvas, center, radius, paint);
        break;
      case 'pentagon':
        _drawPolygon(canvas, center, radius, 5, paint);
        break;
      case 'hexagon':
        _drawPolygon(canvas, center, radius, 6, paint);
        break;
      case 'diamond':
        final path = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius * 0.7, center.dy)
          ..lineTo(center.dx, center.dy + radius)
          ..lineTo(center.dx - radius * 0.7, center.dy)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'heart':
        _drawHeart(canvas, center, radius, paint);
        break;
      case 'oval':
        final rect = Rect.fromCenter(center: center, width: radius * 2, height: radius * 1.3);
        canvas.drawOval(rect, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = (i * 36 - 90) * 3.14159 / 180;
      final r = i.isEven ? radius : radius * 0.4;
      final x = center.dx + r * (cos(angle));
      final y = center.dy + r * (sin(angle));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double angle) => 
    (angle == 1.5708 || angle == -1.5708) ? 0 : 
    (angle == 0 || angle == 3.14159) ? (angle == 0 ? 1 : -1) :
    _cos(angle);
  
  double sin(double angle) =>
    (angle == 0 || angle == 3.14159) ? 0 :
    (angle == 1.5708) ? 1 : (angle == -1.5708) ? -1 :
    _sin(angle);
    
  double _cos(double x) {
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }
  
  double _sin(double x) {
    double result = x;
    double term = x;
    for (int i = 1; i < 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  void _drawPolygon(Canvas canvas, Offset center, double radius, int sides, Paint paint) {
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (i * 360 / sides - 90) * 3.14159 / 180;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + radius * 0.8);
    path.cubicTo(
      center.dx - radius * 1.5, center.dy - radius * 0.5,
      center.dx - radius * 0.5, center.dy - radius * 1.2,
      center.dx, center.dy - radius * 0.5,
    );
    path.cubicTo(
      center.dx + radius * 0.5, center.dy - radius * 1.2,
      center.dx + radius * 1.5, center.dy - radius * 0.5,
      center.dx, center.dy + radius * 0.8,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget for displaying shape-based questions
class ShapeWidget extends StatelessWidget {
  final String shapeType;
  final Color color;
  final bool filled;
  final double size;

  const ShapeWidget({
    super.key,
    required this.shapeType,
    this.color = Colors.black,
    this.filled = false,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: ShapePainter(
          shapeType: shapeType,
          color: color,
          filled: filled,
        ),
      ),
    );
  }
}

// MARK: - Pattern Sequence Painters

/// Draws a sequence of shapes/patterns for visual pattern questions
class PatternSequencePainter extends CustomPainter {
  final List<String> patterns;
  final List<Color> colors;
  
  PatternSequencePainter({
    required this.patterns,
    List<Color>? colors,
  }) : colors = colors ?? List.filled(patterns.length, Colors.black);

  @override
  void paint(Canvas canvas, Size size) {
    final itemWidth = size.width / (patterns.length + 0.5);
    
    for (int i = 0; i < patterns.length; i++) {
      final centerX = itemWidth * (i + 0.5);
      final center = Offset(centerX, size.height / 2);
      final itemRadius = itemWidth * 0.35;
      
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      _drawPattern(canvas, center, itemRadius, patterns[i], paint);
    }
  }

  void _drawPattern(Canvas canvas, Offset center, double radius, String pattern, Paint paint) {
    switch (pattern.toLowerCase()) {
      case 'circle':
        canvas.drawCircle(center, radius, paint);
        break;
      case 'filled_circle':
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(center, radius, paint);
        break;
      case 'square':
        final rect = Rect.fromCenter(center: center, width: radius * 2, height: radius * 2);
        canvas.drawRect(rect, paint);
        break;
      case 'filled_square':
        paint.style = PaintingStyle.fill;
        final rect = Rect.fromCenter(center: center, width: radius * 2, height: radius * 2);
        canvas.drawRect(rect, paint);
        break;
      case 'triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - radius)
          ..lineTo(center.dx + radius, center.dy + radius * 0.8)
          ..lineTo(center.dx - radius, center.dy + radius * 0.8)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'question':
        final textPainter = TextPainter(
          text: TextSpan(
            text: '?',
            style: TextStyle(
              fontSize: radius * 1.5,
              fontWeight: FontWeight.bold,
              color: paint.color,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget for displaying pattern sequence questions
class PatternSequenceWidget extends StatelessWidget {
  final List<String> patterns;
  final List<Color>? colors;
  final double height;

  const PatternSequenceWidget({
    super.key,
    required this.patterns,
    this.colors,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: PatternSequencePainter(
          patterns: patterns,
          colors: colors,
        ),
        size: Size.infinite,
      ),
    );
  }
}

// MARK: - Matrix Pattern Painters

/// Draws a 3x3 matrix grid for figure matrix questions
class MatrixPatternPainter extends CustomPainter {
  final List<List<String>> matrix; // 3x3 matrix of patterns
  final bool showQuestionMark;
  
  MatrixPatternPainter({
    required this.matrix,
    this.showQuestionMark = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 3;
    final padding = cellSize * 0.15;
    
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withAlpha(100)
      ..strokeWidth = 1;

    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(cellSize * i, 0),
        Offset(cellSize * i, size.height),
        gridPaint,
      );
      canvas.drawLine(
        Offset(0, cellSize * i),
        Offset(size.width, cellSize * i),
        gridPaint,
      );
    }

    // Draw patterns in each cell
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (row < matrix.length && col < matrix[row].length) {
          final pattern = matrix[row][col];
          final center = Offset(
            cellSize * col + cellSize / 2,
            cellSize * row + cellSize / 2,
          );
          final radius = (cellSize - padding * 2) / 2;
          
          if (pattern == '?' && showQuestionMark) {
            final textPainter = TextPainter(
              text: TextSpan(
                text: '?',
                style: TextStyle(
                  fontSize: radius * 1.2,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              textDirection: TextDirection.ltr,
            );
            textPainter.layout();
            textPainter.paint(
              canvas,
              Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
            );
          } else {
            _drawCellPattern(canvas, center, radius, pattern, paint);
          }
        }
      }
    }
  }

  void _drawCellPattern(Canvas canvas, Offset center, double radius, String pattern, Paint paint) {
    switch (pattern.toLowerCase()) {
      case 'circle':
        canvas.drawCircle(center, radius * 0.8, paint);
        break;
      case 'filled_circle':
        final fillPaint = Paint()..color = Colors.black;
        canvas.drawCircle(center, radius * 0.8, fillPaint);
        break;
      case 'square':
        final rect = Rect.fromCenter(center: center, width: radius * 1.5, height: radius * 1.5);
        canvas.drawRect(rect, paint);
        break;
      case 'filled_square':
        final fillPaint = Paint()..color = Colors.black;
        final rect = Rect.fromCenter(center: center, width: radius * 1.5, height: radius * 1.5);
        canvas.drawRect(rect, fillPaint);
        break;
      case 'triangle':
        final path = Path()
          ..moveTo(center.dx, center.dy - radius * 0.8)
          ..lineTo(center.dx + radius * 0.8, center.dy + radius * 0.6)
          ..lineTo(center.dx - radius * 0.8, center.dy + radius * 0.6)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case 'x':
        canvas.drawLine(
          Offset(center.dx - radius * 0.5, center.dy - radius * 0.5),
          Offset(center.dx + radius * 0.5, center.dy + radius * 0.5),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx + radius * 0.5, center.dy - radius * 0.5),
          Offset(center.dx - radius * 0.5, center.dy + radius * 0.5),
          paint,
        );
        break;
      case '+':
        canvas.drawLine(
          Offset(center.dx, center.dy - radius * 0.6),
          Offset(center.dx, center.dy + radius * 0.6),
          paint,
        );
        canvas.drawLine(
          Offset(center.dx - radius * 0.6, center.dy),
          Offset(center.dx + radius * 0.6, center.dy),
          paint,
        );
        break;
      case 'dot':
        final fillPaint = Paint()..color = Colors.black;
        canvas.drawCircle(center, radius * 0.2, fillPaint);
        break;
      case 'empty':
        // Draw nothing
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Widget for displaying matrix pattern questions
class MatrixPatternWidget extends StatelessWidget {
  final List<List<String>> matrix;
  final double size;

  const MatrixPatternWidget({
    super.key,
    required this.matrix,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomPaint(
        painter: MatrixPatternPainter(matrix: matrix),
      ),
    );
  }
}

// MARK: - Color Pattern Widgets

/// Widget for displaying color-based questions (for kindergarten)
class ColorPatternWidget extends StatelessWidget {
  final List<Color> colors;
  final bool showQuestionMark;
  final double size;

  const ColorPatternWidget({
    super.key,
    required this.colors,
    this.showQuestionMark = true,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < colors.length; i++) ...[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: colors[i],
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          if (i < colors.length - 1)
            const SizedBox(width: 8),
        ],
        if (showQuestionMark) ...[
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward, size: 24),
          const SizedBox(width: 16),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// MARK: - Counting Objects Widget

/// Widget for counting questions with visual objects
class CountingObjectsWidget extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final double iconSize;

  const CountingObjectsWidget({
    super.key,
    required this.icon,
    required this.count,
    this.color = Colors.black,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) => Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}

// MARK: - Rotation Pattern Widget

/// Widget showing rotation patterns
class RotationPatternWidget extends StatelessWidget {
  final List<double> rotations; // in degrees
  final String shape;
  final double size;

  const RotationPatternWidget({
    super.key,
    required this.rotations,
    this.shape = 'triangle',
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < rotations.length; i++) ...[
          Transform.rotate(
            angle: rotations[i] * 3.14159 / 180,
            child: ShapeWidget(
              shapeType: shape,
              size: size,
            ),
          ),
          if (i < rotations.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.arrow_forward, size: 20),
            ),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 20),
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// MARK: - Visual Question Types

/// Enum for visual question display types
enum VisualQuestionType {
  shapePattern,
  colorPattern,
  countingObjects,
  matrixPattern,
  rotationPattern,
  sequencePattern,
  sizeComparison,
  oddOneOut,
}

/// Data class for visual question configuration
class VisualQuestionData {
  final VisualQuestionType type;
  final Map<String, dynamic> data;

  VisualQuestionData({
    required this.type,
    required this.data,
  });
}

/// Widget that renders the appropriate visual based on question data
class VisualQuestionDisplay extends StatelessWidget {
  final VisualQuestionData questionData;

  const VisualQuestionDisplay({
    super.key,
    required this.questionData,
  });

  @override
  Widget build(BuildContext context) {
    switch (questionData.type) {
      case VisualQuestionType.shapePattern:
        return PatternSequenceWidget(
          patterns: List<String>.from(questionData.data['patterns'] ?? []),
          colors: (questionData.data['colors'] as List<dynamic>?)
              ?.map((c) => c as Color)
              .toList(),
        );
      case VisualQuestionType.colorPattern:
        return ColorPatternWidget(
          colors: List<Color>.from(questionData.data['colors'] ?? []),
        );
      case VisualQuestionType.countingObjects:
        return CountingObjectsWidget(
          icon: questionData.data['icon'] as IconData? ?? Icons.star,
          count: questionData.data['count'] as int? ?? 5,
          color: questionData.data['color'] as Color? ?? Colors.black,
        );
      case VisualQuestionType.matrixPattern:
        return MatrixPatternWidget(
          matrix: List<List<String>>.from(
            (questionData.data['matrix'] as List<dynamic>?)
                ?.map((row) => List<String>.from(row as List))
                .toList() ?? [],
          ),
        );
      case VisualQuestionType.rotationPattern:
        return RotationPatternWidget(
          rotations: List<double>.from(questionData.data['rotations'] ?? []),
          shape: questionData.data['shape'] as String? ?? 'triangle',
        );
      case VisualQuestionType.sequencePattern:
        return PatternSequenceWidget(
          patterns: List<String>.from(questionData.data['patterns'] ?? []),
        );
      case VisualQuestionType.sizeComparison:
        return _buildSizeComparison(questionData.data);
      case VisualQuestionType.oddOneOut:
        return _buildOddOneOut(questionData.data);
    }
  }

  Widget _buildSizeComparison(Map<String, dynamic> data) {
    final shapes = List<Map<String, dynamic>>.from(data['shapes'] ?? []);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: shapes.map((shape) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ShapeWidget(
            shapeType: shape['type'] as String? ?? 'circle',
            size: (shape['size'] as num?)?.toDouble() ?? 50,
            color: shape['color'] as Color? ?? Colors.black,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOddOneOut(Map<String, dynamic> data) {
    final items = List<String>.from(data['items'] ?? []);
    final colors = List<Color>.from(data['colors'] ?? 
        List.filled(items.length, Colors.black));
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ShapeWidget(
              shapeType: items[i],
              size: 60,
              color: colors[i],
            ),
          ),
      ],
    );
  }
}

// MARK: - Answer Option Widgets

/// Widget for shape-based answer options
class ShapeAnswerOption extends StatelessWidget {
  final String shapeType;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final bool filled;

  const ShapeAnswerOption({
    super.key,
    required this.shapeType,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer 
              : Colors.white,
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary 
                : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ShapeWidget(
          shapeType: shapeType,
          color: color ?? Colors.black,
          filled: filled,
          size: 50,
        ),
      ),
    );
  }
}

/// Widget for color-based answer options  
class ColorAnswerOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final String? label;

  const ColorAnswerOption({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.black,
                width: isSelected ? 4 : 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withAlpha(100),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 4),
            Text(
              label!,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
