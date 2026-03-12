from django.contrib import admin
from .models import Product, Cart, Order, CustomUser 
from django.contrib.auth.admin import UserAdmin
from django.contrib.admin import TabularInline, AdminSite 
from django.contrib.auth.decorators import user_passes_test

class OrderInline(TabularInline):
    model = Order
    extra = 1 

# Product Admin 
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'stock')  # Removed 'category' to avoid errors if missing
    search_fields = ('name',)  # Removed 'category' if it doesn't exist
    list_filter = ('price',)  # Avoid filtering by 'category' if it doesn't exist
    inlines = [OrderInline]

# Cart Admin
class CartAdmin(admin.ModelAdmin):
    list_display = ('user', 'product', 'quantity')
    list_filter = ('user',)

# Order Admin
class OrderAdmin(admin.ModelAdmin):
    list_display = ('user', 'total_amount', 'status', 'created_at')
    list_filter = ('status',)

# Custom Admin Site 
class SecureCartAdminSite(AdminSite):
    site_header = "SecureCart Admin Panel"
    site_title = "SecureCart Dashboard"
    index_title = "Welcome to SecureCart Admin"

# CustomUser Admin (Ensure `role` field exists in CustomUser model)
class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email', 'role', 'is_staff')
    list_filter = ('role', 'is_staff')
    fieldsets = UserAdmin.fieldsets + (
        ('User Role', {'fields': ('role',)}),
    )

# Registering Models 
admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(Product, ProductAdmin)
admin.site.register(Cart, CartAdmin)
admin.site.register(Order, OrderAdmin)

# Admin Restriction - Ensures only staff can access admin panel
def admin_required(user):
    return user.is_staff

admin.site.login = user_passes_test(admin_required)(admin.site.login)