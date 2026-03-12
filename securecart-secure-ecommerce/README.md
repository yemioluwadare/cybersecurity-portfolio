# SecureCart – Secure E-Commerce Web Application

## Overview

SecureCart is a prototype e-commerce web application built using the Django framework.

The project demonstrates how core online shopping functionality can be implemented while applying basic security practices such as authentication, access control, and server-side validation.

Users can browse products, manage a shopping cart, and complete transactions through a structured backend application.

---

## Features

- User authentication and session management
- Product catalogue browsing
- Shopping cart functionality
- Checkout workflow
- Role-based access control
- Admin dashboard for product and order management

---

## Technology Stack

Python  
Django  
SQLite  
HTML Templates  
Bootstrap  

---

## Application Preview

### Product Catalogue

![Products](screenshots/products.png)

### Login Page

![Login](screenshots/login.png)

### Shopping Cart

![Cart](screenshots/cart.png)

### Checkout Process

![Checkout](screenshots/checkout.png)

### Admin Dashboard

![Admin](screenshots/admin.png)

---

## Project Structure

```
securecart-secure-ecommerce
│
├── manage.py
├── requirements.txt
│
├── securecart/        # Django project configuration
│
├── core/              # Application logic
│   ├── models.py
│   ├── views.py
│   ├── serializers.py
│   ├── permissions.py
│
├── templates/         # Front-end HTML templates
├── static/            # Static assets
├── screenshots/       # Application screenshots
```

---

## Running the Application

### 1 Install dependencies

```
pip install -r requirements.txt
```

### 2 Apply database migrations

```
python manage.py migrate
```

### 3 Start the development server

```
python manage.py runserver
```

The application will be available at:

```
http://127.0.0.1:8000/
```

---

## Notes

This project was developed as part of university coursework exploring secure web application development concepts.

The repository focuses on demonstrating backend architecture and application logic rather than production deployment.
