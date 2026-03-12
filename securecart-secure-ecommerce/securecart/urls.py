from django.contrib import admin
from django.urls import path, include 
from rest_framework.routers import DefaultRouter
from django.views.generic import TemplateView
from django.contrib.auth import views as auth_views
from core import views 

# Set up the API router
router = DefaultRouter()
router.register(r'products', views.ProductViewSet, basename='products')
router.register(r'orders', views.OrderViewSet, basename='orders')
router.register(r'user-orders', views.UserOrderViewSet, basename='user-orders')

urlpatterns = [
    # Core Pages
    path('', TemplateView.as_view(template_name="index.html"), name='home'),
    path('products/', views.products, name='products'), 
    path('cart/', TemplateView.as_view(template_name="cart.html"), name='cart'),
    path('checkout/', views.checkout, name='checkout'), 
    path('contact/', TemplateView.as_view(template_name="contact.html"), name='contact'),

    # Cart Operations
    path('add-to-cart/<int:product_id>/', views.add_to_cart, name='add_to_cart'),
    path('remove-from-cart/<int:product_id>/', views.remove_from_cart, name='remove_from_cart'),
    path('update-cart/', views.update_cart, name='update_cart'),
    path('remove-cart/', views.remove_cart, name='remove_cart'),

    # Authentication
    path('login/', auth_views.LoginView.as_view(template_name='auth/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(next_page='home'), name='logout'), 
    path('register/', views.register, name='register'),

    # Password Reset
    path('reset_password/', auth_views.PasswordResetView.as_view(template_name="auth/password_reset_form.html"), name="reset_password"),
    path('reset_password_sent/', auth_views.PasswordResetDoneView.as_view(template_name="auth/password_reset_confirmation.html"), name="password_reset_done"),
    path('reset/<uidb64>/<token>/', auth_views.PasswordResetConfirmView.as_view(template_name="auth/new_password.html"), name="password_reset_confirm"),
    path('reset_password_complete/', auth_views.PasswordResetCompleteView.as_view(template_name="auth/password_created.html"), name="password_reset_complete"),

    # Checkout & Payment
    path('process_payment/', views.process_payment, name='process_payment'),
    path('payment_success/', views.payment_success, name='payment_success'),

    # Admin Features
    path('admin/', admin.site.urls),
    path('admin-dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('manage-products/', views.manage_products, name='manage_products'), 

    # API Endpoints
    path('api/', include(router.urls)),
]