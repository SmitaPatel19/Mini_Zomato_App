# **Mini Zomato Flutter Project**

A **mini food delivery system** built with **Flutter** using **BLoC** and **Firebase**.
This repo contains **3 separate apps**:

1. **User App (Customer)** – Browse restaurants, place orders.
2. **Restaurant App** – Manage menu, receive and process orders.
3. **Delivery Partner App** – View assigned deliveries, update status, and share live location.

---

## **Repository Structure**

```
Mini_Zomato_App/
 ├─ user_app/          # Customer app
 ├─ restaurant_app/    # Restaurant app
 ├─ delivery_app/      # Delivery Partner app
 └─ README.md          # This file
```

---

## **App-Specific READMEs**

* [User App Setup & Instructions](user_app/README.md)
* [Restaurant App Setup & Instructions](restaurant_app/README.md)
* [Delivery Partner App Setup & Instructions](delivery_app/README.md)

---

## **Features Overview**

### User App

* Login / Signup
* Browse restaurants & menus
* Add items to cart & place orders
* View past orders

### Restaurant App

* Login / Signup
* View and manage incoming orders
* Accept/Reject orders
* Menu management (Add/Edit/Delete)
* Push notifications for new orders

### Delivery Partner App

* Login / Signup
* View assigned orders
* Update order status: Picked / Delivered
* Live location updates in Firestore
* Map screen to track driver location

---

## **Tech Stack**

* Flutter 3.x with null safety
* Dart
* BLoC (`flutter_bloc`) for state management
* Firebase (Auth, Firestore, Cloud Messaging)
* Flutter Local Notifications

---

## **Setup Instructions (Summary)**

1. Clone the repository:

```bash
git clone https://github.com/SmitaPatel19/Mini_Zomato_App.git
cd Mini_Zomato_App
```

2. Open the specific app folder (`user_app`, `restaurant_app`, `delivery_app`) and follow the respective README for detailed setup.
3. Install dependencies:

```bash
flutter pub get
```

4. Configure Firebase for each app (Auth, Firestore, Cloud Messaging).
5. Run the app:

```bash
flutter run
```

---

## **BLoC Architecture**

Each app follows a **clean BLoC architecture**:

* **AuthBloc** – Handles authentication.
* **OrderBloc / IncomingOrdersBloc / DeliveryOrdersBloc** – Manages orders.
* **MenuBloc / MenuMgmtBloc** – Manages menus.
* **CartBloc** – For user cart management.
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

---
