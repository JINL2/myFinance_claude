import 'dart:ui';

/// Utility class for generating consistent role colors
class RoleColorUtils {
  // Private constructor to prevent instantiation
  RoleColorUtils._();

  // Extended color palette for better distribution
  static const List<Color> _roleColors = [
    Color(0xFFE53E3E), // Red
    Color(0xFF3182CE), // Blue  
    Color(0xFF38A169), // Green
    Color(0xFF805AD5), // Purple
    Color(0xFFDD6B20), // Orange
    Color(0xFF319795), // Teal
    Color(0xFFD69E2E), // Yellow
    Color(0xFFED64A6), // Pink
    Color(0xFF718096), // Gray
    Color(0xFF2D3748), // Dark Gray
    Color(0xFF9F7AEA), // Light Purple
    Color(0xFF4299E1), // Light Blue
    Color(0xFF48BB78), // Light Green
    Color(0xFFF56565), // Light Red
    Color(0xFFED8936), // Light Orange
    Color(0xFF38B2AC), // Light Teal
    Color(0xFFF6E05E), // Light Yellow
    Color(0xFFB83280), // Dark Pink
    Color(0xFF2B6CB0), // Dark Blue
    Color(0xFF2F855A), // Dark Green
  ];

  /// Get a consistent color for a role based on its name
  /// This ensures all "Admin" roles get the same color, all "Employee" roles get the same color, etc.
  static Color getRoleColor(String roleName) {
    // Normalize the role name to ensure consistency
    final normalizedRole = roleName.trim().toLowerCase();
    
    // Define specific colors for common role types
    switch (normalizedRole) {
      case 'admin':
      case 'administrator':
        return const Color(0xFF805AD5); // Purple
      case 'employee':
        return const Color(0xFF38A169); // Green
      case 'manager':
        return const Color(0xFF3182CE); // Blue
      case 'owner':
        return const Color(0xFFE53E3E); // Red
      case 'supervisor':
        return const Color(0xFFDD6B20); // Orange
      case 'director':
        return const Color(0xFF319795); // Teal
      case 'executive':
        return const Color(0xFF2D3748); // Dark Gray
      case 'intern':
        return const Color(0xFF4299E1); // Light Blue
      case 'contractor':
        return const Color(0xFFED8936); // Light Orange
      case 'guest':
        return const Color(0xFF718096); // Gray
      default:
        // For custom roles, use hash-based color selection
        int hash = 0;
        for (int i = 0; i < normalizedRole.length; i++) {
          hash = 31 * hash + normalizedRole.codeUnitAt(i);
        }
        
        // Mix the hash for better distribution
        hash = hash ^ (hash >> 16);
        hash = hash * 0x85ebca6b;
        hash = hash ^ (hash >> 13);
        
        // Ensure positive index and avoid common role colors
        final customColors = [
          const Color(0xFFD69E2E), // Yellow
          const Color(0xFFED64A6), // Pink
          const Color(0xFF9F7AEA), // Light Purple
          const Color(0xFFF56565), // Light Red
          const Color(0xFF48BB78), // Light Green
          const Color(0xFF38B2AC), // Light Teal
          const Color(0xFFF6E05E), // Light Yellow
          const Color(0xFFB83280), // Dark Pink
          const Color(0xFF2B6CB0), // Dark Blue
          const Color(0xFF2F855A), // Dark Green
        ];
        
        final index = hash.abs() % customColors.length;
        return customColors[index];
    }
  }

  /// Get the color palette size
  static int get colorCount => _roleColors.length;
}