import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from rest_framework.viewsets import ModelViewSet
from .models import Product, Cart, Order, CustomUser
from .serializers import ProductSerializer, OrderSerializer  
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.decorators import login_required, user_passes_test
from django.views.decorators.http import require_POST
from django.contrib.admin.views.decorators import staff_member_required
from rest_framework.permissions import IsAuthenticated
from core.permissions import IsAdminOrReadOnly
from django.core.validators import validate_slug
from django.core.exceptions import ValidationError


# REST API for Products
class ProductViewSet(ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer 


def index(request):
    # Get all products, or limit to first 3 if needed
    featured_products = Product.objects.all()[:3]

    print("Featured Products:", featured_products)  #Debugging

    return render(request, 'index.html', {'featured_products': featured_products})

# Shopping Cart Views (User-Specific)
@login_required
def cart_view(request):
    """Display the cart items for the logged-in user"""
    cart_items = Cart.objects.filter(user=request.user).select_related('product')

    if not cart_items.exists():
        cart_items = None 

    total = sum(item.product.price * item.quantity for item in cart_items) if cart_items else 0

    return render(request, 'cart.html', {
        'cart_items': cart_items,
        'total': total
    })


@csrf_protect
@login_required  
@require_POST  
def add_to_cart(request, product_id):
    """Handles adding a product to the cart"""
    if request.method == "POST":
        product = get_object_or_404(Product, id=product_id)
        user = request.user

        # Get or create cart item
        cart_item, created = Cart.objects.get_or_create(user=user, product=product)

        if not created:
            cart_item.quantity += 1 
        else:
            cart_item.quantity = 1

        cart_item.save()

        # Return updated cart info
        updated_cart = Cart.objects.filter(user=user).count()
        return JsonResponse({"success": True, "message": "Product added to cart!", "cart_count": updated_cart})

    return JsonResponse({"success": False, "error": "Invalid request"}, status=400)

# Remove Item from Cart
@login_required
def remove_from_cart(request, product_id):
    """Remove a product from the user's cart"""
    cart_item = get_object_or_404(Cart, user=request.user, product_id=product_id)
    cart_item.delete()
    return redirect('cart')


# Update Cart (AJAX)
@csrf_exempt
def update_cart(request):
    """Update cart quantity dynamically using AJAX"""
    if request.method == "POST":
        data = json.loads(request.body)
        product_id = data.get("product_id")
        action = data.get("action")

        cart = request.session.get("cart", [])
        for item in cart:
            if item["id"] == int(product_id):
                if action == "increase":
                    item["quantity"] += 1
                elif action == "decrease" and item["quantity"] > 1:
                    item["quantity"] -= 1
                break

        request.session["cart"] = cart
        return JsonResponse({"success": True})

    return JsonResponse({"success": False}, status=400)


# Remove Item from Cart (AJAX)
@csrf_exempt
def remove_cart(request):
    """Handle removing a product from the cart via AJAX"""
    if request.method == "POST":
        data = json.loads(request.body)
        product_id = int(data.get("product_id"))

        cart = request.session.get("cart", [])
        cart = [item for item in cart if item["id"] != product_id]
        request.session["cart"] = cart

        return JsonResponse({"success": True})

    return JsonResponse({"success": False}, status=400)


# User Registration
def register(request):
    """Handle user registration"""
    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            user.role = 'customer' 
            user.save()
            login(request, user)
            return redirect('home')
    else:
        form = UserCreationForm()
    return render(request, 'auth/register.html', {'form': form})


# User Login
def login_view(request):
    """Handle user login"""
    if request.method == "POST":
        form = AuthenticationForm(request, data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('home')
    else:
        form = AuthenticationForm()
    return render(request, 'auth/login.html', {'form': form})


# User Logout
@login_required
def logout_view(request):
    """Log out the user and redirect to login page"""
    logout(request)
    return redirect('login')


# Checkout Process
@login_required
def checkout(request):
    """Display checkout page for logged-in user"""
    cart_items = Cart.objects.filter(user=request.user)
    total = sum(item.total_price() for item in cart_items)
    return render(request, 'checkout.html', {'cart_items': cart_items, 'total': total})


# Process Payment (Dummy)
@login_required
@require_POST
def process_payment(request):
    """Simulate a payment process and redirect to success page"""
    return redirect('payment_success')


# Payment Success Page
@login_required
def payment_success(request):   
    """Display payment success message"""
    return render(request, 'payment_success.html')


# Admin Dashboard
@staff_member_required
def admin_dashboard(request):
    """Display statistics on orders, revenue, and inventory for admin users"""
    total_orders = Order.objects.count()
    total_products = Product.objects.count()
    total_revenue = sum(order.total_price() for order in Order.objects.all())

    context = {
        'total_orders': total_orders,
        'total_products': total_products,
        'total_revenue': total_revenue,
    }
    return render(request, 'admin_dashboard.html', context)


# Order History for Customers & Admins
@login_required
def order_history(request):
    """Customers see their order history, while admins see all orders"""
    if hasattr(request.user, 'role') and request.user.role == 'admin':
        orders = Order.objects.all()
    else:
        orders = Order.objects.filter(user=request.user)

    return render(request, 'order_history.html', {'orders': orders})


# API View for Orders
class OrderViewSet(ModelViewSet):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]


# API View for User's Orders
class UserOrderViewSet(ModelViewSet):
    serializer_class = OrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        """Customers only see their own orders; admins see all"""
        if hasattr(self.request.user, 'role') and self.request.user.role == 'customer':
            return Order.objects.filter(user=self.request.user)
        return Order.objects.all()


# Admin Product Management
@login_required
@user_passes_test(lambda u: u.is_staff)
def manage_products(request):
    """Admin-only view for managing products"""
    products = Product.objects.all()
    return render(request, "admin/manage_products.html", {"products": products})


# Product Name Validation
def validate_product_name(name):
    """Ensure product names are valid slugs (security measure)"""
    try:
        validate_slug(name)
    except ValidationError:
        raise ValueError("Invalid product name!")
    
def products(request):
    all_products = Product.objects.all()  # Fetch all products from DB
    return render(request, 'products.html', {'products': all_products})