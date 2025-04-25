# fitness

A Flutter project for fitness enthusiasts, providing a seamless shopping experience for fitness products. This application allows users to browse, search, and purchase fitness equipment and accessories.

## Features

- **Product Listing**: Displays a grid of fitness products with images, prices, and discounts.
- **Search Functionality**: Users can search for products by name.
- **Category Filtering**: Products can be filtered by categories.
- **Cart Management**: Add, view, and manage items in the shopping cart.
- **Product Details**: Detailed view of each product with multiple images and pricing information.
- **Responsive Design**: Optimized for various screen sizes, including iPads.

## Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd fitness
   ```

2. **Install Dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the Application**:

   ```bash
   flutter run
   ```

4. **Build for Release**:
   - Android: `flutter build apk`
   - iOS: `flutter build ios`

## Implementation Approach

1. **State Management**:

   - Used `Provider` for managing the cart state and product filtering.

2. **UI Design**:

   - Designed using Flutter widgets with a focus on responsiveness and user experience.
   - Utilized `GridView` for product listing and `TabController` for category navigation.

3. **Data Handling**:

   - Product data is stored in a local JSON file (`assets/products.json`).
   - Images are stored in the `assets` folder and loaded dynamically.

4. **Routing**:
   - Implemented navigation using `GoRouter` for seamless page transitions.

## Assumptions and Deviations

- **Assumptions**:

  - The product data is static and does not require a backend API.
  - Discounts and old prices are optional fields in the product data.

- **Deviations**:
  - The app currently does not include user authentication or payment integration.
  - The search functionality is case-insensitive and matches substrings.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)
