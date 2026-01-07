import 'package:flutter/material.dart';

/// Widget para mostrar el NutriScore (A-E) con colores oficiales.
/// 
/// NutriScore es un sistema de etiquetado nutricional de 5 colores:
/// A (verde oscuro) - Mejor calidad nutricional
/// B (verde claro)
/// C (amarillo)
/// D (naranja)
/// E (rojo) - Peor calidad nutricional
class NutriScoreBadge extends StatelessWidget {
  const NutriScoreBadge({
    super.key,
    required this.grade,
    this.size = NutriScoreSize.medium,
  });

  final String grade;
  final NutriScoreSize size;

  Color _getColor() {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFF038141); // Verde oscuro
      case 'B':
        return const Color(0xFF85BB2F); // Verde claro
      case 'C':
        return const Color(0xFFFECB02); // Amarillo
      case 'D':
        return const Color(0xFFEE8100); // Naranja
      case 'E':
        return const Color(0xFFE63E11); // Rojo
      default:
        return Colors.grey;
    }
  }

  double _getSize() {
    switch (size) {
      case NutriScoreSize.small:
        return 20;
      case NutriScoreSize.medium:
        return 28;
      case NutriScoreSize.large:
        return 36;
    }
  }

  double _getFontSize() {
    switch (size) {
      case NutriScoreSize.small:
        return 12;
      case NutriScoreSize.medium:
        return 16;
      case NutriScoreSize.large:
        return 20;
    }
  }

  @override
  Widget build(BuildContext context) {
    final boxSize = _getSize();
    final fontSize = _getFontSize();

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          grade.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

/// Widget extendido con todos los grados y el actual resaltado.
class NutriScoreBar extends StatelessWidget {
  const NutriScoreBar({
    super.key,
    required this.grade,
    this.showLabel = true,
  });

  final String grade;
  final bool showLabel;

  Color _getColor(String g) {
    switch (g) {
      case 'A':
        return const Color(0xFF038141);
      case 'B':
        return const Color(0xFF85BB2F);
      case 'C':
        return const Color(0xFFFECB02);
      case 'D':
        return const Color(0xFFEE8100);
      case 'E':
        return const Color(0xFFE63E11);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    const grades = ['A', 'B', 'C', 'D', 'E'];
    final currentGrade = grade.toUpperCase();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              'NutriScore',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: grades.map((g) {
            final isActive = g == currentGrade;
            return Padding(
              padding: const EdgeInsets.only(right: 2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isActive ? 28 : 20,
                height: isActive ? 28 : 20,
                decoration: BoxDecoration(
                  color: _getColor(g),
                  borderRadius: BorderRadius.circular(4),
                  border: isActive
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    g,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isActive ? 14 : 11,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

enum NutriScoreSize {
  small,
  medium,
  large,
}
