"""
Tests for the Django admin modifications
"""
from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from django.test import Client


class AdminSiteTests(TestCase):
    """"Tests for Django admin"""

    def setUp(self):
        """Create user and client."""
        self.client = Client()
        self.admin_user = get_user_model().objects.create_superuser(
            email='admin@example.com',
            password='testpass123',
        )
        self.client.force_login(self.admin_user)
        self.user = get_user_model().objects.create_user(
            email='user@example.com',
            password='testpass12',
            name='Test User',
        )

    def test_users_list(self):
        """Test that users are listed on the page."""
        url = reverse('admin:core_user_changelist')
        res = self.client.get(url)

        self.assertContains(res, self.user.name)
        self.assertContains(res, self.user.email)

    def test_normal_user_login(self):
        """Test if a normal user can log in."""
        login = self.client.login(
            email=self.user.email,
            password='testpass12')
        self.assertTrue(login)  # Assert the login was successful

    def test_normal_user_cannot_access_admin(self):
        """Test that a normal user cannot access the admin page."""
        self.client.logout()  # Ensure no one is logged in
        self.client.force_login(self.user)  # Log in as the normal user

        url = reverse('admin:core_user_changelist')
        res = self.client.get(url)

        self.assertNotEqual(res.status_code, 200)  # Should not return a 200 OK
        self.assertEqual(res.status_code, 403)
        # Should redirect to login or return forbidden

    def test_edit_user_page(self):
        """Test the edit user page works"""
        url = reverse('admin:core_user_change', args=[self.user.id])
        res = self.client.get(url)

        self.assertEqual(res.status_code, 200)
