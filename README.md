# **Mini Zomato Flutter Project**

## Project Overview

This project is a mini food delivery platform built in Flutter 3.x with BLoC for state management. It contains three separate apps:

- **User App** – Customers can browse restaurants, place orders, and track their past orders.
- **Restaurant App** – Restaurant owners can manage orders, update menu items, and view incoming orders.
- **Delivery Partner App** – Delivery agents can view assigned orders, update order status, and share their location.

All apps are modular, scalable, and integrated with Firebase (Firestore + FCM).

---

## **Repository Structure**

```

Mini\_Zomato\_App/
├─ user\_app/          # Customer app
├─ restaurant\_app/    # Restaurant app
├─ delivery\_app/      # Delivery Partner app
└─ README.md          # This file

````

---

## **Features Overview**

### User App

- Login / Signup
- Browse restaurants & menus
- Add items to cart & place orders
- View past orders

### Restaurant App

- Login / Signup
- View and manage incoming orders
- Accept/Reject orders
- Menu management (Add/Edit/Delete)
- Push notifications for new orders

### Delivery Partner App

- Login / Signup
- View assigned orders
- Update order status: Picked / Delivered
- Live location updates in Firestore
- Map screen to track driver location

---

## **Tech Stack**

- Flutter 3.x with null safety
- Dart
- BLoC (`flutter_bloc`) for state management
- Firebase (Auth, Firestore, Cloud Messaging)
- Flutter Local Notifications

---

## **Setup Instructions (Summary)**

### Prerequisites

- Flutter SDK 3.x installed
- Android Studio / VS Code
- Firebase account
- Git

### 1. Clone the repository

```bash
git clone https://github.com/SmitaPatel19/Mini_Zomato_App.git
cd Mini_Zomato_App
````

### 2. Open specific app folder

Open `user_app`, `restaurant_app`, or `delivery_app` and follow the respective README for detailed setup.

### 3. Configure Firebase

* Go to Firebase Console and create a project.
* Add three apps (Android/iOS) for User, Restaurant, and Delivery.
* Download `google-services.json` for Android apps and place in `android/app/`.
* Download `GoogleService-Info.plist` for iOS apps and place in `ios/Runner/`.
* Enable Firestore and Firebase Cloud Messaging.
* Create collections:

```
users/{uid}
restaurants/{rid}
restaurants/{rid}/menu/{mid}
orders/{oid}
delivery_partners/{did}
user_restaurants/{docId}
```

### 4. Install dependencies

```bash
flutter pub get
```

### 5. Run the app

```bash
flutter run
```

---

## **BLoC Architecture**

Each app follows a **clean BLoC architecture**:

* **AuthBloc** – Handles authentication.
* **OrderBloc / IncomingOrdersBloc / DeliveryOrdersBloc** – Manages orders.
* **MenuBloc / MenuMgmtBloc** – Manages menus.
* **CartBloc** – User app cart management.
* **OrderActionBloc** – Accept/Reject orders (Restaurant app).
* **DeliveryStatusBloc / MapBloc** – Delivery app status and location tracking.

This ensures modular, maintainable, and scalable code.

---

## **Contributions**

* Feel free to fork, submit issues, or pull requests.
* Maintain **separate branches** for feature development.

---

## **Author**

Smita Patel
[GitHub Profile](https://github.com/SmitaPatel19)
