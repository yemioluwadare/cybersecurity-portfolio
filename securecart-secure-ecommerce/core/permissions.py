from rest_framework import permissions

class IsAdminOrReadOnly(permissions.BasePermission):
    """
    Allows full access to admins, but only read access for regular users.
    """

    def has_permission(self, request, view):
        # Admins have full permissions
        if request.user.is_authenticated and request.user.is_admin():
            return True
        
        # Allow GET requests for all users (including non-authenticated)
        return request.method in permissions.SAFE_METHODS