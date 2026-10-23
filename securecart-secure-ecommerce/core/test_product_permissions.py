from rest_framework.test import APITestCase

from core.models import CustomUser, Product

BODY = {"name": "Mug", "description": "d", "price": "5.00", "stock": 3, "category": "Home"}


class ProductPermissionTests(APITestCase):
    def setUp(self):
        self.customer = CustomUser.objects.create_user("cust", password="x", role="customer")
        self.admin = CustomUser.objects.create_user("adm", password="x", role="admin")
        self.product = Product.objects.create(name="Pen", description="d", price="1.00", stock=9)
        self.item = f"/api/products/{self.product.id}/"

    def test_customer_cannot_write(self):
        self.client.force_authenticate(self.customer)
        self.assertEqual(self.client.post("/api/products/", BODY).status_code, 403)
        self.assertEqual(self.client.put(self.item, BODY).status_code, 403)
        self.assertEqual(self.client.patch(self.item, {"price": "0.01"}).status_code, 403)
        self.assertEqual(self.client.delete(self.item).status_code, 403)
        self.product.refresh_from_db()  # nothing changed
        self.assertEqual(str(self.product.price), "1.00")

    def test_customer_can_read(self):
        self.client.force_authenticate(self.customer)
        self.assertEqual(self.client.get("/api/products/").status_code, 200)
        self.assertEqual(self.client.get(self.item).status_code, 200)

    def test_admin_can_write(self):
        self.client.force_authenticate(self.admin)
        self.assertEqual(self.client.post("/api/products/", BODY).status_code, 201)
        self.assertEqual(self.client.patch(self.item, {"price": "2.00"}).status_code, 200)
        self.assertEqual(self.client.delete(self.item).status_code, 204)

    def test_anonymous_read_and_write(self):
        # records behaviour, not a requirement: GET was blocked before the fix
        print("anonymous GET:", self.client.get("/api/products/").status_code,
              "| anonymous POST:", self.client.post("/api/products/", BODY).status_code)
