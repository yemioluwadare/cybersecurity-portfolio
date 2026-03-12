from django.db import models
from django.contrib.auth.models import User, AbstractUser
from django.conf import settings 

class Product(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.PositiveIntegerField()
    category = models.CharField(max_length=100, default="Uncategorised")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name  # Show product name in admin panel

# Cart Model - Stores products added to the shopping cart
class Cart(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True, blank=True, default=1)  
    product = models.ForeignKey('Product', on_delete=models.CASCADE)  # Reference to Product model
    quantity = models.PositiveIntegerField(default=1)  # Number of items in the cart

    def total_price(self):
        """Calculate total price for this cart item."""
        return self.product.price * self.quantity  

    def __str__(self):
        return f"{self.user.username} - {self.product.name} ({self.quantity})"

# Order Model - Stores customer orders
class Order(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE, default=1)  # Set default product ID
    quantity = models.PositiveIntegerField(default=1)
    total_amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, choices=[('pending', 'Pending'), ('completed', 'Completed')])
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Order #{self.id} - {self.user.username}"

# Custom User Model - Extends Django's built-in user model
class CustomUser(AbstractUser):
    ROLE_CHOICES = (
        ('admin', 'Admin'),
        ('customer', 'Customer'),
    )
    role = models.CharField(max_length=10, choices=ROLE_CHOICES, default='customer')  # User role (admin/customer)

    def is_admin(self):
        """Check if the user is an admin."""
        return self.role == 'admin'

    def is_customer(self):
        """Check if the user is a customer."""
        return self.role == 'customer'