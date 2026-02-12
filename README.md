# Mahalla Members Form

A comprehensive Flutter application demonstrating enterprise-level mobile development practices through a real-world family registration system. This project showcases clean architecture, state management, and production-ready form handling.

## Project Overview

This application serves as a data collection tool for the Kohilawatta JM & Burial Ground community, enabling efficient registration of household and family member information. The system handles complex form validation, multi-step data entry, and secure submission to a Google Apps Script backend.

## Technical Highlights

### Architecture & Design Patterns

- **Clean Architecture**: Separation of concerns across presentation, domain, and data layers
- **BLoC Pattern**: State management using flutter_bloc for predictable state handling
- **Dependency Injection**: GetIt for loose coupling and testable code
- **Repository Pattern**: Abstract data sources for maintainable and testable data layer

### Key Features Demonstrated

**Complex Form Management**
- Multi-step form with dynamic validation rules
- Conditional field rendering based on user selections
- Real-time form state synchronization
- Custom validation logic for phone numbers, NICs, and relationship constraints

**State Management**
- Cubit-based state management for both main form and family member forms
- Immutable state with copyWith pattern
- Proper state lifecycle management
- Error handling and loading states

**Data Handling**
- Custom data sanitization utilities for consistent data formatting
- Type-safe entity models
- JSON serialization with sanitization
- Base64 URL encoding for secure data transmission

**UI/UX Implementation**
- Custom Material Design components (dropdowns, text fields, checkboxes)
- Responsive layouts with proper spacing and visual hierarchy
- Loading indicators and success/error feedback
- Smooth animations and transitions
- Gradient buttons and themed components

**Business Logic**
- Relationship validation (ensuring only one Head of Family)
- Gender-aware form fields (dynamic dropdown options)
- Cascading data updates (clearing dependent fields)
- Comprehensive field requirements based on user roles

### Technical Stack

- **Flutter SDK**: Cross-platform mobile development
- **flutter_bloc**: State management solution
- **get_it**: Service locator for dependency injection
- **http**: REST API communication
- **dartz**: Functional programming with Either type for error handling
- **equatable**: Value equality for state comparison

### Code Quality Features

- Type-safe Dart code with null safety
- Comprehensive input validation and sanitization
- Proper error handling with custom failure classes
- Reusable widget components
- Consistent theming system
- Form controller lifecycle management

### Data Flow

1. User input captured through custom widgets
2. State updates managed by Cubits
3. Validation performed at form and field levels
4. Data sanitized before submission
5. Entity conversion to JSON with proper formatting
6. Base64 encoding and HTTP transmission to backend
7. Response handling with Either pattern for success/failure
